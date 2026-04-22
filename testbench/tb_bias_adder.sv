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
        outputs = 64'h00_28_30_38_3c_3e_00_00;


        @(negedge clk);
        outputs = 64'h00_00_28_30_38_3c_3e_00;

        @(negedge clk);
        outputs = 64'h00_28_30_38_3c_3e_00_00;

        @(negedge clk);
        outputs = 64'h28_30_38_3c_3e_00_00_00;
        
        @(negedge clk);
        outputs = 64'h30_38_3c_3e_00_00_00_28;
        
        @(negedge clk);
        outputs = 64'h38_3c_3e_00_00_00_28_30;

        @(negedge clk);
        outputs = 64'h3c_3e_00_00_00_28_30_38;
        
        @(negedge clk);
        outputs = 64'h3e_00_00_00_28_30_38_3c;

        @(negedge clk);
        done = 0;

        #(2*CLK_PERIOD);

        @(negedge clk);
        done = 1;
        outputs = 64'h00_28_30_38_3c_3e_00_00;
        bias = 64'h30_30_30_30_30_30_30_30;


        @(negedge clk);
        outputs = 64'h00_00_28_30_38_3c_3e_00;

        @(negedge clk);
        outputs = 64'h00_28_30_38_3c_3e_00_00;

        @(negedge clk);
        outputs = 64'h28_30_38_3c_3e_00_00_00;
        
        @(negedge clk);
        outputs = 64'h30_38_3c_3e_00_00_00_28;
        
        @(negedge clk);
        outputs = 64'h38_3c_3e_00_00_00_28_30;

        @(negedge clk);
        outputs = 64'h3c_3e_00_00_00_28_30_38;
        
        @(negedge clk);
        outputs = 64'h3e_00_00_00_28_30_38_3c;

        @(negedge clk);
        done = 0;

        #(2*CLK_PERIOD);

        $finish;
    end
endmodule

/* verilator coverage_on */

