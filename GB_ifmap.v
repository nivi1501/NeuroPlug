`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:19 07/23/2024 
// Design Name: 
// Module Name:    GB_ifmap 
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
module GB_ifmap
     #( parameter DATA_BITWIDTH = 16,
			 parameter ADDR_BITWIDTH = 10 )
		   ( input clk,
			 input reset,
			 input read_req,
			 input write_en,
			 input [ADDR_BITWIDTH-1 : 0] r_addr,
			 input [ADDR_BITWIDTH-1 : 0] w_addr,
			 input [DATA_BITWIDTH-1 : 0] w_data,
			 output  [DATA_BITWIDTH-1 : 0] r_data
    );
	
	reg [DATA_BITWIDTH-1 : 0] mem [0 : (1 << ADDR_BITWIDTH) - 1]; 
	reg [DATA_BITWIDTH-1 : 0] data;
	
	always@(posedge clk)
		begin : READ
			if(reset)
				data = 0;
			else
			begin
				if(read_req) begin
					data = mem[r_addr];
				end else begin
					data = 11100; //Random default value to verify model
				end
			end
		end
	
	assign r_data = data;
	
	always@(posedge clk)
		begin : WRITE	
			if(write_en && !reset) begin
				mem[w_addr] = w_data;
			end
		end
	
endmodule

