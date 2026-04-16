`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_tester ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst, read, write, start_inference, load_weights, done;
    logic [9:0] addr_in;
    logic [63:0] controller_write, activations;
    logic buffer_occupancy, load_input, load_weight, ready, weights_loaded, overrun;
    logic [63:0] controller_read, array_in;

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
    task writepls;
    input logic [9:0] addr;
    input logic [63:0] data;
    begin
        @(posedge clk);
        write = 1;
        addr_in = addr;
        controller_write = data;
        @(posedge clk);
        write = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
    end
    endtask
    task readpls;
    begin
        @(posedge clk);
        read = 1;
        @(posedge clk);
        read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
    end
    endtask
    tester #() DUT (.*);

    initial begin
        n_rst = 1;
        read = 0;
        write = 0;
        start_inference = 0;
        load_weights = 0;
        done = 0;
        addr_in = '0;
        controller_write = '0;
        activations = '0;
        reset_dut;
        // writepls(10'd1, 64'hABCDABCDABCDABCD);
        // writepls(10'd1, 64'hFFFFFFFFFFFFFFFF);
        //writepls(10'd1, 64'hAAAAAAAAAAAAAAAA);
        // writepls(10'd1, 64'hDDDDDDDDDDDDDDDD);
        // writepls(10'd1, 64'hCCCCCCCCCCCCCCCC);
        // writepls(10'd1, 64'h7777777777777777);
        // writepls(10'd1, 64'h8888888888888888);
        // writepls(10'd1, 64'h9999999999999999);
        // @(posedge clk);
        // start_inference = 1;
        // @(posedge clk);
        // start_inference = 0;
        // repeat(30) @(negedge clk);
        @(negedge clk);
        done = 1;
        @(negedge clk);
        @(negedge clk);
        done = 0;
        activations = 64'h1111111111111111;
        @(negedge clk);
        done = 0;
        activations = 64'h2222222222222222;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        readpls();
        readpls();
        $finish;
    end
endmodule

/* verilator coverage_on */

