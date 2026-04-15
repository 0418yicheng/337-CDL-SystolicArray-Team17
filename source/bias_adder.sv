`timescale 1ns / 10ps

module bias_adder #(
    // parameters
) (
    input logic clk, n_rst,
    input logic [63:0] outputs,
    input logic [63:0] bias,
    input logic done,
    output logic [63:0] biased_outputs,
    output logic bias_done
);

    typedef enum logic[3:0] {IDLE, LOAD1, LOAD2, LOAD3, LOAD4, LOAD5, LOAD6, LOAD7, LOAD8} state_t;
    state_t state;
    state_t n_state;

    always_comb begin
        n_state = state;
        case(state)
            IDLE: begin
                bias_done = 0;
                if(done)
                    n_state = LOAD1;
                
                biased_outputs = 64'd0;
            end
            LOAD1: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = LOAD2;
            end
            LOAD2: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = LOAD3;
            end
            LOAD3: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = LOAD4;
            end
            LOAD4: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = LOAD5;
            end
            LOAD5: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = LOAD6;
            end
            LOAD6: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = LOAD7;
            end
            LOAD7: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = LOAD8;
            end
            LOAD8: begin
                bias_done = 1;
                biased_outputs = outputs + bias;
                n_state = IDLE;
            end
            default: begin
                bias_done = 1;
                n_state = IDLE;
                biased_outputs = 64'd0;
            end
        endcase
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
        end
        else
            state <= n_state;
    end

endmodule

