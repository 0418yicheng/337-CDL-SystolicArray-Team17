`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ahb_accelerator ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    string test_name;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        ready = 1;
        inference_done = 0;
        weights_loaded = 0;
        crdata = 64'h0;
        boe = 0;
        oe = 0;
        nan_flag = 0;
        inf_flag = 0;

        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    // bus model signals
    logic enqueue_transaction_en;
    logic transaction_write;
    logic transaction_fake;
    logic [9:0] transaction_addr;
    logic [63:0] transaction_data;
    logic transaction_error;
    logic [2:0] transaction_size; 

    logic model_reset;
    logic enable_transactions;
    integer current_transaction_num;
    logic current_transaction_error;

    logic hsel;
    logic [1:0] htrans;
    logic [9:0] haddr;
    logic [2:0] hsize; 
    logic hwrite;
    logic [63:0] hwdata;
    logic [63:0] hrdata;
    logic hready; 
    logic hresp;

    ahb_model #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(10)
    ) BFM (
        .clk(clk),
        .enqueue_transaction(enqueue_transaction_en),
        .transaction_write(transaction_write),
        .transaction_fake(transaction_fake),
        .transaction_addr(transaction_addr),
        .transaction_data(transaction_data),
        .transaction_error(transaction_error),
        .transaction_size(transaction_size),
        .model_reset(model_reset),
        .enable_transactions(enable_transactions),
        .current_transaction_num(current_transaction_num),
        .current_transaction_error(current_transaction_error),
        .hsel(hsel),
        .htrans(htrans),
        .haddr(haddr),
        .hsize(hsize),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hresp(hresp)
    );

    ahb_accelerator DUT (
        .clk(clk),
        .n_rst(n_rst),
        .hsel(hsel),
        .haddr(haddr),
        .htrans(htrans),
        .hsize(hsize[1:0]), 
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hready(hready),
        .hresp(hresp)
    );

    // bus model tasks
    task reset_model;
    begin
        model_reset = 1'b1;
        #(0.1);
        model_reset = 1'b0;
    end
    endtask
    
    task enqueue_transaction;
        input logic for_dut;
        input logic write_mode;
        input logic [9:0] address;
        input logic [63:0] data;
        input logic expected_error;
        input logic [2:0] size;
    begin
        enqueue_transaction_en = 1'b0;
        #(0.1ns);
    
        transaction_fake  = ~for_dut;
        transaction_write = write_mode;
        transaction_addr  = address;
        transaction_data  = data;
        transaction_error = expected_error;
        transaction_size  = size;
    
        enqueue_transaction_en = 1'b1;
        #(0.1ns);
        enqueue_transaction_en = 1'b0;
    end
    endtask
    
    task execute_transactions;
        input integer num_transactions;
        integer wait_var;
    begin
        enable_transactions = 1'b1;
        @(posedge clk);
    
        for(wait_var = 0; wait_var < num_transactions; wait_var++) begin
            @(posedge clk);
        end
    
        @(posedge clk);
    
        @(negedge clk);
        enable_transactions = 1'b0;
    end
    endtask

    initial begin
        model_reset = 1'b0;
        enable_transactions = 1'b0;
        enqueue_transaction_en = 1'b0;
        transaction_write = 1'b0;
        transaction_fake = 1'b0;
        transaction_addr = '0;
        transaction_data = '0;
        transaction_error = 1'b0;
        transaction_size = 3'd0;

        reset_model();
        reset_dut();

        // Loading Inputs
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0100_0000_0000_0000, 1'b0, 3'b011);
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0001_0000_0000_0000, 1'b0, 3'b011);
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0000_0100_0000_0000, 1'b0, 3'b011);
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0000_0001_0000_0000, 1'b0, 3'b011);
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0000_0000_0100_0000, 1'b0, 3'b011);
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0000_0000_0001_0000, 1'b0, 3'b011);
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0000_0000_0000_0100, 1'b0, 3'b011);
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h0000_0000_0000_0001, 1'b0, 3'b011);
        execute_transactions(8);

        $finish;
    end
endmodule

/* verilator coverage_on */

