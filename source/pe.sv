`timescale 1ns / 10ps

module pe #(
    // parameters
) (
    input logic clk, n_rst,
    input logic load_weight, load_input,
    input logic [7:0] in_weight,    //Don't need separate input logics for weight and inputs
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
    logic [4:0] e_temp;
    logic [3:0] e_prod;
    logic [7:0] m_prod; // 4' * 4' = 8' (For multiplication stage)
    
    logic [3:0] e_large, e_small, e_diff;   //Internal variables to handle addition math
    logic [8:0] m_large, m_small, m_sum; // 9 bits to handle carry-out
    logic s_final;
    logic [3:0] e_final;
    always_comb begin : MathComb
        nan = 0;
        inf = 0;
        n_sum = sum_reg;
        n_out = out_reg;
        n_weight = weight;

        //Set a bunch of default values to prevent latches
        s_prod = 0;
        e_temp = 5'd0;
        e_prod = 0;
        m_prod = 0;
        e_large = 0;
        e_small = 0;
        e_diff = 0;
        m_large = 0;
        m_small = 0;
        m_sum = 0;
        s_final = 0;
        e_final = 0;

        if (load_weight) begin
            n_weight = in_weight;
        end
        else if (load_input) begin
            n_out = in;
            
            //Multiplication
            s_prod = weight[7] ^ in[7];
            
            // Exponent calculation with bias of 7
            // We check for underflow to prevent negative results in 4-bit logic
            e_temp = weight[6:3] + in[6:3];
            if(e_temp < 5'd7)
                e_prod = 4'd0;
            else if (e_temp - 5'd7 >= 15) 
                e_prod = 4'b1111;
            else 
                e_prod = e_temp[3:0] - 4'd7;

            // Mantissa multiply: (1.m * 1.m) -> Result is 8 bits [7:0]
            if(weight[6:0] == 0 || in[6:0] == 0)
                m_prod = 0;
            else
                m_prod = {1'b1, weight[2:0]} * {1'b1, in[2:0]}; 
            
            // Normalize Product: Ensure bit [6] is the "1" in 1.xxxxxx
            // If bit [7] is high, the result is 1x.xxxxxx, so we shift right.
            if (m_prod[7]) begin 
                m_prod = m_prod >> 1;
                e_prod = e_prod + 4'd1;
            end
            // m_prod[6] is now the hidden bit, m_prod[5:0] are fractional.

            // Addition
            // Internal registers m_large/m_small are 9 bits [8:0].
            if(input_sum[7:0] == 0) begin    //Edge case for input_sum = 0
                s_final = s_prod;
                m_large = {1'b0, m_prod[6:0], 1'b0};
                m_small = 9'd0;
                e_large = e_prod;
            end
            else if (e_prod >= input_sum[6:3]) begin
                e_large = e_prod;
                e_small = input_sum[6:3];
                e_diff  = e_large - e_small;
                
                // Align Product: m_prod[6] is hidden bit -> move to [7].
                // m_prod[5:0] are the 6 fractional bits. 
                // We add a 0 at the end to fill the 9-bit width.
                m_large = {1'b0, m_prod[6:0], 1'b0}; 
                
                // Align input_sum: Add implicit 1, then 3 bits of m, then pad.
                m_small = {1'b0, 1'b1, input_sum[2:0], 4'b0} >> e_diff;
                s_final = s_prod;
            end
            else begin
                e_large = input_sum[6:3];
                e_small = e_prod;
                e_diff  = e_large - e_small;
                
                // input_sum is larger, hidden bit at [7]
                m_large = {1'b0, 1'b1, input_sum[2:0], 4'b0};
                
                // Shift product to match input_sum's scale
                m_small = {1'b0, m_prod[6:0], 1'b0} >> e_diff;
                s_final = input_sum[7];
            end

            // Final calculations
            if (s_prod == input_sum[7]) begin
                m_sum = m_large + m_small;
            end 
            else if (m_large >= m_small) begin
                m_sum = m_large - m_small;
            end 
            else begin
                m_sum = m_small - m_large;
                s_final = ~s_final;
            end

            // Normalie again and check edge cases
            e_final = e_large;
            if (m_sum[8]) begin // Overflow (Carry-out)
                m_sum = m_sum >> 1;
                e_final = e_final + 1;
            end 
            else if (m_sum != 0 && !m_sum[7]) begin // Cancellation
                m_sum = m_sum << 1;
                e_final = e_final - 1;
            end

            // inf and nan
            if (e_final >= 4'b1111) begin
                inf = 1;
                n_sum = {s_final, 4'b1111, 3'b000};
            end
            // Check if result is Zero
            else if (m_sum[7] == 0 && e_final == 0) begin
                n_sum = 8'b0;
            end
            else begin
                // Hidden bit is at [7], so fractional bits are [6:4]
                n_sum = {s_final, e_final, m_sum[6:4]};
            end
            
            // NaN: Exponent 15, Mantissa non-zero
            nan = (e_final == 4'b1111 && m_sum[6:4] != 0);
        end
    end

    always_ff @( posedge clk, negedge n_rst ) begin : FF
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

