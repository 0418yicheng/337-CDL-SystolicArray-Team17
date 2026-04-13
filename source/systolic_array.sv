`timescale 1ns / 10ps

module systolic_array #(
    // parameters
) (
    input logic clk, n_rst,
    input logic load_inputs, load_weights,
    input logic [63:0] inputs
);
    input logic [7:0] weights_mat [7:0][7:0];
    input logic [7:0] n_input_mat [7:0][7:0];
    input logic [7:0] input_mat [7:0][7:0];
    input logic [7:0] systolic_array [7:0][7:0];
    input logic [7:0] n_systolic_array [7:0][7:0];


    typedef enum logic[4:0] {IDLE, IDLE_ERR,
                                WLOAD1, WLOAD2, WLOAD3, WLOAD4, WLOAD5, WLOAD6, WLOAD7, WLOAD8,
                                ILOAD1, ILOAD2, ILOAD3, ILOAD4, ILOAD5, ILOAD6, ILOAD7, ILOAD8,
                                OLOAD1, OLOAD2, OLOAD3, OLOAD4, OLOAD5, OLOAD6, OLOAD7, OLOAD8} state_t;

    state_t state;
    state_t n_state;

    always_comb begin : Combinational

    end

    always_comb begin : SysArrMath
        //Do the fast matrix multiply
        //Load inputs into edges

        //Do the math for each PE
        for(int i = 1; i < 8; i++) begin
            for(int j = 1; i < 8; i++) begin
                //Multiply left by weight and add to top
                n_systolic_array[i][j] = weights_mat[i][j]*input_mat[i][j] + systolic_array[i-1][j];
            end
        end

        //Shift the input matrix
    end

    always_ff @(posedge clk, negedge n_rst) begin : blockName
        if(!n_rst) begin
            
        end
        else begin
        end
    end

    


endmodule

