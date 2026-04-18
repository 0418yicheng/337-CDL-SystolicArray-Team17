`timescale 1ns / 10ps

module tester #(
    // parameters
) (
    input logic clk, n_rst, read, start_inference, write, load_weights, done,
    input logic [9:0] addr_in,
    input logic [63:0] controller_write, activations,
    output logic buffer_occupancy, load_input, load_weight, ready, weights_loaded, overrun, inference_done,
    output logic [63:0] controller_read, array_in
);
    logic input_write, weight_write, output_read;
    logic new_input;
    logic [3:0] output_row, weight_row, input_row;
    logic [63:0] input_wdata, weight_wdata, input_rdata, weight_rdata, output_rdata;
    controller test (.*);
    data_buffer tester (.clk(clk), .n_rst(n_rst), .input_write(input_write), .input_read(input_read), 
    .weight_write(weight_write), .weight_read(weight_read), .output_read(output_read), .done(done), 
    .weight_row(weight_row), .output_row(output_row), .input_row(input_row), .input_wdata(input_wdata), .weight_wdata(weight_wdata), 
    .activations(activations), .input_rdata(input_rdata), .output_rdata(output_rdata), .weight_rdata(weight_rdata), .new_input(new_input), .inference_done(inference_done));


endmodule

