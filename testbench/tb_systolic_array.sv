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
                        .nan(nan), .inf(inf), .outputs(outputs), .done(done));

    task write_weights;
        input logic[63:0] rows [7:0];
        integer i;
        // @(negedge clk); //Start the FSM. Need one cycle to actually start
        // load_weights = 1;
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

        // write_weights('{
        //     64'h01_01_01_01_01_01_01_01, // Row 0: Only byte 0 is 1
        //     64'h02_02_02_02_02_02_02_02, // Row 1: Only byte 1 is 1
        //     64'h03_03_03_03_03_03_03_03, // Row 2: ...
        //     64'h04_04_04_04_04_04_04_04,
        //     64'h05_05_05_05_05_05_05_05,
        //     64'h06_06_06_06_06_06_06_06,
        //     64'h07_07_07_07_07_07_07_07,
        //     64'h08_08_08_08_08_08_08_08  // Row 7: Only byte 7 is 1
        // });
        write_weights('{ //1 = 0_0111_000
            64'h38_00_00_00_00_00_00_00, // Row 0: Only byte 0 is 1
            64'h00_38_00_00_00_00_00_00, // Row 1: Only byte 1 is 1
            64'h00_00_38_00_00_00_00_00, // Row 2: ...
            64'h00_00_00_38_00_00_00_00,
            64'h00_00_00_00_38_00_00_00,
            64'h00_00_00_00_00_38_00_00,
            64'h00_00_00_00_00_00_38_00,
            64'h00_00_00_00_00_00_00_38  // Row 7: Only byte 7 is 1
        });

        #(CLK_PERIOD * 2)

        /*
            0.25 = 0_0101_000 = 8'h28
            0.5 = 0_0110_000 = 8'h30
            0.75 = 0_0110_100 = 8'h34
            1 = 0_0111_000 = 8'h38
            1.25 = 0_0111_010 = 8'h3a
            1.5 = 0_0111_100 = 8'h3c
            1.75 = 0_0111_110 = 8'h3e
            
        */
        write_inputs('{
            64'h28_30_34_38_38_3a_3c_3e, // Row 7
            64'h30_34_38_3a_3a_3c_3e_28, // Row 6
            64'h34_38_3a_3c_3c_3e_28_30, // Row 5
            64'h38_3a_3c_3e_3e_28_30_34, // Row 4
            64'h3a_3c_3e_28_28_30_34_38, // Row 3
            64'h3c_3e_28_30_30_34_38_3a, // Row 2
            64'h3e_28_30_30_34_38_3a_3c, // Row 1
            64'h3e_3c_3a_38_38_34_30_28  // Row 0
        });

        $finish;
    end
endmodule

/* verilator coverage_on */

