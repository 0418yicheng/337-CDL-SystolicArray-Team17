`timescale 1ns / 10ps

module systolic_array #(
    // parameters
) (
    input logic clk, n_rst,
    input logic load_inputs, load_weights,
    input logic [63:0] inputs,
    output logic nan, inf,
    output logic [63:0] outputs,
    output logic done
);
    logic [7:0] load_weight_vector;
    logic [7:0][7:0] weights [7:0];
    logic [7:0][7:0] int_inputs [7:0];
    logic [7:0][7:0] int_sums [7:0];

    logic [7:0][7:0] nans;
    logic [7:0][7:0] infs;

    logic [7:0] input_vector [7:0];   //Single vector of inputs fed into sys_array

    logic [7:0][7:0] input_mat [7:0], n_input_mat [7:0];
    logic [7:0][7:0] output_mat [7:0], n_output_mat [7:0];

    logic man_load; //Signal to manually load input

    typedef enum logic[4:0] {IDLE, IDLE_ERR,
                                WLOAD1, WLOAD2, WLOAD3, WLOAD4, WLOAD5, WLOAD6, WLOAD7, WLOAD8,
                                WWAIT1, WWAIT2, WWAIT3, WWAIT4, WWAIT5, WWAIT6, WWAIT7,
                                ILOAD, WAIT, CALC, OLOAD} state_t;

    state_t state;
    state_t n_state;

    logic [3:0] in_count;
    logic [3:0] n_in_count;
    logic [3:0] out_count;
    logic [3:0] n_out_count;

    assign nan = |nans;
    assign inf = |infs;

    generate    //Generate all pes
        //Initialize input and output vectors
        for(genvar i = 0; i < 8; i++) begin: IO_INIT
            assign input_vector[i] = input_mat[i][i];   //That's not right
            assign outputs[i*8 +: 8] = output_mat[3'd7-i][i];
        end
        //Generate general internal PEs
        for(genvar r = 1; r < 7; r++) begin: INT_PE_R
            for(genvar c = 1; c < 8; c++) begin: INT_PE_C
                pe p (.clk(clk), .n_rst(n_rst), 
                        .load_weight(load_weight_vector[r]), .load_input(load_inputs || man_load), 
                        .in_weight(weights[r][c]), .in(int_inputs[r][c-1]), .input_sum(int_sums[r-1][c]), 
                        .input_out(int_inputs[r][c]), .sum(int_sums[r][c]), 
                        .inf(infs[r][c]), .nan(nans[r][c])
                        );
            end 
        end

        // Generate first and last row of PEs (input_sum and sum will go to different places)
        for(genvar c = 1; c < 8; c++) begin: TB_PE
            //Row 0
            pe p0 (.clk(clk), .n_rst(n_rst), 
                        .load_weight(load_weight_vector[0]), .load_input(load_inputs || man_load), 
                        .in_weight(weights[0][c]), .in(int_inputs[0][c-1]), .input_sum(8'd0), 
                        .input_out(int_inputs[0][c]), .sum(int_sums[0][c]), 
                        .inf(infs[0][c]), .nan(nans[0][c])
                        );

            //Row 7
            pe p7 (.clk(clk), .n_rst(n_rst), 
                        .load_weight(load_weight_vector[7]), .load_input(load_inputs || man_load), 
                        .in_weight(weights[7][c]), .in(int_inputs[7][c-1]), .input_sum(int_sums[6][c]), 
                        .input_out(int_inputs[7][c]), .sum(int_sums[7][c]), 
                        .inf(infs[7][c]), .nan(nans[7][c])
                        );
        end

        //Generate first column that takes in different inputs
        for(genvar r = 1; r < 7; r++) begin: IN_PE
            pe p (.clk(clk), .n_rst(n_rst), 
                        .load_weight(load_weight_vector[r]), .load_input(load_inputs || man_load), 
                        .in_weight(weights[r][0]), .in(input_vector[r]), .input_sum(int_sums[r-1][0]), 
                        .input_out(int_inputs[r][0]), .sum(int_sums[r][0]), 
                        .inf(infs[r][0]), .nan(nans[r][0])
                        );
        end

        //Top left corner
        pe p_tl (.clk(clk), .n_rst(n_rst), 
                        .load_weight(load_weight_vector[0]), .load_input(load_inputs || man_load), 
                        .in_weight(weights[0][0]), .in(input_vector[0]), .input_sum(8'b0), 
                        .input_out(int_inputs[0][0]), .sum(int_sums[0][0]), 
                        .inf(infs[0][0]), .nan(nans[0][0])
                        );

        // Bottom left corner
        pe p_bl (.clk(clk), .n_rst(n_rst), 
                        .load_weight(load_weight_vector[7]), .load_input(load_inputs || man_load), 
                        .in_weight(weights[7][0]), .in(input_vector[7]), .input_sum(int_sums[6][0]), 
                        .input_out(int_inputs[7][0]), .sum(int_sums[7][0]), 
                        .inf(infs[7][0]), .nan(nans[7][0])
                        );
    endgenerate

    always_comb begin
        n_state = state;
        n_input_mat = input_mat;
        n_output_mat = output_mat;
        n_in_count = in_count;
        n_out_count = out_count;
        man_load = 0;
        done = 0;

        load_weight_vector = 8'd0;
        for(int r = 0; r < 8; r++) begin
            for(int c = 0; c < 8; c++) begin
                weights[r][c] = 8'd0;
            end
        end
        
        case(state)
            IDLE: begin
                if(load_weights)
                    n_state = WLOAD1;

                if(load_inputs)
                    n_state = ILOAD;
            end

            IDLE_ERR: begin
            end

            WLOAD1: begin
                n_state = WLOAD2;

                load_weight_vector[0] = 1;
                weights[0] = inputs;
            end
            WWAIT1: begin
                if(load_weights)
                    n_state = WLOAD2;
            end
                
            WLOAD2: begin
                n_state = WWAIT2;

                load_weight_vector[1] = 1;
                weights[1] = inputs;
            end

            WWAIT2: begin
                if(load_weights)
                    n_state = WLOAD3;
            end

            WLOAD3: begin
                n_state = WLOAD4;

                load_weight_vector[2] = 1;
                weights[2] = inputs;
            end
            WWAIT3: begin
                if(load_weights)
                    n_state = WLOAD4;
            end
            
            WLOAD4: begin
                n_state = WWAIT4;

                load_weight_vector[3] = 1;
                weights[3] = inputs;
            end

            WWAIT4: begin
                if(load_weights)
                    n_state = WLOAD5;
            end

            WLOAD5: begin
                n_state = WLOAD6;

                load_weight_vector[4] = 1;
                weights[4] = inputs;
            end
            WWAIT5: begin
                if(load_weights)
                    n_state = WLOAD6;
            end
            WLOAD6: begin
                n_state = WWAIT6;

                load_weight_vector[5] = 1;
                weights[5] = inputs;
            end
            WWAIT6: begin
                if(load_weights)
                    n_state = WLOAD7;
            end
            WLOAD7: begin
                n_state = WLOAD8;

                load_weight_vector[6] = 1;
                weights[6] = inputs;
            end
            WWAIT7: begin
                if(load_weights)
                    n_state = WLOAD8;
            end
            WLOAD8: begin
                n_state = IDLE;

                load_weight_vector[7] = 1;
                weights[7] = inputs;
            end

            ILOAD: begin
                n_state = WAIT;
                if(in_count == 4'd8) begin
                    n_in_count = 4'd1;
                    n_state = CALC;
                end

                for(int r = 1; r < 8; r++) begin
                    for(int c = 0; c < 8; c++) begin
                        n_input_mat[r][c] = input_mat[r-1][c];
                    end
                end
                n_input_mat[0] = inputs;
            end

            WAIT: begin
                if(load_inputs) begin
                    n_state = ILOAD;
                    n_in_count = in_count + 1;
                end
            end

            CALC: begin
                // Continue shifting the input matrix down to put the inputs in the right place
                man_load = 1;    //Probably wrong, might need to make an or signal. Need to send to PEs
                for(int c = 0; c < 8; c++) begin
                    n_input_mat[0][c] = 8'd0;
                    for(int r = 1; r < 8; r++) begin
                        n_input_mat[r][c] = input_mat[r-1][c];
                    end
                end

                //Shift output matrix down
                for(int c = 0; c < 8; c++) begin
                    n_output_mat[0][c] = int_sums[7][c];
                    for(int r = 1; r < 8; r++) begin
                        n_output_mat[r][c] = output_mat[r-1][c];
                    end
                end

                n_out_count = out_count + 1;
                if(out_count == 4'd8) begin
                    n_out_count = 4'd1;
                    n_state = OLOAD;
                end
            end
            OLOAD: begin
                man_load = 1;
                done = 1;
                for(int c = 0; c < 8; c++) begin
                    n_output_mat[0][c] = int_sums[7][c];
                    for(int r = 1; r < 8; r++) begin
                        n_output_mat[r][c] = output_mat[r-1][c];
                    end
                end

                n_out_count = out_count + 1;
                if(out_count == 4'd8) begin
                    n_state = IDLE;
                    n_out_count = 4'd1;
                end
            end

            default: begin
            end
        endcase
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
            for(int r = 0; r < 8; r++) begin
                for(int c = 0; c < 8; c++) begin
                    input_mat[r][c] <= 8'd0;
                    output_mat[r][c] <= 8'd0;
                end
            end

            in_count <= 4'd1;
            out_count <= 4'd1;
        end
        else begin
            state <= n_state;
            input_mat <= n_input_mat;
            output_mat <= n_output_mat;

            in_count <= n_in_count;
            out_count <= n_out_count;
        end
    end
endmodule

