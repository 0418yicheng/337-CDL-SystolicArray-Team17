`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ahb_accelerator ();

    localparam CLK_PERIOD = 10ns;
    localparam TIMEOUT = 1000;


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
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    // bus model signals
    logic hsel;
    logic [9:0] haddr;
    logic [2:0] hsize;
    logic [2:0] hburst;
    logic [1:0] htrans;
    logic hwrite;
    logic [63:0] hwdata;
    logic [63:0] hrdata;
    logic hresp;
    logic hready;

    ahb_model_updated #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(10)
    ) BFM ( .clk(clk),
        // AHB-Subordinate Side
        .hsel(hsel),
        .haddr(haddr),
        .hsize(hsize),
        .htrans(htrans),
        .hburst(hburst),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hresp(hresp),
        .hready(hready)
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

    // Supporting Tasks
    task reset_model;
        BFM.reset_model();
    endtask

    // Read from a register without checking the value
    task enqueue_poll ( input logic [9:0] addr, input logic [2:0] size );
    logic [63:0] data [];
        begin
            data = new [1];
            data[0] = {32'hXXXX};
            //              Fields: hsel,  R/W, addr, data, exp err,         size, burst, chk prdata or not
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data,    1'b0, {1'b0, size},  3'b0,            1'b0);
        end
    endtask

    // Read from a register until a requested value is observed
    task poll_until ( input logic [9:0] addr, input logic [2:0] size, input logic [63:0] data);
        int iters;
        begin
            for (iters = 0; iters < TIMEOUT; iters++) begin
                enqueue_poll(addr, size);
                execute_transactions(1);
                if(BFM.get_last_read() == data) break;
            end
            if(iters >= TIMEOUT) begin
                $error("Bus polling timeout hit.");
            end
        end
    endtask

    // Read Transaction, verifying a specific value is read
    task enqueue_read ( input logic [9:0] addr, input logic [2:0] size, input logic [63:0] exp_read );
        logic [63:0] data [];
        begin
            data = new [1];
            data[0] = exp_read;
            BFM.enqueue_transaction(1'b1, 1'b0, addr, data, 1'b0, size, 3'b0, 1'b1);
        end
    endtask

    // Write Transaction
    task enqueue_write ( input logic [9:0] addr, input logic [2:0] size, input logic [63:0] wdata );
        logic [63:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b1, 1'b1, addr, data, 1'b0, size, 3'b0, 1'b0);
        end
    endtask

    // Write Transaction Intended for a different subordinate from yours
    task enqueue_fakewrite ( input logic [9:0] addr, input logic [2:0] size, input logic [63:0] wdata );
        logic [63:0] data [];
        begin
            data = new [1];
            data[0] = wdata;
            BFM.enqueue_transaction(1'b0, 1'b1, addr, data, 1'b0, {1'b0, size}, 3'b0, 1'b0);
        end
    endtask

    // Create a burst read of size based on the burst type.
    // If INCR, burst size dependent on dynamic array size
    task enqueue_burst_read ( input logic [3:0] base_addr, input logic [2:0] size, input logic [2:0] burst, input logic [63:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b0, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Create a burst write of size based on the burst type.
    task enqueue_burst_write ( input logic [3:0] base_addr, input logic [2:0] size, input logic [2:0] burst, input logic [63:0] data [] );
        BFM.enqueue_transaction(1'b1, 1'b1, base_addr, data, 1'b0, {1'b0, size}, burst, 1'b1);
    endtask

    // Run n transactions, where a k-beat burst counts as k transactions.
    task execute_transactions (input int num_transactions);
        BFM.run_transactions(num_transactions);
    endtask

    // Finish the current transaction
    task finish_transactions();
        BFM.wait_done();
    endtask

    initial begin
        reset_model();
        reset_dut();

        // Loading Inputs
        test_name = "Set Inputs";
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        enqueue_write(10'h008, 3'b011, 64'h38_38_38_38_38_38_38_38);
        execute_transactions(8);
        finish_transactions();
        #(CLK_PERIOD * 5);
        // // Loading Weights
        test_name = "Set Weights";
        enqueue_write(10'h000, 3'b011, 64'h38_00_00_00_00_00_00_00);
        enqueue_write(10'h000, 3'b011, 64'h00_38_00_00_00_00_00_00);
        enqueue_write(10'h000, 3'b011, 64'h00_00_38_00_00_00_00_00);
        enqueue_write(10'h000, 3'b011, 64'h00_00_00_38_00_00_00_00);
        enqueue_write(10'h000, 3'b011, 64'h00_00_00_00_38_00_00_00);
        enqueue_write(10'h000, 3'b011, 64'h00_00_00_00_00_38_00_00);
        enqueue_write(10'h000, 3'b011, 64'h00_00_00_00_00_00_38_00);
        enqueue_write(10'h000, 3'b011, 64'h04_00_00_00_00_00_00_38);
        execute_transactions(8);
        finish_transactions();
        #(CLK_PERIOD * 5);

        test_name = "Load Biases";
        enqueue_write(10'h010, 3'b011, 64'h0); // Biases
        execute_transactions(1);
        finish_transactions();
        test_name = "Activation: Identity";
        enqueue_write(10'h024, 3'b000, 64'h0000_0000_0000_0002); // Activation: Identity
        execute_transactions(1);
        finish_transactions();
        test_name = "Load Weights";
        enqueue_write(10'h022, 3'b000, 64'h0000_0000_0000_0002); // Load Weights
        execute_transactions(1);
        finish_transactions();
        test_name = "Start Inference";
        enqueue_write(10'h022, 3'b000, 64'h0000_0000_0000_0001); // Start Inference
        execute_transactions(1);
        finish_transactions();
        #(CLK_PERIOD * 150);

        enqueue_read(10'h018, 3'b011, 64'h0203_0404_0203_0203); // Read Output
        execute_transactions(1);
        finish_transactions();

        #(CLK_PERIOD * 10);

        $finish;
    end
endmodule

/* verilator coverage_on */

