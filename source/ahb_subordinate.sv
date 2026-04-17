module ahb_subordinate (
    input logic clk,
    input logic n_rst,
    
    // AHB Interface
    input logic hsel,
    input logic [9:0] haddr,
    input logic [1:0] htrans,
    input logic [1:0] hsize,
    input logic hwrite,
    input logic [63:0] hwdata,
    output logic [63:0] hrdata,
    output logic hready,
    output logic hresp,

    // Controller
    input logic ready,
    input logic inference_done,
    input logic weights_loaded,
    input logic [63:0] crdata,          
    output logic [63:0] cwdata,         
    output logic [9:0] caddr,           
    output logic cwrite,                
    output logic cread,                 
    
    // Errors
    input logic boe,
    input logic oe,
    input logic nan_flag,
    input logic inf_flag,

    //Bias Adder
    output logic [63:0] bias,

    //Actvation Module
    output logic [1:0] activation_mode
);

    logic n_write, write;
    logic n_read_en, read_en; 
    logic [9:0] n_addr, addr;
    logic [1:0] n_size, size;
    logic [1:0] n_err_state, err_state;

    logic [63:0] n_bias;
    logic n_start_inference, start_inference;
    logic n_load_weights, load_weights;
    logic [1:0] n_activation_mode;
    
    logic n_boe_reg, boe_reg;
    logic n_oe_reg, oe_reg;
    logic n_nan_reg, nan_reg;
    logic n_inf_reg, inf_reg;
    logic n_ft_reg, ft_reg;

    logic [63:0] byte_mask;
    always_comb begin
        case (size)
            2'b00: byte_mask = 64'hFF << (addr[2:0] * 8);
            2'b01: byte_mask = 64'hFFFF << ({addr[2:1], 1'b0} * 8);
            2'b10: byte_mask = 64'hFFFF_FFFF << ({addr[2], 2'b00} * 8);
            2'b11: byte_mask = 64'hFFFF_FFFF_FFFF_FFFF;
            default: byte_mask = 64'b0;
        endcase
    end

    logic is_busy_access;
    logic is_error_read;

    always_comb begin
        is_error_read = read_en && (addr == 10'h020 || addr == 10'h021);

        n_boe_reg = (boe_reg & ~is_error_read) | boe;
        n_oe_reg  = (oe_reg & ~is_error_read) | oe;
        n_nan_reg = (nan_reg & ~is_error_read) | nan_flag;
        n_inf_reg = (inf_reg & ~is_error_read) | inf_flag;
        n_ft_reg  = (ft_reg & ~is_error_read);

        n_write = 1'b0;
        n_read_en = 1'b0;
        n_addr = addr;
        n_size = size;
        n_err_state = err_state;

        n_bias = bias;
        n_start_inference = start_inference;
        n_load_weights = load_weights;
        n_activation_mode = activation_mode;

        cwrite = 1'b0;
        cread = 1'b0;
        caddr = 10'b0;
        cwdata = 64'b0;
        hresp = 1'b0;
        hready = 1'b1;
        hrdata = 64'b0; 

        if (inference_done) n_start_inference = 1'b0;
        if (weights_loaded) n_load_weights = 1'b0;

        if (err_state == 2'd1) begin
            hresp = 1'b1;
            hready = 1'b0;
            n_err_state = 2'd2;
        end else if (err_state == 2'd2) begin
            hresp = 1'b1;
            hready = 1'b1;
            n_err_state = 2'd0;
        end else begin
        
            if (hsel && (htrans == 2'b10)) begin       

                is_busy_access = !ready && ( (haddr >= 10'h000 && haddr <= 10'h007) || 
                                           (haddr >= 10'h008 && haddr <= 10'h00F) || 
                                           (haddr >= 10'h010 && haddr <= 10'h017) || 
                                           (haddr >= 10'h018 && haddr <= 10'h01F) );

                if (haddr > 10'h024 ||
                   (hwrite && ( (haddr >= 10'h018 && haddr <= 10'h01F) ||
                                (haddr == 10'h020 || haddr == 10'h021) ||
                                (haddr == 10'h023) )) ||
                   (!hwrite && ( (haddr >= 10'h000 && haddr <= 10'h007) ||
                                 (haddr >= 10'h008 && haddr <= 10'h00F) )) ||
                   is_busy_access) begin

                    n_err_state = 2'd1;
                    if (is_busy_access) n_ft_reg = 1'b1;

                end else begin
                    n_write = hwrite;
                    n_read_en = !hwrite; 
                    n_addr = haddr;
                    n_size = hsize;
                end
            end

            if (write) begin
                if (addr >= 10'h000 && addr <= 10'h007) begin
                    cwdata = hwdata & byte_mask;
                    caddr = 10'h000;
                    cwrite = 1'b1;
                end else if (addr >= 10'h008 && addr <= 10'h00F) begin
                    cwdata = hwdata & byte_mask;
                    caddr = 10'h008;
                    cread = 1'b1; 
                end else if (addr >= 10'h010 && addr <= 10'h017) begin
                    n_bias = (hwdata & byte_mask) | (bias & ~byte_mask);
                end else if (addr == 10'h022) begin
                    if (byte_mask[16]) begin
                        n_start_inference = hwdata[16];
                        n_load_weights = hwdata[17]; 
                    end
                end else if (addr == 10'h024) begin
                    if (byte_mask[32]) begin
                        n_activation_mode = hwdata[33:32];
                    end
                end
            end

            if (read_en) begin
                if (addr >= 10'h010 && addr <= 10'h017) begin
                    hrdata = bias;
                end else if (addr >= 10'h018 && addr <= 10'h01F) begin
                    hready = 1'b1;
                    hrdata = crdata;
                end else if (addr == 10'h020 || addr == 10'h021) begin
                    hrdata = {48'b0, 6'b0, inf_reg, nan_reg, 4'b0, ft_reg, 1'b0, oe_reg, boe_reg};
                end else if (addr == 10'h022) begin
                    hrdata = {40'b0, 6'b0, load_weights, start_inference, 16'b0};
                end else if (addr == 10'h023) begin
                    hrdata = {32'b0, 6'b0, ~ready, inference_done, 24'b0}; 
                end else if (addr == 10'h024) begin
                    hrdata = {24'b0, 6'b0, activation_mode, 32'b0};
                end
                
                hrdata = hrdata & byte_mask;
            end
        end
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            addr <= 10'b0;
            write <= 1'b0;
            read_en <= 1'b0;
            size <= 2'b0;
            err_state <= 2'b0;
            bias <= 64'b0;
            start_inference <= 1'b0;
            load_weights <= 1'b0;
            activation_mode <= 2'b0;
            
            boe_reg <= 1'b0;
            oe_reg <= 1'b0;
            nan_reg <= 1'b0;
            inf_reg <= 1'b0;
            ft_reg <= 1'b0;
        end else begin
            addr <= n_addr;
            write <= n_write;
            read_en <= n_read_en;
            size <= n_size;
            err_state <= n_err_state;
            bias <= n_bias;
            start_inference <= n_start_inference;
            load_weights <= n_load_weights;
            activation_mode <= n_activation_mode;

            boe_reg <= n_boe_reg;
            oe_reg <= n_oe_reg;
            nan_reg <= n_nan_reg;
            inf_reg <= n_inf_reg;
            ft_reg <= n_ft_reg;
        end
    end

endmodule