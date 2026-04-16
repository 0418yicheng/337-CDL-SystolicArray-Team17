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
                        activation_outputs[i*8 +: 8] = biased_outputs[i*8 +: 8] < 0 ? 8'd0 : biased_outputs[i*8 +: 8];
                    end
                end
                else if(activation_mode == 4'd1) begin  //Binary
                    for(int i = 0; i < 8; i++) begin
                        activation_outputs[i*8 +: 8] = biased_outputs[i*8 +: 8] < 0 ? 8'd0 : 8'd1;
                    end
                end
                else if(activation_mode == 4'd2) begin  //Identity
                    activation_outputs = biased_outputs;
                end
                else if(activation_mode == 4'd3) begin  //L:eaky Relu
                    //How to multioply by 1/4?
                end
                else begin
                end

                if(count >= 7) begin
                    n_state = IDLE;
                    n_count = 0;
                end
                else
                    n_count = count + 1;

                activation_done = 1;
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

