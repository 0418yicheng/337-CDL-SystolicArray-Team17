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

    typedef enum logic {IDLE, LOAD} state_t;
    state_t state;
    state_t n_state;
    logic [2:0] count, n_count;
    logic [63:0] n_outputs;

    always_comb begin
        n_state = state;
        n_count = count;
        case(state)
            IDLE: begin
                bias_done = 0;
                if(done)
                    n_state = LOAD;
                
                n_outputs = 64'd0;
            end
            LOAD: begin
                bias_done = 1;
                for(int i = 0; i < 8; i++) begin
                    logic [7:0] a, b;
                    logic [3:0] ea, eb, re;
                    logic [4:0] ma, mb, rm;
                    logic sa, sb, rs;
                    
                    a = outputs[i*8 +: 8];
                    b = bias[i*8 +: 8];
                    sa = a[7]; sb = b[7];
                    ea = a[6:3]; eb = b[6:3];

                    // 1. Extract Mantissa with hidden bit
                    ma = (ea == 0) ? {2'b0, a[2:0]} : {2'b01, a[2:0]};
                    mb = (eb == 0) ? {2'b0, b[2:0]} : {2'b01, b[2:0]};

                    // 2. Align exponents and handle Sign-Magnitude
                    if (sa == sb) begin
                        // SAME SIGNS: Standard Addition
                        rs = sa;
                        if (ea >= eb) begin
                            re = ea;
                            rm = ma + (mb >> (ea - eb));
                        end else begin
                            re = eb;
                            rm = mb + (ma >> (eb - ea));
                        end
                        // Normalize for addition (shift right if carry)
                        if (rm[4]) begin
                            rm = rm >> 1;
                            re = re + 1;
                        end
                    end else begin
                        // DIFFERENT SIGNS: Subtraction
                        if ((ea > eb) || (ea == eb && ma >= mb)) begin
                            rs = sa;
                            re = ea;
                            rm = ma - (mb >> (ea - eb));
                        end else begin
                            rs = sb;
                            re = eb;
                            rm = mb - (ma >> (eb - ea));
                        end
                        // Normalize for subtraction (shift left if leading zeros)
                        if (rm[3] == 0 && re > 0) begin
                            rm = rm << 1;
                            re = re - 1;
                        end
                    end

                    n_outputs[i*8 +: 8] = {rs, re, rm[2:0]};
                end
            end
        endcase
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
            count <= 0;
            biased_outputs <= 0;
        end
        else begin
            state <= n_state;
            count <= n_count;
            biased_outputs <= n_outputs;
        end
    end

endmodule

