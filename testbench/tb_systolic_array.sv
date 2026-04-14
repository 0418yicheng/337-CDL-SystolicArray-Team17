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
        input logic [63:0] in [7:0];
        integer i;
        begin
            for(i = 0; i < 8; i++) begin
                @(negedge clk);
                load_inputs = 1;
                inputs = in[i];

                @(negedge clk);
                load_inputs = 0;
                
                #(2*CLK_PERIOD);
            end
        end

        #(CLK_PERIOD * 15);
        #(CLK_PERIOD * 2);
    endtask

    initial begin
        n_rst = 1;
        load_weights = 0;
        load_inputs = 0;
        inputs = 64'd0;

        reset_dut;

        write_weights('{
            64'h01_00_00_00_00_00_00_00, // Row 0: Only byte 0 is 1
            64'h00_01_00_00_00_00_00_00, // Row 1: Only byte 1 is 1
            64'h00_00_01_00_00_00_00_00, // Row 2: ...
            64'h00_00_00_01_00_00_00_00,
            64'h00_00_00_00_01_00_00_00,
            64'h00_00_00_00_00_01_00_00,
            64'h00_00_00_00_00_00_01_00,
            64'h00_00_00_00_00_00_00_01  // Row 7: Only byte 7 is 1
        });

        

        #(CLK_PERIOD * 2)

        write_inputs('{
            64'h01_01_02_03_04_05_06_07, // Row 0
            64'h08_09_0A_0B_0C_0D_0E_0F, // Row 1
            64'h10_11_12_13_14_15_16_17, // Row 2
            64'h18_19_1A_1B_1C_1D_1E_1F, // Row 3
            64'h20_21_22_23_24_25_26_27, // Row 4
            64'h28_29_2A_2B_2C_2D_2E_2F, // Row 5
            64'h30_31_32_33_34_35_36_37, // Row 6
            64'h38_39_3A_3B_3C_3D_3E_3F  // Row 7
        });

        $finish;
    end
endmodule

/* verilator coverage_on */

