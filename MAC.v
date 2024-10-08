`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:29 07/24/2024 
// Design Name: 
// Module Name:    MAC 
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
module MAC #( parameter IN_BITWIDTH = 16,
	      parameter OUT_BITWIDTH = 32 )
			( input [IN_BITWIDTH-1 : 0] a_in,
			  input [IN_BITWIDTH-1 : 0] w_in,
			  input [IN_BITWIDTH-1 : 0] sum_in,
			  input en, clk,
			  output reg [OUT_BITWIDTH-1 : 0] out
			);
	
	reg [OUT_BITWIDTH-1:0] mult_out;
	
	always@(posedge clk) begin
		if(en)
		 begin
			mult_out = a_in * w_in;
			out <= mult_out + sum_in;
		end
		  
	end

endmodule
