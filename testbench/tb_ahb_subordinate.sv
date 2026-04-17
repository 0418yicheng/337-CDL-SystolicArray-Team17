`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ahb_subordinate ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    string test_name;

    logic ready;
    logic inference_done;
    logic weights_loaded;
    logic [63:0] crdata;
    logic boe;
    logic oe;
    logic nan_flag;
    logic inf_flag;

    logic [63:0] cwdata;
    logic [9:0] caddr;
    logic cwrite;
    logic cread;
    logic [63:0] bias;
    logic [1:0] activation_mode;

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

    ahb_subordinate DUT (
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
        .hresp(hresp),
        .ready(ready),
        .inference_done(inference_done),
        .weights_loaded(weights_loaded),
        .crdata(crdata),
        .cwdata(cwdata),
        .caddr(caddr),
        .cwrite(cwrite),
        .cread(cread),
        .bias(bias),
        .activation_mode(activation_mode),
        .boe(boe),
        .oe(oe),
        .nan_flag(nan_flag),
        .inf_flag(inf_flag)
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

        test_name = "1. Write/Read Bias Register (64-bit Full Vector)";
        enqueue_transaction(1'b1, 1'b1, 10'h010, 64'h1122334455667788, 1'b0, 3'b011); 
        execute_transactions(1);
        enqueue_transaction(1'b1, 1'b0, 10'h010, 64'h1122334455667788, 1'b0, 3'b011); 
        execute_transactions(1);

        test_name = "2. Partial Word Masking (Byte-Lane Shifting on Bias)";
        enqueue_transaction(1'b1, 1'b1, 10'h012, 64'h0000_0000_AAAA_0000, 1'b0, 3'b001);
        execute_transactions(1);
        enqueue_transaction(1'b1, 1'b0, 10'h010, 64'h11223344AAAA7788, 1'b0, 3'b011);
        execute_transactions(1);

        test_name = "3. Control Registers (Strict Byte Lane Aligned)";
        enqueue_transaction(1'b1, 1'b1, 10'h022, 64'h0000_0000_0003_0000, 1'b0, 3'b000); 
        execute_transactions(1);
        enqueue_transaction(1'b1, 1'b1, 10'h024, 64'h0000_0002_0000_0000, 1'b0, 3'b000); 
        execute_transactions(1);
        enqueue_transaction(1'b1, 1'b0, 10'h022, 64'h0000_0000_0003_0000, 1'b0, 3'b000); 
        execute_transactions(1);

        test_name = "4. RAW Hazard on Bias";
        enqueue_transaction(1'b1, 1'b1, 10'h010, 64'hAAAA_BBBB_CCCC_DDDD, 1'b0, 3'b011); 
        enqueue_transaction(1'b1, 1'b0, 10'h010, 64'hAAAA_BBBB_CCCC_DDDD, 1'b0, 3'b011); 
        execute_transactions(2);

        test_name = "5. Status and Latching Error Flags (Clear on Read)";
        @(negedge clk);
        ready = 1'b0;
        inference_done = 1'b1;
        
        // Pulse Error inputs high for  ONE cycle
        boe = 1'b1;
        inf_flag = 1'b1;
        @(negedge clk);
        boe = 1'b0;
        inf_flag = 1'b0;
        
        // Read Status (0x23) -> Expect {busy=1, done=1} on Byte 3
        enqueue_transaction(1'b1, 1'b0, 10'h023, 64'h0000000003000000, 1'b0, 3'b000); 
        execute_transactions(1);
        
        // Read Error (0x20) -> Bit 0=boe, Bit 9=inf on Bytes 0 & 1
        enqueue_transaction(1'b1, 1'b0, 10'h020, 64'h0000000000000201, 1'b0, 3'b001); 
        execute_transactions(1);

        // Check latched errors are cleared
        enqueue_transaction(1'b1, 1'b0, 10'h020, 64'h0000000000000000, 1'b0, 3'b001); 
        execute_transactions(1);

        @(negedge clk);
        ready = 1'b1;
        
        test_name = "6. Error: Read from Write-Only Register (Inputs 0x08)";
        enqueue_transaction(1'b1, 1'b0, 10'h008, 64'h0, 1'b1, 3'b011); 
        execute_transactions(1);

        test_name = "7. Error: Write to Read-Only Register (Outputs 0x18)";
        enqueue_transaction(1'b1, 1'b1, 10'h018, 64'hFFFF, 1'b1, 3'b011); 
        execute_transactions(1);

        test_name = "8. Error: Write to Read-Only Register (Error 0x20)";
        enqueue_transaction(1'b1, 1'b1, 10'h020, 64'hFFFF, 1'b1, 3'b011); 
        execute_transactions(1);

        test_name = "9. Error: Out of Bounds Access";
        enqueue_transaction(1'b1, 1'b1, 10'h030, 64'hFFFF, 1'b1, 3'b011); 
        execute_transactions(1);

        test_name = "10. Error: Busy Access Violation & Internal 'ft' Latch";
        @(negedge clk);
        ready = 1'b0; 
        
        // Try to Write to Inputs (0x08) while busy
        enqueue_transaction(1'b1, 1'b1, 10'h008, 64'h1234, 1'b1, 3'b011); 
        execute_transactions(1);

        @(negedge clk);
        ready = 1'b1;

        // Make sure failed transfer error is latched
        enqueue_transaction(1'b1, 1'b0, 10'h020, 64'h0000_0000_0000_0008, 1'b0, 3'b001); 
        execute_transactions(1);

        $finish;
    end
endmodule

/* verilator coverage_on */