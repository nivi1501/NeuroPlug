`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:29 07/24/2024 
// Design Name: 
// Module Name:    router_west_wght
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module router_west_wght
    #(
        parameter DATA_BITWIDTH = 16,
        parameter ADDR_BITWIDTH_GLB = 10,
        parameter ADDR_BITWIDTH_SPAD = 9,
        parameter X_dim = 5,
        parameter Y_dim = 3,
        parameter kernel_size = 3,
        parameter act_size = 5,
        parameter W_READ_ADDR = 0, 
        parameter W_LOAD_ADDR = 0
    )
    (
        input clk,
        input reset,
        output [ADDR_BITWIDTH_GLB-1:0] west_addr_read,
        output west_req_read,
                // Interface with West
        input [DATA_BITWIDTH-1:0] west_data_i,
        input west_enable_i,
        output [DATA_BITWIDTH-1:0] west_data_o,
        output west_enable_o
    );
    
    reg [DATA_BITWIDTH-1:0] data_out;
    
    reg load_spad_ctrl_0, load_spad_ctrl_1, load_spad_ctrl_c;
    wire load_spad_ctrl;

    assign load_spad_ctrl = load_spad_ctrl_0 & (~load_spad_ctrl_1);
    
    always @(posedge clk) begin
        if (reset) begin 
            load_spad_ctrl_0 <= 0;
            load_spad_ctrl_1 <= 0;
        end else begin
            load_spad_ctrl_0 <= load_spad_ctrl_c;
            load_spad_ctrl_1 <= load_spad_ctrl_0;
        end
    end
    
    always @(*) begin
			if (west_enable_i) begin
            data_out = west_data_i;
            load_spad_ctrl_c = 1;
        end  else begin 
            data_out = 16'h0000;
            load_spad_ctrl_c = 0;
        end
    end
    
    router_iact
    #(
        .DATA_BITWIDTH(DATA_BITWIDTH),
        .ADDR_BITWIDTH_GLB(ADDR_BITWIDTH_GLB),
        .ADDR_BITWIDTH_SPAD(ADDR_BITWIDTH_SPAD),
        .X_dim(X_dim),
        .Y_dim(Y_dim),
        .kernel_size(kernel_size),
        .act_size(act_size),
        .A_READ_ADDR(W_READ_ADDR), 
        .A_LOAD_ADDR(W_LOAD_ADDR)
    )
    router_wght_0 (
        .clk(clk),
        .reset(reset),
        .r_data_glb_iact(data_out),
        .r_addr_glb_iact(west_addr_read),
        .read_req_glb_iact(west_req_read),
        .w_data_spad(west_data_o),
        .load_en_spad(west_enable_o),
        .load_spad_ctrl(load_spad_ctrl),
        .iact(1'b0)
    );
    
   
endmodule
