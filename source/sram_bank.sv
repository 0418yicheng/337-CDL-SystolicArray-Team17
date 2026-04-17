`timescale 1ns / 10ps

module sram_bank #(
    // parameters
) (
    input logic clk, n_rst, read_write, start,
    input logic [3:0] address_in,
    input logic [63:0] wdata_in,
    output logic [63:0] rdata_out,
    output logic transaction_done
);
    logic [9:0] address;
    logic read_enable, write_enable;
    logic [31:0] wdata0, wdata1;
    logic [31:0] rdata0, rdata1;
    logic [2:0] sram_state;
    logic [2:0] count;
    always_ff @(posedge clk or negedge n_rst) begin
       if (!n_rst) begin
            count <= '0;
       end else if (start && (count == 0 || count >= 4)) begin
            count <= 3'd1;
       end else if (count != '0) begin
            count <= count + 1;
       end
    end

    assign read_enable = start & ~read_write;
    assign write_enable = start & read_write;
    assign address = address_in;
    assign wdata0 = wdata_in[31:0];
    assign wdata1 = wdata_in[63:32];
    assign transaction_done = (count == 3'd4);
    assign rdata_out = {rdata1, rdata0};
    sram1024x32_wrapper sram0(.clk(clk), .n_rst(n_rst), .address(address), .read_enable(read_enable), 
    .write_enable(write_enable), .write_data(wdata0), .read_data(rdata0), .sram_state(sram_state));
    sram1024x32_wrapper sram1(.clk(clk), .n_rst(n_rst), .address(address), .read_enable(read_enable), 
    .write_enable(write_enable), .write_data(wdata1), .read_data(rdata1));
    
endmodule

