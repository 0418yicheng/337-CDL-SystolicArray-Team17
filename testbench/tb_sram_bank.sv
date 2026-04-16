`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_sram_bank ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst, read_write, start, transaction_done;
    logic [3:0] address_in;
    logic [63:0] wdata_in, rdata_out;
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

    sram_bank #() DUT (.*);

    initial begin
        read_write = 0;
        start = 0;
        address_in = '0;
        wdata_in = '0;
        n_rst = 1;

        reset_dut;
        // Writing to address 0
        @(negedge clk);
        read_write = 1;
        start = 1;
        address_in = 4'b0000;
        wdata_in = 64'hFFFFFFFFAAAAAAAA;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        // Writing to address 1
        read_write = 1;
        start = 1;
        address_in = 4'b0001;
        wdata_in = 64'hABCDABCDABCDABCD;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        // Reading from address 1
        read_write = 0;
        start = 1;
        address_in = 4'b0001;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        read_write = 0;
        start = 1;
        address_in = 4'b0000;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        $finish;
    end
endmodule

/* verilator coverage_on */

