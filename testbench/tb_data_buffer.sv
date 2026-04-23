`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_data_buffer ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst, input_write, input_read, output_read, weight_write, weight_read, done, new_input, inference_done;
    logic [2:0] weight_row, input_row, output_row, input_count;
    logic [63:0] input_wdata, weight_wdata, activations, input_rdata, weight_rdata, output_rdata;
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
    task read_write_input;
        input logic read_write;
        input logic [2:0] row;
        input logic [63:0] data;
        @(negedge clk);
    if (read_write) begin
        input_write = 1;
        input_row = row;
        input_wdata = data;
    end else  begin
        input_read = 1;
        input_row = row;
        input_wdata = data;
    end
        @(negedge clk);
        input_write = 0;
        input_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
    endtask
    task read_write_weight;
        input logic read_write;
        input logic [2:0] row;
        input logic [63:0] data;
        @(negedge clk);
    if (read_write) begin
        weight_write = 1;
        weight_row = row;
        weight_wdata = data;
    end else  begin
        weight_read = 1;
        weight_row = row;
        weight_wdata = data;
    end
        @(negedge clk);
        weight_write = 0;
        weight_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
    endtask
    data_buffer #() DUT (.*);

    initial begin
        n_rst = 1;
        input_write = 0;
        input_read = 0;
        output_read = 0;
        weight_write = 0;
        weight_read = 0;
        weight_row = '0;
        input_row = '0;
        output_row = '0;
        input_wdata = '0;
        weight_wdata = '0;
        activations = '0;
        done = 0;
        reset_dut;
        test_name = "Testing 8 writes and 8 reads for input. It takes 23 cycles to read 8 things out";
        read_write_input(1, 3'b0, 64'hAAAABBBBCCCCDDDD);
        @(negedge clk);
        read_write_input(1, 3'd1, 64'hFFFFFFFFAAAAAAAA);
        @(negedge clk);
        read_write_input(1, 3'd2, 64'hACBDACBDACBDACBD);
        @(negedge clk);
        read_write_input(1, 3'd3, 64'hBBBBCCCCDDDDAAAA);
        @(negedge clk);
        read_write_input(1, 3'd4, 64'hAAAAAAAAAAAAAAAA);
        @(negedge clk);
        read_write_input(1, 3'd5, 64'hCCCCCCCCCCCCCCCC);
        @(negedge clk);
        read_write_input(1, 3'd6, 64'hDDDDDDDDDDDDDDDD);
        @(negedge clk);
        read_write_input(1, 3'd7, 64'hFFFFFFFFFFFFFFFF);
        @(negedge clk);
        input_read = 1;
        input_row = 3'd0;
        @(negedge clk);
        input_row = 3'd1;
        @(negedge clk);
        input_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        input_read = 1;
        input_row = 3'd2;
        @(negedge clk);
        input_row = 3'd3;
        @(negedge clk);
        input_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        input_read = 1;
        input_row = 3'd4;
        @(negedge clk);
        input_row = 3'd5;
        @(negedge clk);
        input_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        input_read = 1;
        input_row = 3'd6;
        @(negedge clk);
        input_row = 3'd7;
        @(negedge clk);
        input_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        test_name = "Testing writing and reading 8 weights. It takes 23 cycles to read things out";
        read_write_weight(1, 3'b0, 64'hAAAABBBBCCCCDDDD);
        @(negedge clk);
        read_write_weight(1, 3'd1, 64'hFFFFFFFFAAAAAAAA);
        @(negedge clk);
        read_write_weight(1, 3'd2, 64'hACBDACBDACBDACBD);
        @(negedge clk);
        read_write_weight(1, 3'd3, 64'hBBBBCCCCDDDDAAAA);
        @(negedge clk);
        read_write_weight(1, 3'd4, 64'hAAAAAAAAAAAAAAAA);
        @(negedge clk);
        read_write_weight(1, 3'd5, 64'hCCCCCCCCCCCCCCCC);
        @(negedge clk);
        read_write_weight(1, 3'd6, 64'hDDDDDDDDDDDDDDDD);
        @(negedge clk);
        read_write_weight(1, 3'd7, 64'hFFFFFFFFFFFFFFFF);
        @(negedge clk);
        @(posedge clk);
        weight_read = 1;
        weight_row = 3'd0;
        @(posedge clk);
        weight_row = 3'd1;
        @(posedge clk);
        weight_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(posedge clk);
        weight_read = 1;
        weight_row = 3'd2;
        @(posedge clk);
        weight_read = 1;
        weight_row = 3'd3;
        @(posedge clk);
        weight_read = 0;

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        // @(negedge clk);
        // weight_read = 1;
        // weight_row = 3'd0;
        // @(negedge clk);
        // weight_row = 3'd1;
        // @(negedge clk);
        // weight_read = 0;
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // weight_read = 1;
        // weight_row = 3'd2;
        // @(negedge clk);
        // weight_row = 3'd3;
        // @(negedge clk);
        // weight_read = 0;
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // weight_read = 1;
        // weight_row = 3'd4;
        // @(negedge clk);
        // weight_row = 3'd5;
        // @(negedge clk);
        // weight_read = 0;
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // weight_read = 1;
        // weight_row = 3'd6;
        // @(negedge clk);
        // weight_row = 3'd7;
        // @(negedge clk);
        // weight_read = 0;
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        // @(negedge clk);
        test_name = "Testing getting outputs from systolic array";
        @(negedge clk);
        done = 1;
        @(negedge clk);
        done = 1;
        @(negedge clk);
        activations = 64'hDDDDEEEEFFFFAAAA;
        done = 0;
        @(negedge clk);
        activations = 64'hCCCCCCCCCCCCCCCC;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        output_row = 3'd0;
        @(negedge clk);
        output_row = 3'd1;
        @(negedge clk);
        output_read = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        $finish;
    end
endmodule

/* verilator coverage_on */

