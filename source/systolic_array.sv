`timescale 1ns / 10ps

module systolic_array #(
    // parameters
) (
    input logic clk, n_rst,
    input logic load_inputs, load_weights,
    input logic [63:0] inputs,
    output logic nan, inf,
    output logic [63:0] outputs,
    output logic busy, done
);
    logic [7:0][7:0] n_weights [7:0];
    logic [7:0][7:0] weights_mat [7:0];
    logic [7:0][7:0] n_a [7:0];    //Matrix being multplied to the weights
    logic [7:0][7:0] a_mat [7:0];
    logic [7:0][7:0] in [7:0];
    logic [7:0][7:0] n_in [7:0];
    logic [7:0][7:0] out [7:0];
    logic [7:0][7:0] n_out [7:0];
    logic [7:0][7:0] sys_array [7:0];
    logic [7:0][7:0] n_sys_array [7:0];

    logic [3:0] in_count;
    logic [3:0] n_in_count;
    logic [3:0] out_count;
    logic [3:0] n_out_count;

    // logic sys_calc_flag;


    typedef enum logic[3:0] {IDLE, IDLE_ERR,
                                WLOAD1, WLOAD2, WLOAD3, WLOAD4, WLOAD5, WLOAD6, WLOAD7, WLOAD8,
                                ILOAD, WAIT, CALC, OLOAD} state_t;

    state_t state;
    state_t n_state;

    always_comb begin : FSM
        nan = 0;
        inf = 0;
        busy = 0;
        done = 0;
        n_a = a_mat;
        n_weights = weights_mat;
        n_state = state;
        outputs = 64'd0;
        n_in = in;
        n_out = out;
        n_in_count = in_count;
        n_out_count = out_count;
        // sys_calc_flag = 0;

        if(state != WAIT) begin
            //Shift each input
            for(int i = 0; i < 8; i++) begin
                n_a[i][0] = 0;
                for(int j = 1; j < 8; j++) begin
                    n_a[i][j] = a_mat[i][j-1];
                end
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
                if(load_weights)
                    n_state = WLOAD1;

                if(load_inputs)
                    n_state = ILOAD;
            end
            WLOAD1: begin
                if(load_weights)
                    n_state = WLOAD2;

                n_weights[0] = inputs;
            end
            WLOAD2: begin
                if(load_weights)
                    n_state = WLOAD3;

                n_weights[1] = inputs;
            end
            WLOAD3: begin
                if(load_weights)
                    n_state = WLOAD4;
                
                n_weights[2] = inputs;
            end
            WLOAD4: begin
                if(load_weights)
                    n_state = WLOAD5;

                n_weights[3] = inputs;
            end
            WLOAD5: begin
                if(load_weights)
                    n_state = WLOAD6;
                
                n_weights[4] = inputs;
            end
            WLOAD6: begin
                if(load_weights)
                    n_state = WLOAD7;
                
                n_weights[5] = inputs;
            end
            WLOAD7: begin
                if(load_weights)
                    n_state = WLOAD8;

                n_weights[6] = inputs;
            end
            WLOAD8: begin
                if(load_weights)
                    n_state = IDLE;

                n_weights[7] = inputs;
            end

            ILOAD: begin
                busy= 1;
                // sys_calc_flag = 1;
                n_in[3'(in_count-4'd1)] = inputs;
                for(int i = 0; i < 8; i++) begin
                    if(i < in_count)
                        n_a[i][0] = in[3'(in_count - 4'(i) - 4'd1)][i];
                end

                n_in_count = in_count + 4'd1;
                if(n_in_count > 8) begin
                    n_in_count = 1;
                    n_state = CALC;
                end
                else
                    n_state = WAIT;
            end

            WAIT: begin
                if(load_inputs)
                    n_state = ILOAD;
            end

            CALC: begin
                // sys_calc_flag = 1;
                busy = 1;
                for(int i = 0; i < 8; i++) begin
                    if(i < out_count) begin
                        n_out[i][3'(out_count - 4'(i) - 4'd1)] = sys_array[7][i];
                    end
                end
                n_out_count = out_count + 4'd1;
                if(n_out_count == 4'd8)
                    n_state = OLOAD;
            end

            OLOAD: begin
                // sys_calc_flag = 1;
                busy = 1;
                for(int i = 7; i >= 0; i--) begin
                    if(i >= 3'(4'd8 - out_count))
                        n_out[i][3'(4'd8 - out_count + 4'd8 - 4'(i) - 4'd1)] = sys_array[7][i];
                end
                done = 1;
                outputs = out[3'(4'd8-out_count)];
                n_out_count = out_count - 1;

                if(n_out_count == 0) begin
                    n_out_count = 1;
                    n_state = IDLE;
                end
            end

            default: begin
            end

        endcase
    end

    always_comb begin : SysArrMath
        n_sys_array = sys_array;
        if(state != WAIT) begin
            //Do math for top PEs
            for(int i = 0; i < 8; i++) begin
                n_sys_array[0][i] = weights_mat[0][i]*a_mat[i][0];
            end
            //Do the math for other PEs
            for(int i = 1; i < 8; i++) begin
                for(int j = 0; j < 8; j++) begin
                    //Multiply left by weight and add to top
                    n_sys_array[i][j] = weights_mat[i][j]*a_mat[i][j] + sys_array[i-1][j];
                end
            end
        end
    end

    always_ff @(posedge clk, negedge n_rst) begin : FF
        if(!n_rst) begin
            for(int i = 0; i < 8; i++) begin
                for(int j = 0; j < 8; j++) begin
                    weights_mat[i][j] <= 8'd0;
                    a_mat[i][j] <= 8'd0;
                    sys_array[i][j] <= 8'd0;
                    in[i][j] <= 8'd0;
                    out[i][j] <= 8'd0;
                end
            end

            state <= IDLE;
            in_count <= 4'd1;
            out_count <= 4'd1;
        end
        else begin
            weights_mat <= n_weights;
            a_mat <= n_a;
            sys_array <= n_sys_array;
            state <= n_state;
            in <= n_in;
            out <= n_out;

            in_count <= n_in_count;
            out_count <= n_out_count;
        end
    end

endmodule

