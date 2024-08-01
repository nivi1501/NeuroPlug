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

module invMixColumns(input [127:0] state , output reg [127:0] out);
		integer i;
		integer j;
		reg [127:0]temp1;
		reg [127:0]temp2;
		reg [127:0]temp3;

		always @(*)
		begin

		for ( i=  0 ; i <=24 ;i=i+8) begin :loop
			for( j = 0 ; j <=24 ;j=j+8)begin :loop
				temp1[127-4*i-j-:8]=xtime (state[127-4*i-j-:8]);
				temp2[127-4*i-j-:8]=xtime (temp1[127-4*i-j-:8]);
				temp3[127-4*i-j-:8]=xtime (temp2[127-4*i-j-:8]);
			end

		out[127-4*i-:8]=(temp3[127-4*i-:8]^temp2[127-4*i-:8]^temp1[127-4*i-:8])^(temp3[119-4*i-:8]^temp1[119-4*i-:8]^state[119-4*i-:8])^(temp3[111-4*i-:8]^temp2[111-4*i-:8]^state[111-4*i-:8])^(temp3[103-4*i-:8]^state[103-4*i-:8]);
		out[119-4*i-:8]= (temp3[127-4*i-:8]^state[127-4*i-:8])^ (temp3[119-4*i-:8]^temp2[119-4*i-:8]^temp1[119-4*i-:8])^(temp3[111-4*i-:8]^temp1[111-4*i-:8]^state[111-4*i-:8])^(temp3[103-4*i-:8]^temp2[103-4*i-:8]^state[103-4*i-:8]);
		out[111-4*i-:8]= (temp3[127-4*i-:8]^temp2[127-4*i-:8]^state[127-4*i-:8])^(temp3[119-4*i-:8]^state[119-4*i-:8])^ (temp3[111-4*i-:8]^temp2[111-4*i-:8]^temp1[111-4*i-:8])^(temp3[103-4*i-:8]^temp1[103-4*i-:8]^state[103-4*i-:8]);	
		out[103-4*i-:8]=(temp3[127-4*i-:8]^temp1[127-4*i-:8]^state[127-4*i-:8])^(temp3[119-4*i-:8]^temp2[119-4*i-:8]^state[119-4*i-:8])^(temp3[111-4*i-:8]^state[111-4*i-:8])^(temp3[103-4*i-:8]^temp2[103-4*i-:8]^temp1[103-4*i-:8]);

		end
		end

		function [7:0] xtime(input  [7:0] x );

		 xtime=(x[7])?(x<<1)^(8'h1b): x<<1 ;
		 
		endfunction

endmodule


