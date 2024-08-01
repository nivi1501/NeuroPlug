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
module AES_Decrypt#(parameter N=128,parameter Nr=10,parameter Nk=4)(datain,key,state,reset,clk,start,en);
input [127:0] datain;
input [N-1:0] key;
input en;
output reg [127:0] state;
input reset;
input clk;
output reg start;

wire [(128*(Nr+1))-1:0] keys;
reg [127:0] a1;
wire [127:0] a2;
wire [127:0] a3;
reg [127:0] a4;
wire [127:0] b1;
wire [127:0] b2;
wire [127:0] b3;
	 
	 	 integer i = - Nr - 1;
			always @(posedge clk or posedge reset)begin
			if(reset) begin
						i = - Nr - 1;
						state=128'hx;
						a1 = 128'hx;
						a4 = 128'hx;
						start = 0;
			end
			else if(en) begin
				if( i == 0)begin
						a1 = a3;
						state=a3;
						i = i + 1;
						start = 0;
				end
				else if(i > 0 && i < Nr - 1) begin
						a1 = a2;
						state=a2;
						i = i + 1;
						start = 0;
				end
				else if(i == Nr - 1 ) begin
						a4=a2;
						state=a2;
						i = i + 1;
						start = 0;
				end
				else if(i >= Nr ) begin
						state=b3;
						i=0;
						start = 1;
				end 
				else begin
				i = i + 1;
				end
			end
		end
				
//assign start = (i==Nr)? 1'b1:1'b0;
	 
KeyExpansion #(N,Nr,Nk) ke (key, keys);
Addroundkey ark(datain, keys[127:0], a3);
invround ir(a1, a2, keys[128 * (i) +: 128]);
invShiftBytes ishb(a4,b1);
invsubBytes isb(b1,b2);
Addroundkey eark(b2,keys[128*Nr +: 128],b3);
endmodule