`timescale 1ns / 10ps

module activation #(
    // parameters
) (
    input logic clk, n_rst,
    input logic [1:0] activation_mode,
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
    logic [63:0] n_output;
    logic n_done;

    always_comb begin
        n_count = count;
        n_state = state;
        n_output = 0;
        n_done = 0;
        case(state)
            IDLE: begin
                if(bias_done) begin
                    n_state = CALC;
                    if(activation_mode == 0) begin  //RELU
                        for(int i = 0; i < 8; i++) begin
                            logic[7:0] curr_out;
                            curr_out = biased_outputs[i*8 +: 8];
                            n_output[i*8 +: 8] = curr_out[7] ? 8'd0 : curr_out;
                        end
                    end
                    else if(activation_mode == 2'd1) begin  //Binary
                        for(int i = 0; i < 8; i++) begin
                            logic [7:0] curr_out;
                            curr_out = biased_outputs[i*8 +: 8];
                            n_output[i*8 +: 8] = curr_out[7] ? 8'd0 : 8'd1;
                        end
                    end
                    else if(activation_mode == 2'd2) begin  //Identity
                        n_output = biased_outputs;
                    end
                    else if(activation_mode == 2'd3) begin  //Leaky Relu
                        //0.25 = 0_0101_000 = 2^(-2)
                        for(int i = 0; i < 8; i++) begin
                            logic[7:0] curr_val;
                            curr_val = biased_outputs[i*8 +:8];

                            if(curr_val[7]) begin
                                if(curr_val[6:3] >= 4'd2)
                                    n_output[i*8 +: 8] = {1'b1, curr_val[6:3]-4'd2, curr_val[2:0]};
                                else
                                    n_output[i*8 +: 8] = 8'd0; //If the resulting exponent would be less than 0

                            end
                            else
                                n_output[i*8+:8] = biased_outputs[i*8+:8];
                        end


                    end
                    n_done = 1;
                end
                else begin
                    n_output = 64'd0;
                    n_done = 0;
                end
            end
            CALC: begin
                if(activation_mode == 0) begin  //RELU
                    for(int i = 0; i < 8; i++) begin
                        logic[7:0] curr_out;
                        curr_out = biased_outputs[i*8 +: 8];
                        n_output[i*8 +: 8] = curr_out[7] ? 8'd0 : curr_out;
                    end
                end
                else if(activation_mode == 2'd1) begin  //Binary
                    for(int i = 0; i < 8; i++) begin
                        logic [7:0] curr_out;
                        curr_out = biased_outputs[i*8 +: 8];
                        n_output[i*8 +: 8] = curr_out[7] ? 8'd0 : 8'd1;
                    end
                end
                else if(activation_mode == 2'd2) begin  //Identity
                    n_output = biased_outputs;
                end
                else if(activation_mode == 2'd3) begin  //Leaky Relu
                    //0.25 = 0_0101_000 = 2^(-2)
                    for(int i = 0; i < 8; i++) begin
                        logic[7:0] curr_val;
                        curr_val = biased_outputs[i*8 +:8];

                        if(curr_val[7]) begin
                            if(curr_val[6:3] >= 4'd2)
                                n_output[i*8 +: 8] = {1'b1, curr_val[6:3]-4'd2, curr_val[2:0]};
                            else
                                n_output[i*8 +: 8] = 8'd0; //If the resulting exponent would be less than 0

                        end
                        else
                            n_output[i*8+:8] = biased_outputs[i*8+:8];
                    end


                end

                if(count >= 6) begin
                    n_state = IDLE;
                    n_count = 0;
                end
                else
                    n_count = count + 1;

                n_done = 1;
            end
            default: begin
                n_done = 0;
                n_output = 0;
            end
        endcase
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
            count <= 0;
            activation_outputs <= 0;
            activation_done <= 0;
        end
        else begin
            state <= n_state;
            count <= n_count;
            activation_outputs <= n_output;
            activation_done <= n_done;
        end
    end

endmodule

