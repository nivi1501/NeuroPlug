`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:10:36 07/19/2024 
// Design Name: 
// Module Name:    mux2 
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
 `timescale 1ns / 1ps

module mux2 #( parameter WIDTH = 16)
	(
    input [WIDTH-1:0] a_in,
    input sel,
    output [WIDTH-1:0] out
    );
	
	assign out = sel ? a_in : 0;
	
endmodule
