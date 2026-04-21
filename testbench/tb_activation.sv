`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_activation ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;

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

    logic [3:0] activation_mode;

    logic [63:0] biased_outputs;
    logic bias_done;
    logic [63:0] activation_outputs;
    logic activation_done;
    activation #() DUT (.clk(clk), .n_rst(n_rst), 
                        .activation_mode(activation_mode), .biased_outputs(biased_outputs), .bias_done(bias_done), 
                        .activation_outputs(activation_outputs), .activation_done(activation_done));

    task load_bias_outputs;
        input logic [63:0] outputs [7:0];
        input logic [3:0] mode;
        begin
            for(int i = 0; i < 8; i++) begin
                @(negedge clk);
                bias_done = 1;
                activation_mode = mode;
                biased_outputs = outputs[i];
            end
            bias_done = 0;
            #(CLK_PERIOD * 2);
        end
    endtask

    initial begin
        n_rst = 1;
        activation_mode = 4'd0;
        biased_outputs = 64'd0;
        bias_done = 0;

        reset_dut;

        load_bias_outputs('{
            64'h01_01_02_03_04_05_06_07, // Row 0
            64'h08_09_0A_0B_0C_0D_0E_0F, // Row 1
            64'h10_11_12_13_14_15_16_17, // Row 2
            64'h18_19_1A_1B_1C_1D_1E_1F, // Row 3
            64'h20_21_22_23_24_25_26_27, // Row 4
            64'h28_29_2A_2B_2C_2D_2E_2F, // Row 5
            64'h30_31_32_33_34_35_36_37, // Row 6
            64'h38_39_3A_3B_3C_3D_3E_3F  // Row 7
        }, 4'd0);

        load_bias_outputs('{
            64'h0b8_b8_b8_b8_b8_b8_b8_b8, // Row 0
            64'h08_09_0A_0B_0C_0D_0E_0F, // Row 1
            64'h10_11_12_13_14_15_16_17, // Row 2
            64'h18_19_1A_1B_1C_1D_1E_1F, // Row 3
            64'h20_21_22_23_24_25_26_27, // Row 4
            64'h28_29_2A_2B_2C_2D_2E_2F, // Row 5
            64'h30_31_32_33_34_35_36_37, // Row 6
            64'h38_39_3A_3B_3C_3D_3E_3F  // Row 7
        }, 4'd3);

        

        $finish;
    end
endmodule

/* verilator coverage_on */

