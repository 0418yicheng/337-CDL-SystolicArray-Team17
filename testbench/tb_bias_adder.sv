`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_bias_adder ();

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

    logic [63:0] outputs, bias;
    logic done;
    logic [63:0] biased_outputs;
    logic bias_done;

    bias_adder DUT (.clk(clk), .n_rst(n_rst), 
                    .outputs(outputs), .bias(bias), .done(done), 
                    .biased_outputs(biased_outputs), .bias_done(bias_done));
    

    initial begin
        n_rst = 1;
        done = 0;
        outputs = 64'd0;
        bias = 64'd0;

        reset_dut;

        @(negedge clk);
        done = 1;
        bias = 64'h02_02_02_02_02_02_02_02;
        outputs = 64'h01_01_02_03_04_05_06_07;

        @(negedge clk);
        outputs = 64'h08_09_0A_0B_0C_0D_0E_0F;

        @(negedge clk);
        outputs = 64'h10_11_12_13_14_15_16_17;

        @(negedge clk);
        outputs = 64'h18_19_1A_1B_1C_1D_1E_1F; // Row 3
        
        @(negedge clk);
        outputs = 64'h20_21_22_23_24_25_26_27; // Row 4
        
        @(negedge clk);
        outputs = 64'h28_29_2A_2B_2C_2D_2E_2F; // Row 5

        @(negedge clk);
        outputs = 64'h30_31_32_33_34_35_36_37; // Row 6
        
        @(negedge clk);
        outputs = 64'h38_39_3A_3B_3C_3D_3E_3F;  // Row 7

        #(2*CLK_PERIOD);
        $finish;
    end
endmodule

/* verilator coverage_on */

