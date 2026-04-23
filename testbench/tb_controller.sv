`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_controller ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst, read, start_inference, write, load_weights, input_write, weight_write, buffer_occupancy, load_input, load_weight, ready, weights_loaded, input_read, weight_read, output_read, overrun, inference_done, new_input;
    logic [9:0] addr_in;
    logic [63:0] controller_write, input_rdata, weight_rdata, output_rdata, controller_read, input_wdata, weight_wdata, output_wdata, array_in;
    logic [2:0] weight_row, input_row, output_row;
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
    task writerr;
    input logic [9:0] addr;
    input logic [63:0] data;
    begin
        @(negedge clk);
        write = 1;
        addr_in = addr;
        controller_write = data;
        @(negedge clk);
        write = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

    end
    endtask
    controller #() DUT (.*);

    initial begin
        read = 0;
        start_inference = 0;
        write = 0;
        load_weights = 0;
        addr_in = '0;
        controller_write = '0;
        input_rdata = '0;
        weight_rdata = '0;
        output_rdata = '0;
        inference_done = 0;
        n_rst = 1;
        reset_dut;
        @(negedge clk);
        test_name = "Write inputs";
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        writerr(10'd1, 64'hABCDABCDABCDABCD);
        test_name = "Write weights + buffer occupancy";
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        writerr(10'd0, 64'hABCDABCDABCDABCD);
        test_name = "Load weights to systolic array";
        load_weights = 1;
        @(negedge clk);
        load_weights = 0;
        repeat(30) @(negedge clk);
        test_name = "Start inference";
        start_inference = 1;
        @(negedge clk);
        start_inference = 0;
        repeat(60) @(negedge clk);
        $finish;
    end
endmodule

/* verilator coverage_on */

