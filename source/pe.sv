`timescale 1ns / 10ps

module pe #(
    // parameters
) (
    input logic clk, n_rst,
    input logic load_weight, load_input,
    input logic [7:0] in_weight,
    input logic [7:0] in,
    input logic [7:0] input_sum,
    output logic [7:0] input_out,
    output logic [7:0] sum,
    output logic inf, nan
);
    logic [7:0] n_weight;
    logic [7:0] weight;

    logic [7:0] n_out;
    logic [7:0] out_reg;
    assign input_out = out_reg;

    logic [7:0] n_sum;
    logic [7:0] sum_reg;
    assign sum = sum_reg;

    /*
                    input_sum
                    |
                    v
                   ----
            input->|  |->input_out
                   ----
                     |
                     v
                    sum
    
        Float Representation:
        f = (-1)^s * 1.m * 2^(e - bias)
        bias = 7
        [s][_e__][_m_] -> 1's, 4'e, 3'm
    */
    logic s_prod;
    logic [3:0] e_prod;
    logic [7:0] m_prod; // 4' * 4' = 8' (For multiplication stage)
    
    logic [3:0] e_large, e_small, e_diff;   //Internal variables to handle addition math
    logic [8:0] m_large, m_small, m_sum; // 9 bits to handle carry-out
    logic s_final;
    logic [3:0] e_final;
    always_comb begin : blockName
        nan = 0;
        inf = 0;

        n_sum = sum_reg;
        n_out = out_reg;
        if(load_weight) begin
            n_weight = in_weight;
        end
        else if(load_input) begin
            n_out = in;
            //sum = input * weight + input_sum
            
            //Multiplication
            s_prod = weight[7] ^ in[7];
            e_prod = (weight[6:3] + in[6:3] >= 4'd7) ? (weight[6:3] + in[6:3] - 4'd7) : 4'd0; //IEEE standard if unbiased exponent is negative
            m_prod = {1'b1, weight[2:0]} * {1'b1, in[2:0]};
            
            //Normalize product
            if(m_prod[7]) begin
                m_prod = {1'b0, m[7:1]};
                e_prod = e_prod + 4'd1;
            end
            

            //Addition
            if (e_prod >= input_sum[6:3]) begin
                e_large = e_prod;
                e_small = input_sum[6:3];
                e_diff  = e_large - e_small;
                
                m_large = {1'b1, m_prod[5:3], 4'b0}; // Expand to 9-bit for precision
                m_small = ({1'b1, input_sum[2:0], 4'b0}) >> e_diff;
                s_final = s_prod;

            end
            else begin
                e_large = input_sum[6:3];
                e_small = e_prod;
                e_diff  = e_large - e_small;
                
                m_large = {1'b1, input_sum[2:0], 4'b0};
                m_small = ({1'b1, m_prod[5:3], 4'b0}) >> e_diff;
                s_final = input_sum[7];
            end
            
            if(s_prod == input_sum[7]) begin
                m_sum = m_large + m_small;
            end
            else if (m_large >= m_small) begin
                m_sum = m_large - m_small;
            end else begin
                m_sum = m_small - m_large;
                s_final = ~s_final;
            end

            e_final = e_large;
            if (m_sum[8]) begin // If overflow, then shift and increase exponent
                m_sum = m_sum >> 1;
                e_final = e_final + 1;
            end 
            else if (m_sum != 0 && !m_sum[7]) begin // Cancellation (e.g., 1.0 - 0.9 = 0.1)
                m_sum = m_sum << 1;
                e_final = e_final - 1;
            end

            // Check for zero result, inf, and nan
            inf =  m_sum[6:4] == 0 && e_final == 0;
            nan = e_final == 4'b1111 && m_sum[6:4] != 0;

            if (m_sum[7:5] == 3'b0 && e_final == 0)
                n_sum = 8'b0;
            else
                n_sum = {s_final, e_final, m_sum[6:4]};

        end
    end

    always_ff @( posedge clk, negedge n_rst ) begin : blockName
        if(!n_rst) begin
            weight <= 8'd0;
            out_reg <= 8'd0;
            sum_reg <= 8'd0;
        end

        else begin
            weight <= n_weight;
            out_reg <= n_out;
            sum_reg <= n_sum;
        end
    end



endmodule

