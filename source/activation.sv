`timescale 1ns / 10ps

module activation #(
    // parameters
) (
    input logic clk, n_rst,
    input logic [3:0] activation_mode,
    input logic [63:0] biased_outputs,
    input logic bias_done,
    output logic [63:0] activation_outputs,
    output logic activation_done
);

    typedef enum logic[3:0] {IDLE, CALC} state_t;
    state_t state;
    state_t n_state;
    logic [3:0] n_count;
    logic [3:0] count;

    always_comb begin
        n_count = count;
        n_state = state;
        case(state)
            IDLE: begin
                if(bias_done)
                    n_state = CALC;
                activation_outputs = 64'd0;
                activation_done = 0;
            end
            CALC: begin
                if(activation_mode == 0) begin  //RELU
                    for(int i = 0; i < 8; i++) begin
                        activation_outputs[i*8 +: 8] = biased_outputs[7] ? 8'd0 : biased_outputs[i*8 +: 8];
                    end
                end
                else if(activation_mode == 4'd1) begin  //Binary
                    for(int i = 0; i < 8; i++) begin
                        activation_outputs[i*8 +: 8] = biased_outputs[7] ? 8'd0 : 8'd1;
                    end
                end
                else if(activation_mode == 4'd2) begin  //Identity
                    activation_outputs = biased_outputs;
                end
                else if(activation_mode == 4'd3) begin  //Leaky Relu
                    //0.25 = 0_0101_000 = 2^(-2)
                    for(int i = 0; i < 8; i++) begin
                        logic [7:0] curr_val = biased_outputs[7:0];

                        if(curr_val[7]) begin
                            if(curr_val[2:0] >= 3'd2)
                                activation_outputs[i*8 +: 8] = {1'b0, curr_val[6:3], curr_val[2:0] - 3'd2};
                            else
                                activation_outputs[i*8 +: 8] = 8'd0; //If the resulting exponent would be less than 0

                        end
                        else
                            activation_outputs[i*8+:8] = biased_outputs[i*8+:8];
                    end


                end

                if(count >= 7) begin
                    n_state = IDLE;
                    n_count = 0;
                end
                else
                    n_count = count + 1;

                activation_done = 1;
            end
            default: begin
                activation_done = 0;
                activation_outputs = 0;
            end
        endcase
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
            count <= 0;
        end
        else begin
            state <= n_state;
            count <= n_count;
        end
    end

endmodule

