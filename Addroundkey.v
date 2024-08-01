`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:46 08/01/2024 
// Design Name: 
// Module Name:    
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

module Addroundkey(data,key,out);
			input [127:0] data;
			input [127:0] key;
			output reg [127:0] out;

			always @(*) begin
			out <= data ^ key;
			end
endmodule