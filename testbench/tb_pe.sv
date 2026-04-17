`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_pe ();

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

    logic load_weight, load_input;
    logic [7:0] in_weight, in, input_sum;
    logic [7:0] input_out, sum;    
    logic inf, nan;
    pe #() DUT (.clk(clk), .n_rst(n_rst), 
                .load_weight(load_weight), .load_input(load_input), 
                .in_weight(in_weight), .in(in), .input_sum(input_sum), 
                .input_out(input_out), .sum(sum), 
                .inf(inf), .nan(nan));

    task load_weights;
        input logic[7:0] weight;
        begin
            @(negedge clk);
            load_weight = 1;
            in_weight = weight;

            @(negedge clk);
            load_weight = 0;
        end
    endtask

    task load_inputs;
        input logic[7:0] task_in, task_sum;
        begin
            @(negedge clk);
            load_input = 1;
            in = task_in;
            input_sum = task_sum;

            @(negedge clk);
            load_input = 0;
        end
    endtask

    initial begin
        n_rst = 1;
        load_weight = 0;
        load_input = 0;
        in = 8'd0;
        in_weight = 8'd0;
        input_sum = 8'd0;

        reset_dut;

        //Sys Debugging Tests
        load_weights(8'b0);
        load_inputs(8'h3c, 8'd0);   //Wrong Output
        load_inputs(8'h30, 8'd0);
        load_inputs(8'h28, 8'd0);
        load_inputs(8'h3a, 8'd0);   //Wrong Output


        // Test multiplication
        load_weights(8'b0_0110_000); //Float representation of 0.5
        load_inputs(8'b0_0111_100, 8'd0);   //Float representation of 1.5

        //Test addition
        load_inputs(8'b0_0111_000, 8'b0_0101_000);  //In = 1, input sum = 0.25

        //Test negative logic
        load_inputs(8'b1_0111_100, 8'd0);   //-1.5
        load_inputs(8'b0_0111_100, 8'b1_0111_000);  //+1.5, -1

        //Test inf
        load_weights(8'b0_1110_000);
        load_inputs(8'b0_1000_000, 8'd0);

        //Test nan
        load_weights(8'b0_0111_000);
        load_inputs(8'b0_0111_000, 8'b0_1111_010);

        //This should be nan too, save edge cases for later
        load_weights(8'b0_1111_000);
        load_inputs(8'b0_0111_000, 8'b1_1111_000);

        #(CLK_PERIOD * 2);


        $finish;
    end
endmodule

/* verilator coverage_on */

