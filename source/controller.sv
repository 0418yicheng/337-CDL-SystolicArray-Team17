`timescale 1ns / 10ps

module controller #(
    // parameters
) (
    input logic clk, n_rst, read, start_inference, write, load_weights, inference_done,
    input logic [9:0] addr_in,
    input logic [63:0] controller_write, input_rdata, weight_rdata, output_rdata,
    output logic input_write, weight_write, buffer_occupancy, load_input, load_weight, ready, weights_loaded, input_read, weight_read, output_read, overrun, new_input,
    output logic [3:0] output_row, weight_row, input_row,
    output logic [63:0] controller_read, input_wdata, array_in, weight_wdata
);
    logic [4:0] count_inference, count_inference_next;
    logic input_write_next, weight_write_next, input_read_next, weight_read_next, output_read_next, buffer_occupancy_next, load_input_next, load_weight_next, read_next, weights_loaded_next, overrun_next, ready_next, new_input_next, sent_inputs, sent_inputs_next;
    logic [3:0] output_row_next, weight_row_next, input_row_next, missing_row, missing_row_next;
    logic [63:0] controller_read_next, input_wdata_next, array_in_next, weight_wdata_next;
    logic [3:0] input_count, output_count, output_count_next, input_count_next;
    logic [2:0] counter, counter_next;
    logic no_outputs, no_outputs_next, inference_started, inference_started_next;
typedef enum logic [5:0] {
    IDLE = 6'b000000,
    LOAD_WEIGHT0 = 6'b000001,
    LOAD_WEIGHT1 = 6'b000010,
    WAIT_LOAD0 = 6'b000011,
    LOAD_WEIGHT2 = 6'b000100,
    LOAD_WEIGHT3 = 6'b000101,
    WAIT_LOAD1 = 6'b000110,
    LOAD_WEIGHT4 = 6'b000111,
    LOAD_WEIGHT5 = 6'b001000,
    WAIT_LOAD2 = 6'b001001,
    LOAD_WEIGHT6 = 6'b001010,
    LOAD_WEIGHT7 = 6'b001011,
    WAIT_LOAD3 = 6'b001100,
    LOAD_WEIGHT8 = 6'b001101,
    LOAD_WEIGHT9 = 6'b001110,
    LOAD_INPUT0 = 6'b001111,
    LOAD_INPUT1 = 6'b010000,
    WAIT_INPUT0 = 6'b010001,
    LOAD_INPUT2 = 6'b010010,
    LOAD_INPUT3 = 6'b010011,
    WAIT_INPUT1 = 6'b010100,
    LOAD_INPUT4 = 6'b010101,
    LOAD_INPUT5 = 6'b010110,
    WAIT_INPUT2 = 6'b011000,
    LOAD_INPUT6 = 6'b011001,
    LOAD_INPUT7 = 6'b011010,
    WAIT_INPUT3 = 6'b011011,
    LOAD_INPUT8 = 6'b011100,
    LOAD_INPUT9 = 6'b011101,
    LOAD_LESSTHAN8 = 6'b011110,
    LOAD_ODD0 = 6'b100000,
    LOAD_ODD1 = 6'b100001,
    LOAD_EVEN = 6'b100010,
    WRITE = 6'b100011,
    WAIT_WRITE = 6'b100100,
    READ0 = 6'b100101,
    READ1 = 6'b100110,
    READ2 = 6'b100111,
    WAIT_LOADEVEN = 6'b101000,
    WAIT_LOADODD = 6'b101001,
    LOAD_WEIGHTM0 = 6'b101010,
    LOAD_WEIGHTM1 = 6'b101011,
    LOAD_WEIGHTM2 = 6'b101100,
    LOAD_INPUTM0 = 6'b101101,
    LOAD_INPUTM1 = 6'b101110,
    LOAD_INPUTM2 = 6'b101111
} state_t;
state_t state, next_state;

always_ff @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        state <= IDLE;
        input_write <= '0;
        weight_write <= '0;
        buffer_occupancy <= '0;
        load_input <= '0;
        load_weight <= '0;
        ready <= '0;
        weights_loaded <= '0;
        input_read <= '0;
        weight_read <= '0;
        output_read <= '0;
        overrun <= '0;
        output_row <= '0;
        weight_row <= '0;
        input_row <= '0;
        controller_read <= '0;
        input_wdata <= '0;
        array_in <= '0;
        weight_wdata <= '0;
        counter <= '0;
        output_count <= '0;
        no_outputs <= '0;
        input_count <= '0;
        new_input <= '0;
        count_inference <= '0;
        sent_inputs <= '0;
        missing_row <= '0;
        inference_started <= 0;
    end else begin
        state <= next_state;
        input_write <= input_write_next;
        weight_write <= weight_write_next;
        buffer_occupancy <= buffer_occupancy_next;
        load_input <= load_input_next;
        load_weight <= load_weight_next;
        ready <= ready_next;
        weights_loaded <= weights_loaded_next;
        input_read <= input_read_next;
        weight_read <= weight_read_next;
        output_read <= output_read_next;
        overrun <= overrun_next;
        weight_row <= weight_row_next;
        input_row <= input_row_next;
        controller_read <= controller_read_next;
        input_wdata <= input_wdata_next;
        array_in <= array_in_next;
        weight_wdata <= weight_wdata_next;
        counter <= counter_next;
        no_outputs <= no_outputs_next;
        output_count <= output_count_next;
        input_count <= input_count_next;
        output_row <= output_row_next;
        new_input <= new_input_next;
        count_inference <= count_inference_next;
        sent_inputs <= sent_inputs_next;
        missing_row <= missing_row_next;
        inference_started <= inference_started_next;
    end
end

    always_comb begin
        input_write_next = input_write;
        weight_write_next = weight_write;
        buffer_occupancy_next = buffer_occupancy;
        load_input_next = load_input;
        load_weight_next = load_weight;
        ready_next = ready;
        weights_loaded_next = weights_loaded;
        input_read_next = input_read;
        weight_read_next = weight_read;
        output_read_next = output_read;
        overrun_next = overrun;
        weight_row_next = weight_row;
        input_row_next = input_row;
        controller_read_next = controller_read;
        input_wdata_next = input_wdata;
        array_in_next = array_in;
        weight_wdata_next = weight_wdata;
        no_outputs_next = no_outputs;
        output_count_next = output_count;
        input_count_next = input_count;
        output_row_next = output_row;
        new_input_next = new_input;
        count_inference_next = count_inference;
        sent_inputs_next = sent_inputs;
        missing_row_next = missing_row;
        inference_started_next = inference_started;

        if (inference_done) begin
            inference_started_next = 0;
        end
        case(next_state)
        IDLE: begin
            weight_write_next = '0;
            input_write_next = '0;
            ready_next = 0;
            load_weight_next = 0;
            load_input_next = 0;
            weight_read_next = '0;
            buffer_occupancy_next = '0;
            weights_loaded_next = '0;
            input_read_next = '0;
            output_read_next = '0;
            overrun_next = '0;
            controller_read_next = '0;
            input_wdata_next = '0;
            array_in_next = '0;
            weight_wdata_next = '0;
            weight_row_next = weight_row;
            input_row_next = input_row;
            output_row_next = output_row;
            if (output_count == 0) begin
                no_outputs_next = 1;
            end
        end
        LOAD_WEIGHT0: begin
            weight_read_next = 1;
            weight_row_next = 3'd0;
        end
        LOAD_WEIGHT1: begin
            weight_read_next = 1;
            weight_row_next = 3'd1;
        end
        WAIT_LOAD0: weight_read_next = '0;
        LOAD_WEIGHT2: begin
            load_weight_next = 1;
            array_in_next = weight_rdata;
        end
        LOAD_WEIGHT3: begin
            weight_read_next = 1;
            weight_row_next = 3'd2;
            array_in_next = weight_rdata;
        end
        LOAD_WEIGHTM0: begin
            weight_row_next = 3'd3;
            load_weight_next = 0;
        end
        WAIT_LOAD1: begin
            load_weight_next = 0;
            weight_read_next = 0; 
        end 
        LOAD_WEIGHT4: begin
            load_weight_next = 1;
            array_in_next = weight_rdata;
        end
        LOAD_WEIGHT5: begin
            weight_read_next = 1;
            weight_row_next = 3'd4;
            array_in_next = weight_rdata;
        end
        LOAD_WEIGHTM1: begin
            weight_row_next = 3'd5;
            load_weight_next = 0;
        end
        WAIT_LOAD2: begin
            load_weight_next = 0;
            weight_read_next = 0;
        end
       LOAD_WEIGHT6: begin
            load_weight_next = 1;
            array_in_next = weight_rdata;
        end
        LOAD_WEIGHT7: begin
            weight_read_next = 1;
            weight_row_next = 3'd6;
            array_in_next = weight_rdata;
        end
        LOAD_WEIGHTM2: begin
            weight_row_next = 3'd7;
            load_weight_next = 0;
        end
        WAIT_LOAD3: begin
            weight_read_next = 0;
            load_weight_next = 0;
        end
        LOAD_WEIGHT8: begin
            load_weight_next = 1;
            array_in_next = weight_rdata;
        end
        LOAD_WEIGHT9: begin
            array_in_next = weight_rdata;
            weight_row_next = 3'd0;
            weights_loaded_next = 1;
        end
        LOAD_INPUT0: begin
            input_read_next = 1;
            input_row_next = 3'd0;
            new_input_next = 1;
            output_count_next = input_count;
            inference_started_next = 1;
            if (no_outputs == 0) begin
                overrun_next = 1;
            end
        end
        LOAD_INPUT1: begin
            input_row_next = 3'd1;
            overrun_next = 0;
        end
        WAIT_INPUT0: begin
            input_read_next = 0;
        end
        LOAD_INPUT2: begin
            load_input_next = 1;
            array_in_next = input_rdata;
        end
        LOAD_INPUT3: begin
            input_read_next = 1;
            input_row_next = 3'd2;
            array_in_next = input_rdata;
        end
        LOAD_INPUTM0: begin
            input_row_next = 3'd3;
            load_input_next = 0;
        end
        WAIT_INPUT1: begin
            input_read_next = 0;
            load_input_next = 0;
        end
        LOAD_INPUT4: begin
            load_input_next = 1;
            array_in_next = input_rdata;
        end
        LOAD_INPUT5: begin
            input_read_next = 1;
            input_row_next = 3'd4;
            array_in_next = input_rdata;
        end
        LOAD_INPUTM1: begin
            input_row_next = 3'd5;
            load_input_next = 0;
        end 
        WAIT_INPUT2: begin
            input_read_next = 0;
            load_input_next = 0;
        end
        LOAD_INPUT6: begin
            load_input_next = 1;
            array_in_next = input_rdata;
        end
        LOAD_INPUT7: begin
            input_read_next = 1;
            input_row_next = 3'd6;
            array_in_next = input_rdata;
        end
        LOAD_INPUTM2: begin
            input_row_next = 3'd7;
            load_input_next = 0;
        end
        WAIT_INPUT3: begin
            input_read_next = 0;
            load_input_next = 0;
        end
        LOAD_INPUT8: begin
            load_input_next = 1;
            array_in_next = input_rdata;
        end
        LOAD_INPUT9: begin
            array_in_next = input_rdata;
            input_row_next = 3'd0;
            sent_inputs_next = 1;
            load_input_next = '1;
            input_count_next = '0;
            missing_row_next = input_row;
        end
        LOAD_LESSTHAN8: begin
            load_input_next = 0;
            input_read_next = 0;
        end
        LOAD_EVEN: begin
            load_input_next = 1;
            array_in_next = input_rdata; 
            sent_inputs_next = 1;
            input_row_next = 3'd0;
            missing_row_next = input_row;
            input_count_next = '0;
        end
        LOAD_ODD0: begin
            load_input_next = 1;
            array_in_next = input_rdata;
        end
        LOAD_ODD1: begin 
            array_in_next = input_rdata;
            sent_inputs_next = 1;
            missing_row_next = input_row;
            input_row_next = 3'd0;
            input_count_next = '0;
        end
        WRITE: begin
            ready_next = 0;
            if (addr_in == 10'd0) begin
                if (weight_row == 4'd8) begin
                    buffer_occupancy_next = 1;
                end else begin
                    weight_write_next = 1;
                    weight_wdata_next = controller_write;
                end
            end
            else begin
                if (input_row == 4'd8) begin
                    buffer_occupancy_next = 1;
                end else begin
                    input_write_next = 1;
                    input_count_next = input_count + 1;
                    input_wdata_next = controller_write;
                end
        end
        end
        WAIT_WRITE: begin 
            buffer_occupancy_next = 0;
            weight_write_next = 0;
            input_write_next = 0;
            ready_next = 1;
            if (weight_write == 1) begin 
                if (weight_row == 4'd8) begin
                weight_row_next = 0;
                end else weight_row_next = weight_row + 1;
            end
            if (input_write == 1) begin 
                if (input_row == 4'd8) begin
                    input_row_next = 0;
                end else begin input_row_next = input_row + 1; 
                end
            end
            
        end
        READ0: begin
            output_read_next = 1;
            output_count_next = output_count - 1;
            ready_next = 0;
        end
        READ1: begin
            output_read_next = 0;
        end
        READ2: begin
            controller_read_next = output_rdata;
            output_row_next = output_row + 1;
            ready_next = 1;
        end
        default: ready_next = ready;
        endcase

        if (sent_inputs && (missing_row == 7)) begin
        if (count_inference == 18) begin
            count_inference_next = 0;
            sent_inputs_next = 0;
            missing_row_next = '0;
            load_input_next = 0;
        end else begin
            count_inference_next = count_inference + 1;
            load_input_next = 0;
        end
        end
        if (sent_inputs && (missing_row < 7)) begin
            missing_row_next = missing_row + 1;
            load_input_next = 1;
            array_in_next = 64'd0;
        end
    end

    always_comb begin
        next_state = state;
        counter_next = counter;
        case(state)
        IDLE: begin
            if (write) next_state = WRITE;
            else if (load_weights) next_state = LOAD_WEIGHT0;
            else if (start_inference && !inference_started) next_state = LOAD_INPUT0;
            else if (read) next_state = READ0;
            else next_state = IDLE;
        end
        LOAD_WEIGHT0: next_state = LOAD_WEIGHT1;
        LOAD_WEIGHT1: next_state = WAIT_LOAD0;
        WAIT_LOAD0: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_WEIGHT2;
            end else begin 
                next_state = WAIT_LOAD0;
                counter_next = counter + 1;
            end
        end
        LOAD_WEIGHT2: next_state = LOAD_WEIGHT3;
        LOAD_WEIGHT3: next_state = LOAD_WEIGHTM0;
        LOAD_WEIGHTM0: next_state = WAIT_LOAD1;
        WAIT_LOAD1: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_WEIGHT4;
            end else begin 
                next_state = WAIT_LOAD1;
                counter_next = counter + 1;
            end
        end
        LOAD_WEIGHT4: next_state = LOAD_WEIGHT5;
        LOAD_WEIGHT5: next_state = LOAD_WEIGHTM1;
        LOAD_WEIGHTM1: next_state = WAIT_LOAD2;
        WAIT_LOAD2: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_WEIGHT6;
            end else begin 
                next_state = WAIT_LOAD2;
                counter_next = counter + 1;
            end
        end
        LOAD_WEIGHT6: next_state = LOAD_WEIGHT7;
        LOAD_WEIGHT7: next_state = LOAD_WEIGHTM2;
        LOAD_WEIGHTM2: next_state = WAIT_LOAD3;
        WAIT_LOAD3: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_WEIGHT8;
            end else begin 
                next_state = WAIT_LOAD3;
                counter_next = counter + 1;
            end
        end
        LOAD_WEIGHT8: next_state = LOAD_WEIGHT9;
        LOAD_WEIGHT9: next_state = IDLE;
        LOAD_INPUT0: begin
            if (input_row >= input_count - 1) begin
                next_state = LOAD_LESSTHAN8;
            end else next_state = LOAD_INPUT1;
        end
        LOAD_INPUT1: begin
            if (input_row >= input_count - 1) begin
                next_state = LOAD_LESSTHAN8;
            end else next_state = WAIT_INPUT0;
        end
        WAIT_INPUT0: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_INPUT2;
            end else begin 
                next_state = WAIT_INPUT0;
                counter_next = counter + 1;
            end
        end
        LOAD_INPUT2: begin
            next_state = LOAD_INPUT3;
        end
        LOAD_INPUT3: begin
            if (input_row >= input_count - 1) begin
                next_state = LOAD_LESSTHAN8;
            end else next_state = LOAD_INPUTM0;
        end
        LOAD_INPUTM0: begin
            if (input_row >= input_count - 1) begin
            next_state = LOAD_LESSTHAN8;
            end else next_state = WAIT_INPUT1;
        end
        WAIT_INPUT1: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_INPUT4;
            end else begin 
                next_state = WAIT_INPUT1;
                counter_next = counter + 1;
            end
        end
        LOAD_INPUT4: begin
            next_state = LOAD_INPUT5;
        end
        LOAD_INPUT5: begin
            if (input_row >= input_count - 1) begin
                next_state = LOAD_LESSTHAN8;
            end else next_state = LOAD_INPUTM1;
        end
        LOAD_INPUTM1: begin
            if (input_row >= input_count - 1) begin
            next_state = LOAD_LESSTHAN8;
            end else next_state = WAIT_INPUT2;
        end
        WAIT_INPUT2: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_INPUT6;
            end else begin 
                next_state = WAIT_INPUT2;
                counter_next = counter + 1;
            end
        end
        LOAD_INPUT6: begin
            next_state = LOAD_INPUT7;
        end
        LOAD_INPUT7: begin 
            if (input_row >= input_count - 1) begin
            next_state = LOAD_LESSTHAN8;
            end else next_state = LOAD_INPUTM2;
        end
        LOAD_INPUTM2: next_state = WAIT_INPUT3;
        WAIT_INPUT3: begin
            if (counter == 3) begin
                counter_next = '0;
                next_state = LOAD_INPUT8;
            end else begin
                next_state = WAIT_INPUT3;
                counter_next = counter + 1;
            end
        end
        LOAD_INPUT8: next_state = LOAD_INPUT9;
        LOAD_INPUT9: next_state = IDLE;
        LOAD_LESSTHAN8: begin
            if (input_count % 2 == 0) begin
                next_state = WAIT_LOADODD;
                $display(input_count);
            end else next_state = WAIT_LOADEVEN;
        end
        WAIT_LOADEVEN: begin 
            if (counter == 3) begin
            next_state = LOAD_EVEN;
            counter_next = '0;
            end else begin
                counter_next = counter + 1;
                next_state = WAIT_LOADEVEN;
            end
        end
        WAIT_LOADODD: begin 
            if (counter == 2) begin 
            next_state = LOAD_ODD0;
            counter_next = '0;
            end else begin
                counter_next = counter + 1;
                next_state = WAIT_LOADODD;
            end
        end
        LOAD_EVEN: next_state = IDLE;
        LOAD_ODD0: next_state = LOAD_ODD1;
        LOAD_ODD1: next_state = IDLE;
        WRITE: next_state = WAIT_WRITE;
        WAIT_WRITE: begin
            if (counter == 4) begin
                counter_next = '0;
                next_state = IDLE;
            end else begin
                next_state = WAIT_WRITE;
                counter_next = counter + 1;
            end
        end
        READ0: next_state = READ1;
        READ1: begin
            if (counter == 4) begin
                counter_next = '0;
                next_state = READ2;
            end else begin
                counter_next = counter + 1;
                next_state = READ1;
            end
        end 
        READ2: next_state = IDLE;
        default: next_state = IDLE;
        endcase
    end

endmodule

