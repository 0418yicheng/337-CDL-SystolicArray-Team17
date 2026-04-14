`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_systolic_array ();

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

    logic load_inputs, load_weights;
    logic [63:0] inputs;
    logic nan, inf;
    logic [63:0] outputs;
    logic busy, done;
    systolic_array DUT (.clk(clk), .n_rst(n_rst), 
                        .load_inputs(load_inputs), .load_weights(load_weights), .inputs(inputs), 
                        .nan(nan), .inf(inf), .outputs(outputs), .busy(busy), .done(done));

    task write_weights;
        input logic[63:0] rows [7:0];
        integer i;
        @(negedge clk); //Start the FSM. Need one cycle to actually start
        load_weights = 1;
        begin
            for(i = 0; i < 8; i++) begin
                @(negedge clk);
                load_weights = 1;
                inputs = rows[i];
                @(negedge clk);
                load_weights = 0;
                #(CLK_PERIOD);
            end
        end
    endtask

    task write_inputs;
        input logic [63:0] in;
        integer i;
        begin
            @(negedge clk);
            load_inputs = 1;
            inputs = in;

            #(CLK_PERIOD * 10);

            @(negedge clk);
            load_inputs = 0;
        end
    endtask

    initial begin
        n_rst = 1;
        load_weights = 0;
        load_inputs = 0;
        inputs = 64'd0;

        reset_dut;

        write_weights({{64'h0001}, {64'h0008}, {64'h0010}, {64'h0080}, {64'h0100}, {64'h0800}, {64'h1000}, {64'h8000}});

        #(CLK_PERIOD * 2)

        // write_inputs(64'd000000000000000000000000000000000000100000000110000001000000001);

        $finish;
    end
endmodule

/* verilator coverage_on */

