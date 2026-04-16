`timescale 1ns / 10ps

module data_buffer #(
    // parameters
) (
    input logic clk, n_rst, input_write, input_read, weight_write, weight_read, output_read, done, new_input,
    input logic [2:0] weight_row, input_row, output_row, input_count,
    input logic [63:0] input_wdata, weight_wdata, activations,
    output logic [63:0] input_rdata, weight_rdata, output_rdata
);
    logic start_weight0, start_weight1, start_input0, start_input1, start_output0, start_output1, start_output0_next, start_output1_next, start_weight0_next, start_weight1_next, start_input0_next, start_input1_next;
    logic read_write_weight0, read_write_weight1, read_write_input0, read_write_input1, read_write_output0, read_write_output1, read_write_output0_next, read_write_output1_next, read_write_input0_next, read_write_input1_next, read_write_weight0_next, read_write_weight1_next;
    logic [3:0] addr_weight0, addr_weight1, addr_input0, addr_input1, addr_output0, addr_output1, addr_output0_next, addr_output1_next, addr_weight0_next, addr_weight1_next, addr_input0_next, addr_input1_next;
    logic [63:0] weight0_in, weight1_in, input0_in, input1_in, input0_in_next, input1_in_next, weight0_in_next, weight1_in_next;
    logic [63:0] weight0_out, weight1_out, input0_out, input1_out, output0_out, output1_out;
    logic weight0_done, weight1_done, input0_done, input1_done, output0_done, output1_done;
    logic done_buffered, done_buffered_2, done_buffered_3;
    logic [2:0] output_row_write, output_row_write_next;
    logic output_sel, output_sel_next;
    logic [63:0] activations_latch0, activations_latch1, activations_latch0_next, activations_latch1_next;

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            output_row_write <= 0;
            done_buffered <= 0;
            done_buffered_2 <= 0;
            output_sel <= 0;
            activations_latch0 <= '0;
            activations_latch1 <= '0;
            addr_output0 <= '0;
            addr_output1 <= '0;
            addr_weight0 <= '0;
            addr_weight1 <= '0;
            addr_input0 <= '0;
            addr_input1 <= '0;
            read_write_output0 <= '0;
            read_write_output1 <= '0;
            start_output0 <= '0;
            start_output1 <= '0;
            output_row_write <= '0;
            start_input0 <= '0;
            start_input1 <= '0;
            start_weight0 <= '0;
            start_weight1 <= '0;
            read_write_input0 <= '0;
            read_write_input1 <= '0;
            read_write_weight0 <= '0;
            read_write_weight1 <= '0;
            input0_in <= '0;
            input1_in <= '0;
            weight0_in <= '0;
            weight1_in <= '0;
        end else begin
            done_buffered <= done;
            done_buffered_2 <= done_buffered;
            output_sel <= output_sel_next;
            activations_latch0 <= activations_latch0_next;
            activations_latch1 <= activations_latch1_next;
            addr_output0 <= addr_output0_next;
            addr_output1 <= addr_output1_next;
            read_write_output0 <= read_write_output0_next;
            read_write_output1 <= read_write_output1_next;
            start_output0 <= start_output0_next;
            start_output1 <= start_output1_next;
            output_row_write <= output_row_write_next;
            addr_weight0 <= addr_weight0_next;
            addr_weight1 <= addr_weight1_next;
            addr_input0 <= addr_input0_next;
            addr_input1 <= addr_input1_next;
            start_input0 <= start_input0_next;
            start_input1 <= start_input1_next;
            start_weight0 <= start_weight0_next;
            start_weight1 <= start_weight1_next;
            read_write_input0 <= read_write_input0_next;
            read_write_input1 <= read_write_input1_next;
            read_write_weight0 <= read_write_weight0_next;
            read_write_weight1 <= read_write_weight1_next;
            input0_in <= input0_in_next;
            input1_in <= input1_in_next;
            weight0_in <= weight0_in_next;
            weight1_in <= weight1_in_next;
        end
    end

    always_comb begin   
        input_rdata = '0;
        weight_rdata = '0;
        output_rdata = '0;
        output_sel_next = output_sel;
        activations_latch0_next = activations_latch0;
        activations_latch1_next = activations_latch1;
        addr_output0_next = addr_output0;
        addr_output1_next = addr_output1;
        read_write_output0_next = read_write_output0;
        read_write_output1_next = read_write_output1;
        start_output0_next = start_output0;
        start_output1_next = start_output1;
        start_input0_next = start_input0;
        start_input1_next = start_input1;
        start_weight0_next = start_weight0;
        start_weight1_next = start_weight1;
        output_row_write_next = output_row_write;
        addr_input0_next = addr_input0;
        addr_input1_next = addr_input1;
        addr_weight0_next = addr_weight0;
        addr_weight1_next = addr_weight1;
        read_write_input0_next = read_write_input0;
        read_write_input1_next = read_write_input1;
        read_write_weight0_next = read_write_weight0;
        read_write_weight1_next = read_write_weight1;
        weight0_in_next = weight0_in;
        weight1_in_next = weight1_in;
        input0_in_next = input0_in;
        input1_in_next = input1_in;

        if (new_input) begin
            output_row_write_next = '0;
        end

        if (done_buffered_2) begin
            if (output_sel == 0) begin
                start_output0_next = 1;
                read_write_output0_next = 1;
                activations_latch0_next = activations;
                addr_output0_next = output_row_write / 2;
            end else begin
                start_output1_next = 1;
                read_write_output1_next = 1;
                activations_latch1_next = activations;
                addr_output1_next = output_row_write / 2;
            end
                output_sel_next = ~output_sel;
                output_row_write_next = output_row_write + 1;
        end

        if (weight_write || weight_read) begin
            if (weight_row % 2 == 0) begin
                start_weight0_next = 1;
                read_write_weight0_next = ~weight_read;
                addr_weight0_next = weight_row / 2;
                weight0_in_next = weight_wdata;
            end else begin
                start_weight1_next = 1;
                read_write_weight1_next = ~weight_read;
                addr_weight1_next = weight_row / 2;
                weight1_in_next = weight_wdata;
            end
            end

        if (weight0_done) begin
            weight_rdata = weight0_out;
            start_weight0_next = '0;
            read_write_weight0_next = '0;
            addr_weight0_next = '0;
            weight0_in_next = '0;
        end

        if (weight1_done) begin
            weight_rdata = weight1_out;
            start_weight1_next = '0;
            read_write_weight1_next = '0;
            addr_weight1_next = '0;
            weight1_in_next = '0;
        end

        if (input_write || input_read) begin
            if (input_row % 2 == 0) begin
                start_input0_next = 1;
                read_write_input0_next = ~input_read;
                addr_input0_next = input_row / 2;
                input0_in_next = input_wdata;
            end else begin
                start_input1_next = 1;
                read_write_input1_next = ~input_read;
                addr_input1_next = input_row / 2;
                input1_in_next = input_wdata;
            end
        end

        if (input0_done) begin
            input_rdata = input0_out;
            start_input0_next = '0;
            read_write_input0_next = '0;
            addr_input0_next = '0;
            input0_in_next = '0;
        end
        if (input1_done) begin
            input_rdata = input1_out;
            start_input1_next = '0;
            read_write_input1_next = '0;
            addr_input1_next = '0;
            input1_in_next = '0;
        end

        if (output_read) begin
            if (output_row % 2 == 0) begin
                start_output0_next = 1;
                read_write_output0_next = 0;
                addr_output0_next = output_row / 2;
                activations_latch0_next = activations;
            end else begin
                start_output1_next = 1;
                read_write_output1_next = 0;
                addr_output1_next = output_row / 2;
                activations_latch1_next = activations;
            end
        end

        if (output0_done) begin
            output_rdata = output0_out;
            start_output0_next = 0;
            read_write_output0_next = 0;
            addr_output0_next = '0;
            activations_latch0_next = '0;
        end

        if (output1_done) begin

            output_rdata = output1_out;
            start_output1_next = 0;
            read_write_output1_next = 0;
            addr_output1_next = '0;
            activations_latch1_next = '0;
        end
        end
    sram_bank weight0 (.clk(clk), .n_rst(n_rst), .read_write(read_write_weight0), .address_in(addr_weight0), .wdata_in(weight0_in), .rdata_out(weight0_out), .transaction_done(weight0_done), .start(start_weight0 & ~weight0_done));
    sram_bank weight1 (.clk(clk), .n_rst(n_rst), .read_write(read_write_weight1), .address_in(addr_weight1), .wdata_in(weight1_in), .rdata_out(weight1_out), .transaction_done(weight1_done), .start(start_weight1 & ~weight1_done));
    sram_bank input0 (.clk(clk), .n_rst(n_rst), .read_write(read_write_input0), .address_in(addr_input0), .wdata_in(input0_in), .rdata_out(input0_out), .transaction_done(input0_done), .start(start_input0 & ~input0_done));
    sram_bank input1 (.clk(clk), .n_rst(n_rst), .read_write(read_write_input1), .address_in(addr_input1), .wdata_in(input1_in), .rdata_out(input1_out), .transaction_done(input1_done), .start(start_input1 & ~input1_done));
    sram_bank output0 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output0), .address_in(addr_output0), .wdata_in(activations_latch0), .rdata_out(output0_out), .transaction_done(output0_done), .start(start_output0 & ~output0_done));
    sram_bank output1 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output1), .address_in(addr_output1), .wdata_in(activations_latch1), .rdata_out(output1_out), .transaction_done(output1_done), .start(start_output1 & ~output1_done));

endmodule