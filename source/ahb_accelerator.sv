`timescale 1ns / 10ps

module ahb_accelerator #(
    // parameters
) (
    input logic clk, n_rst,

    input logic hsel,
    input logic [9:0] haddr,
    input logic [1:0] htrans,
    input logic [1:0] hsize,
    input logic hwrite,
    input logic [63:0] hwdata,
    output logic [63:0] hrdata,
    output logic hready,
    output logic hresp
);

    // Controller signals
    logic ready, inference_done, weights_loaded, start_inference, load_weights, input_write, weight_write, weight_read, output_read, load_input, load_weight;
    logic [63:0] crdata, cwdata, input_wdata, weight_wdata;
    logic [9:0] caddr;
    logic cwrite;
    logic cread;
    logic [63:0] input_rdata, weight_rdata, output_rdata;
    logic [2:0] input_row, weight_row, output_row;
    logic new_input;
    logic [63:0] array_in, array_out, biased_out, activations;
    logic input_read;
    logic busy;
    logic done, bias_done;
    logic [3:0] input_count;
        

    // Error signals
    logic boe, oe, nan_flag, inf_flag;

    // Bias and activation signals
    logic [63:0] bias;
    logic [1:0] activation_mode;




    ahb_subordinate ahb_sub(
        .clk(clk),
        .n_rst(n_rst),
        
        // AHB Interface
        .hsel(hsel),
        .haddr(haddr),
        .htrans(htrans),
        .hsize(hsize),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hready(hready),
        .hresp(hresp),

        // Controller
        .ready(ready),
        .inference_done(inference_done),
        .weights_loaded(weights_loaded),
        .crdata(crdata),
        .cwdata(cwdata),
        .caddr(caddr),
        .cwrite(cwrite),
        .cread(cread),
        .start_inference(start_inference),
        .load_weights(load_weights),

        // Errors
        .boe(boe),
        .oe(oe),
        .nan_flag(nan_flag),
        .inf_flag(inf_flag),

        //Bias Adder
        .bias(bias),

        //Systolic Array
        .busy(busy),

        //Actvation Module
        .activation_mode(activation_mode)
    );

    controller cont (
        .clk(clk),
        .n_rst(n_rst),
        .read(cread),
        .write(cwrite),
        .start_inference(start_inference),
        .load_weights(load_weights),
        .addr_in(caddr),
        .controller_write(cwdata),
        .input_rdata(input_rdata),
        .weight_rdata(weight_rdata),
        .output_rdata(output_rdata),
        .input_write(input_write),
        .weight_write(weight_write),
        .buffer_occupancy(boe),
        .load_input(load_input),
        .load_weight(load_weight),
        .ready(ready),
        .weights_loaded(weights_loaded),
        .input_read(input_read),
        .weight_read(weight_read),
        .output_read(output_read),
        .overrun(oe),
        .new_input(new_input),
        .inference_done(inference_done),
        .output_row(output_row),
        .weight_row(weight_row),
        .input_row(input_row),
        .controller_read(crdata),
        .input_wdata(input_wdata),
        .array_in(array_in),
        .weight_wdata(weight_wdata)
    );

    systolic_array sa (
        .clk(clk),
        .n_rst(n_rst),
        .load_inputs(load_input),
        .load_weights(load_weight),
        .inputs(array_in),
        .nan(nan_flag),
        .inf(inf_flag),
        .outputs(array_out),
        .busy(busy),
        .done(done)
    );

    bias_adder ba (
        .clk(clk),
        .n_rst(n_rst),
        .outputs(array_out),
        .bias(bias),
        .done(done),
        .biased_outputs(biased_out),
        .bias_done(bias_done)
    );

    data_buffer db (
        .clk(clk),
        .n_rst(n_rst),
        .input_write(input_write),
        .weight_write(weight_write),
        .weight_read(weight_read),
        .output_read(output_read),
        .done(done),
        .new_input(new_input),
        .weight_row(weight_row),
        .input_row(input_row),
        .output_row(output_row),
        .input_count(input_count),
        .input_wdata(input_wdata),
        .weight_wdata(weight_wdata),
        .activations(activations),
        .input_rdata(input_rdata),
        .weight_rdata(weight_rdata),
        .output_rdata(output_rdata),
        .input_read(input_read)
    );

    activation act (
        .clk(clk),
        .n_rst(n_rst),
        .activation_mode(activation_mode),
        .biased_outputs(biased_out),
        .bias_done(bias_done),
        .activation_outputs(activations)
    );



endmodule

