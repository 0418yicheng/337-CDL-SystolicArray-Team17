`timescale 1ns / 10ps

module data_buffer #(
    // parameters
) (
    input logic clk, n_rst, input_write, input_read, weight_write, weight_read, output_read, done, new_input,
    input logic [3:0] weight_row, input_row, output_row, 
    input logic [2:0] input_count,
    input logic [63:0] input_wdata, weight_wdata, activations,
    output logic [63:0] input_rdata, weight_rdata, output_rdata,
    output logic inference_done
);
    logic start_weight0, start_weight1, start_input0, start_input1, start_output0, start_output1, start_output0_next, start_output1_next, start_weight0_next, start_weight1_next, start_input0_next, start_input1_next, start_output2, start_output3, start_output4, start_output5, start_output6, start_output7, start_output2_next, start_output3_next, start_output4_next, start_output5_next, start_output6_next, start_output7_next;
    logic read_write_weight0, read_write_weight1, read_write_input0, read_write_input1, read_write_output0, read_write_output1, read_write_output0_next, read_write_output1_next, read_write_input0_next, read_write_input1_next, read_write_weight0_next, read_write_weight1_next, read_write_output2, read_write_output3, read_write_output4, read_write_output5, read_write_output6, read_write_output7, read_write_output2_next, read_write_output3_next, read_write_output4_next, read_write_output5_next, read_write_output6_next, read_write_output7_next;
    logic [3:0] addr_weight0, addr_weight1, addr_input0, addr_input1, addr_weight0_next, addr_weight1_next, addr_input0_next, addr_input1_next;
    logic [63:0] weight0_in, weight1_in, input0_in, input1_in, input0_in_next, input1_in_next, weight0_in_next, weight1_in_next;
    logic [63:0] weight0_out, weight1_out, input0_out, input1_out, output0_out, output1_out, output2_out, output3_out, output4_out, output5_out, output6_out, output7_out;
    logic weight0_done, weight1_done, input0_done, input1_done, output0_done, output1_done, output2_done, output3_done, output4_done, output5_done, output6_done, output7_done;
    logic done_buffered, done_buffered_2, done_buffered_3;
    logic [3:0] output_row_write, output_row_write_next;
    logic output_sel, output_sel_next;
    logic [63:0] activations_latch0, activations_latch1, activations_latch0_next, activations_latch1_next, activations_latch2, activations_latch3, activations_latch4, activations_latch5, activations_latch6, activations_latch7, activations_latch2_next, activations_latch3_next, activations_latch4_next, activations_latch5_next, activations_latch6_next, activations_latch7_next;

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            output_row_write <= 0;
            done_buffered <= 0;
            done_buffered_2 <= 0;
            output_sel <= 0;
            activations_latch0 <= '0;
            activations_latch1 <= '0;
            activations_latch2 <= '0;
            activations_latch3 <= '0;
            activations_latch4 <= '0;
            activations_latch5 <= '0;
            activations_latch6 <= '0;
            activations_latch7 <= '0;
            addr_weight0 <= '0;
            addr_weight1 <= '0;
            addr_input0 <= '0;
            addr_input1 <= '0;
            read_write_output0 <= '0;
            read_write_output1 <= '0;
            read_write_output2 <= '0;
            read_write_output3 <= '0;
            read_write_output4 <= '0;
            read_write_output5 <= '0;
            read_write_output6 <= '0;
            read_write_output7 <= '0;
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
            start_output2 <= '0;
            start_output3 <= '0;
            start_output4 <= '0;
            start_output5 <= '0;
            start_output6 <= '0;
            start_output7 <= '0;
        end else begin
            done_buffered <= done;
            done_buffered_2 <= done_buffered;
            output_sel <= output_sel_next;
            activations_latch0 <= activations_latch0_next;
            activations_latch1 <= activations_latch1_next;
            activations_latch2 <= activations_latch2_next;
            activations_latch3 <= activations_latch3_next;
            activations_latch4 <= activations_latch4_next;
            activations_latch5 <= activations_latch5_next;
            activations_latch6 <= activations_latch6_next;
            activations_latch7 <= activations_latch7_next;
            read_write_output0 <= read_write_output0_next;
            read_write_output1 <= read_write_output1_next;
            read_write_output2 <= read_write_output2_next;
            read_write_output3 <= read_write_output3_next;
            read_write_output4 <= read_write_output4_next;
            read_write_output5 <= read_write_output5_next;
            read_write_output6 <= read_write_output6_next;
            read_write_output7 <= read_write_output7_next;
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
            start_output2 <= start_output2_next;
            start_output3 <= start_output3_next;
            start_output4 <= start_output4_next;
            start_output5 <= start_output5_next;
            start_output6 <= start_output6_next;
            start_output7 <= start_output7_next;
        end
    end

    always_comb begin   
        input_rdata = '0;
        weight_rdata = '0;
        output_rdata = '0;
        output_sel_next = output_sel;
        activations_latch0_next = activations_latch0;
        activations_latch1_next = activations_latch1;
        activations_latch2_next = activations_latch2;
        activations_latch3_next = activations_latch3;
        activations_latch4_next = activations_latch4;
        activations_latch5_next = activations_latch5;
        activations_latch6_next = activations_latch6;
        activations_latch7_next = activations_latch7;
        read_write_output0_next = read_write_output0;
        read_write_output1_next = read_write_output1;
        read_write_output2_next = read_write_output2;
        read_write_output3_next = read_write_output3;
        read_write_output4_next = read_write_output4;
        read_write_output5_next = read_write_output5;
        read_write_output6_next = read_write_output6;
        read_write_output7_next = read_write_output7;
        start_output0_next = start_output0;
        start_output1_next = start_output1;
        start_output2_next = start_output2;
        start_output3_next = start_output3;
        start_output4_next = start_output4;
        start_output5_next = start_output5;
        start_output6_next = start_output6;
        start_output7_next = start_output7;
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
        inference_done = 0;

        if (new_input) begin
            output_row_write_next = '0;
        end

        if (done_buffered) begin
            output_sel_next = 1;
        end

        if (output_sel) begin
            if (output_row_write == 0 && input_count >= 0) begin
                start_output0_next = 1;
                read_write_output0_next = 1;
                activations_latch0_next = activations;
                if (input_count < 0) begin
                   activations_latch0_next = '0; 
                end
                end
                output_row_write_next = output_row_write + 1;
            end else if (output_row_write == 1 && input_count >= 1) begin
                start_output1_next = 1;
                read_write_output1_next = 1;
                activations_latch1_next = activations;
                if (input_count < 1) begin
                   activations_latch1_next = '0; 
                end
                output_row_write_next = output_row_write + 1;
            end else if (output_row_write == 2 && input_count >= 2) begin
                start_output2_next = 1;
                read_write_output2_next = 1;
                activations_latch2_next = activations;
                if (input_count < 2) begin
                   activations_latch2_next = '0; 
                end
                output_row_write_next = output_row_write + 1;
            end else if (output_row_write == 3 && input_count >= 3) begin
                start_output3_next = 1;
                read_write_output3_next = 1;
                activations_latch3_next = activations;
                if (input_count < 3) begin
                   activations_latch3_next = '0; 
                end
                output_row_write_next = output_row_write + 1;
            end else if (output_row_write ==4 && input_count >= 4) begin
                start_output4_next = 1;
                read_write_output4_next = 1;
                activations_latch4_next = activations;
                if (input_count < 4) begin
                   activations_latch4_next = '0; 
                end
                output_row_write_next = output_row_write + 1;
            end else if (output_row_write == 5 && input_count >= 5) begin
                start_output5_next = 1;
                read_write_output5_next = 1;
                activations_latch5_next = activations;
                if (input_count < 5) begin
                   activations_latch5_next = '0; 
                end
                output_row_write_next = output_row_write + 1;
            end else if (output_row_write == 6 && input_count >= 6) begin
                start_output6_next = 1;
                read_write_output6_next = 1;
                activations_latch6_next = activations;
                if (input_count < 6) begin
                   activations_latch6_next = '0; 
                end
                output_row_write_next = output_row_write + 1;
            end else if (output_row_write == 7 && input_count >= 7) begin
                start_output7_next = 1;
                read_write_output7_next = 1;
                activations_latch7_next = activations;
                output_row_write_next = output_row_write + 1;
            end else begin
                output_row_write_next = '0;
                output_sel_next = 0;
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
            if (output_row == 0) begin
                start_output0_next = 1;
                read_write_output0_next = 0;
            end else if (output_row == 1) begin
                start_output1_next = 1;
                read_write_output1_next = 0;
            end else if (output_row == 2) begin
                start_output2_next = 1;
                read_write_output2_next = 0;
            end else if (output_row == 3) begin
                start_output3_next = 1;
                read_write_output3_next = 0;
            end else if (output_row == 4) begin
                start_output4_next = 1;
                read_write_output4_next = 0;
            end else if (output_row == 5) begin
                start_output5_next = 1;
                read_write_output5_next = 0;
            end else if (output_row == 6) begin
                start_output6_next = 1;
                read_write_output6_next = 0;
            end else if (output_row == 7) begin
                start_output7_next = 1;
                read_write_output7_next = 0;
            end
            end
        if (output0_done) begin
            if (read_write_output0 == 0) begin
            output_rdata = output0_out;
            end
            start_output0_next = 0;
            read_write_output0_next = 0;
            if (read_write_output0 == 1) begin
            activations_latch0_next = '0;
            inference_done = 1;
            end
        end
        if (output1_done) begin
            if (read_write_output1 == 0) begin
            output_rdata = output1_out;
            end
            start_output1_next = 0;
            read_write_output1_next = 0;
            if (read_write_output1 == 1) begin
            activations_latch1_next = '0;
            end
        end
        if (output2_done) begin
            if (read_write_output2 == 0) begin
            output_rdata = output2_out;
            end
            start_output2_next = 0;
            read_write_output2_next = 0;
            if (read_write_output2 == 1) begin
            activations_latch2_next = '0;
            end
        end
        if (output3_done) begin
            if (read_write_output3 == 0) begin
            output_rdata = output3_out;
            end
            start_output3_next = 0;
            read_write_output3_next = 0;
            if (read_write_output3 == 1) begin
            activations_latch3_next = '0;
            end
        end
        if (output4_done) begin
            if (read_write_output4 == 0) begin
            output_rdata = output4_out;
            end
            start_output4_next = 0;
            read_write_output4_next = 0;
            if (read_write_output4 == 1) begin
            activations_latch4_next = '0;
            end
        end
        if (output5_done) begin
            if (read_write_output5 == 0) begin
            output_rdata = output5_out;
            end
            start_output5_next = 0;
            read_write_output5_next = 0;
            if (read_write_output5 == 1) begin
            activations_latch5_next = '0;
            end
        end
        if (output6_done) begin
            if (read_write_output6 == 0) begin
            output_rdata = output6_out;
            end
            start_output6_next = 0;
            read_write_output6_next = 0;
            if (read_write_output6 == 1) begin
            activations_latch6_next = '0;
            end
        end
        if (output7_done) begin
            if (read_write_output7 == 0) begin
            output_rdata = output7_out;
            end
            start_output7_next = 0;
            read_write_output7_next = 0;
            if (read_write_output7 == 1) begin
            activations_latch7_next = '0;
            end
        end
        end

        

    sram_bank weight0 (.clk(clk), .n_rst(n_rst), .read_write(read_write_weight0), .address_in(addr_weight0), .wdata_in(weight0_in), .rdata_out(weight0_out), .transaction_done(weight0_done), .start(start_weight0 & ~weight0_done));
    sram_bank weight1 (.clk(clk), .n_rst(n_rst), .read_write(read_write_weight1), .address_in(addr_weight1), .wdata_in(weight1_in), .rdata_out(weight1_out), .transaction_done(weight1_done), .start(start_weight1 & ~weight1_done));
    sram_bank input0 (.clk(clk), .n_rst(n_rst), .read_write(read_write_input0), .address_in(addr_input0), .wdata_in(input0_in), .rdata_out(input0_out), .transaction_done(input0_done), .start(start_input0 & ~input0_done));
    sram_bank input1 (.clk(clk), .n_rst(n_rst), .read_write(read_write_input1), .address_in(addr_input1), .wdata_in(input1_in), .rdata_out(input1_out), .transaction_done(input1_done), .start(start_input1 & ~input1_done));
    sram_bank output0 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output0), .address_in('0), .wdata_in(activations_latch0), .rdata_out(output0_out), .transaction_done(output0_done), .start(start_output0 & ~output0_done));
    sram_bank output1 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output1), .address_in('0), .wdata_in(activations_latch1), .rdata_out(output1_out), .transaction_done(output1_done), .start(start_output1 & ~output1_done));
    sram_bank output2 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output2), .address_in('0), .wdata_in(activations_latch2), .rdata_out(output2_out), .transaction_done(output2_done), .start(start_output2 & ~output2_done));
    sram_bank output3 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output3), .address_in('0), .wdata_in(activations_latch3), .rdata_out(output3_out), .transaction_done(output3_done), .start(start_output3 & ~output3_done));
    sram_bank output4 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output4), .address_in('0), .wdata_in(activations_latch4), .rdata_out(output4_out), .transaction_done(output4_done), .start(start_output4 & ~output4_done));
    sram_bank output5 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output5), .address_in('0), .wdata_in(activations_latch5), .rdata_out(output5_out), .transaction_done(output5_done), .start(start_output5 & ~output5_done));
    sram_bank output6 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output6), .address_in('0), .wdata_in(activations_latch6), .rdata_out(output6_out), .transaction_done(output6_done), .start(start_output6 & ~output6_done));
    sram_bank output7 (.clk(clk), .n_rst(n_rst), .read_write(read_write_output7), .address_in('0), .wdata_in(activations_latch7), .rdata_out(output7_out), .transaction_done(output7_done), .start(start_output7 & ~output7_done));

endmodule