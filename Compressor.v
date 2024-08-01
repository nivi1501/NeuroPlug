`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:55:41 07/27/2024 
// Design Name: 
// Module Name:    Compressor 
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
module Compressor(clk,i_data,o_data,rst, enable,encoding,ready);
	 
input clk;
input enable;
input [255:0]i_data;
input rst;
output reg ready;
output reg[255:0]o_data;
reg mark8_1,mark8_2,mark8_3;
reg mark4_1 , mark4_2 ,mark4_3 ,mark4_4 ,mark4_5 ,mark4_6 ,mark4_7 ;
reg mark2_1 , mark2_2 ,mark2_3 ,mark2_4 ,mark2_5 ,mark2_6 ,mark2_7 ,mark2_8 ,
    mark2_9 ,mark2_10 ,mark2_11 ,mark2_12 ,mark2_13 ,mark2_14 ,mark2_15 ;
output reg [3:0] encoding;

reg [95:0] CCL1,CCL4;
reg [127:0] CCL2;
reg [191:0] CCL3;
reg [159:0] CCL5;
reg [143:0] CCL6;


reg [63:0] Base8;
reg [63:0] del8_1,del8_2,del8_3;
reg [31:0] Base4;
reg [31:0] del4_1,del4_2,del4_3,del4_4,del4_5,del4_6,del4_7;
reg [15:0] Base2;
reg [15:0] del2_1,del2_2,del2_3,del2_4,del2_5,del2_6,del2_7,del2_8,del2_9,del2_10,del2_11,del2_12,del2_13,del2_14,del2_15;

reg CoN1,CoN2,CoN3,CoN4,CoN5,CoN6;


always @ (posedge clk)
begin
   if (rst)
   begin 
	mark2_1 = 0; mark2_2 = 0;mark2_3 = 0;mark2_4 = 0;mark2_5 = 0;mark2_6 = 0;mark2_7 = 0;mark2_8 = 0;
    mark2_9 = 0;mark2_10 = 0;mark2_11 = 0;mark2_12 = 0;mark2_13 = 0;mark2_14 = 0;mark2_15 = 0;
	mark4_1 = 0; mark4_2 = 0;mark4_3 = 0;mark4_4 = 0;mark4_5 = 0;mark4_6 = 0;mark4_7 = 0;
	CoN1=0;CoN2=0;CoN3=0;CoN4=0;CoN5=0;CoN6=0;
	end
	
   else if (enable) begin
		Base8 = i_data[63:0]; //Base is the first value
		Base4 = i_data[31:0];
		Base2 = i_data[15:0];
		$display("input = %h\n",i_data);

		//BASE 8

		//Calculating all the deltas
		if (Base8 > i_data[127:64])
			del8_1 = Base8 - i_data[127:64];
		else begin
			del8_1 = i_data[127:64] - Base8 ;
			mark8_1 =1;
		end

		if (Base8 > i_data[191:128])
			del8_2 = Base8 - i_data[191:128];
		else begin
			del8_2 = i_data[191:128] - Base8 ;
			mark8_2 = 1;
		end

		if (Base8 > i_data[255:192])
			del8_3 = Base8 - i_data[255:192];
		else begin
			del8_3 = i_data[255:192] - Base8 ;
			mark8_3=1;
		end
		$display (" 8_1: del1= %h, del2 =%h, del3 = %h \n",del8_1,del8_2,del8_3);


		// Delta = 1 byte
		if( ((del8_1[63:8]==56'hFFFFFFFFFFFFFF) || (del8_1[63:8]==56'h00000000000000)) && ((del8_2[63:8]==56'hFFFFFFFFFFFFFF) || (del8_2[63:8]==56'h00000000000000))
		&& ((del8_3[63:8]==56'hFFFFFFFFFFFFFF) || (del8_3[63:8]==56'h00000000000000)))
		begin
			CoN1=1;
			CCL1 = {del8_3[7:0],del8_2[7:0],del8_1[7:0],8'd0,Base8};
		end

		else begin
			CoN1 =0;
		end
		$display ("CoN1 = %b, CCL1 = %h ", CoN1,CCL1);

		// Delta = 2 bytes
		if( ((del8_1[63:16]==48'hFFFFFFFFFFFF) || (del8_1[63:16]==48'h000000000000)) && ((del8_2[63:16]==48'hFFFFFFFFFFFF) || (del8_2[63:16]==48'h000000000000))
		&& ((del8_3[63:16]==48'hFFFFFFFFFFFF) || (del8_3[63:16]==48'h000000000000)))
		begin
			CoN2=1;
			CCL2 = {del8_3[15:0],del8_2[15:0],del8_1[15:0],16'd0,Base8};
		end

		else begin
			CoN2 =0;
		end
		$display ("CoN2 = %b, CCL2 = %h ", CoN2,CCL2);

		// Delta = 4 bytes
		if( ((del8_1[63:32]==32'hFFFFFFFF) || (del8_1[63:32]==32'h00000000)) && ((del8_2[63:32]==32'hFFFFFFFF) || (del8_2[63:32]==32'h00000000))
		&& ((del8_3[63:32]==32'hFFFFFFFF) || (del8_3[63:32]==32'h00000000)))
		begin
			CoN3=1;
			CCL3 = {del8_3[31:0],del8_2[31:0],del8_1[31:0],32'd0,Base8};
		end
		else begin
			CoN3 =0;
		end		
	
		$display ("CoN3 = %b, CCL3 = %h ", CoN3,CCL3);
	
		//BASE 4

		//Calculating all the deltas
		if (Base4 > i_data[63:32]) begin
			del4_1 = Base4 - i_data[63:32];
			end
		else begin
			del4_1 = i_data[63:32] - Base4 ;
			mark4_1 =1;
		end

		if (Base4 > i_data[95:64])
			del4_2 = Base4 - i_data[95:64];
		else begin
			del4_2 = i_data[95:64] - Base4 ;
			mark4_2 =1;
		end

		if (Base4 > i_data[127:96])
			del4_3 = Base4 - i_data[127:96];
		else begin
			del4_3 = i_data[127:96] - Base4 ;
			mark4_3 =1;
		end

		if (Base4 > i_data[159:128])
			del4_4 = Base4 - i_data[159:128];
		else begin
			del4_4 = i_data[159:128] - Base4 ;
			mark4_4 =1;
		end

		if (Base4 > i_data[191:160])
			del4_5 = Base4 - i_data[191:160];
		else begin
			del4_5 = i_data[191:160] - Base4 ;
			mark4_5 =1;
		end

		if (Base4 > i_data[223:192])
			del4_6 = Base4 - i_data[223:192];
		else begin
			del4_6 = i_data[223:192] - Base4 ;
			mark4_6 =1;
		end

		if (Base4 > i_data[255:224])
			del4_7 = Base4 - i_data[255:224];
		else begin
			del4_7 = i_data[255:224] - Base4 ;
			mark4_7 =1;
		end

		$display (" BASE 4: del1= %h, del2 =%h, del3 = %h del4 = %h del5 = %h del6 = %h del7 = %h\n",del4_1,del4_2,del4_3,del4_4,del4_5,del4_6,del4_7);


		// DELTA = 1 BYTE 
		if( ((del4_1[31:8]==24'hFFFFFF) || (del4_1[31:8]==24'h000000)) && ((del4_2[31:8]==24'hFFFFFF) || (del4_2[31:8]==24'h000000))
		&& ((del4_3[31:8]==24'hFFFFFF) || (del4_3[31:8]==24'h000000))  && ((del4_4[31:8]==24'hFFFFFF) || (del4_4[31:8]==24'h000000))  
		&& ((del4_5[31:8]==24'hFFFFFF) || (del4_5[31:8]==24'h000000))  && ((del4_6[31:8]==24'hFFFFFF) || (del4_6[31:8]==24'h000000))
		&& ((del4_7[31:8]==24'hFFFFFF) || (del4_7[31:8]==24'h000000)))
		begin
			CoN4=1;
			CCL4 = {del4_7[7:0],del4_6[7:0],del4_5[7:0],del4_4[7:0],del4_3[7:0],del4_2[7:0],del4_1[7:0],8'd0,Base4};
		end

		else begin
			CoN4 =0;
		end
		$display ("CoN4 = %b, CCL4 = %h ", CoN4,CCL4);


		// DELTA = 2 BYTES
		if( ((del4_1[31:16]==16'hFFFF) || (del4_1[31:16]==16'h0000)) && ((del4_2[31:16]==16'hFFFF) || (del4_2[31:16]==16'h0000))
		&& ((del4_3[31:16]==16'hFFFF) || (del4_3[31:16]==16'h0000))  && ((del4_4[31:16]==16'hFFFF) || (del4_4[31:16]==16'h0000))  
		&& ((del4_5[31:16]==16'hFFFF) || (del4_5[31:16]==16'h0000))  && ((del4_6[31:16]==16'hFFFF) || (del4_6[31:16]==16'h0000))
		&& ((del4_7[31:16]==16'hFFFF) || (del4_7[31:16]==16'h0000)))
		begin
			CoN5=1;
			CCL5 = {del4_7[15:0],del4_6[15:0],del4_5[15:0],del4_4[15:0],del4_3[15:0],del4_2[15:0],del4_1[15:0],16'd0,Base4};
		end

		else begin
			CoN5 =0;
		end
		$display ("CoN5 = %b, CCL5 = %h ", CoN5,CCL5);

		//BASE 2
		//Calculating all the deltas

		if (Base2 > i_data[31:16])
			del2_1 = Base2 - i_data[31:16];
		else begin
			del2_1 = i_data[31:16] - Base2 ;
			mark2_1 =1;
		end

		if (Base2 > i_data[47:32])
			del2_2 = Base2 - i_data[47:32];
		else begin
			del2_2 = i_data[47:32] - Base2 ;
			mark2_2 =1;
		end

		if (Base2 > i_data[63:48])
			del2_3 = Base2 - i_data[63:48];
		else begin
			del2_3 = i_data[63:48] - Base2 ;
			mark2_3 =1;
		end

		if (Base2 > i_data[79:64])
			del2_4 = Base2 - i_data[79:64];
		else begin
			del2_4 = i_data[79:64] - Base2 ;
			mark2_4 =1;
		end

		if (Base2 > i_data[95:80])
			del2_5 = Base2 - i_data[95:80];
		else begin
			del2_5 = i_data[95:80] - Base2 ;
			mark2_5 =1;
		end

		if (Base2 > i_data[111:96])
			del2_6 = Base2 - i_data[111:96];
		else begin
			del2_6 = i_data[111:96] - Base2 ;
			mark2_6 =1;
		end

		if (Base2 > i_data[127:112])
			del2_6 = Base2 - i_data[127:112];
		else begin
			del2_6 = i_data[127:112] - Base2 ;
			mark2_6 =1;
		end

		if (Base2 > i_data[143:128])
			del2_7 = Base2 - i_data[143:128];
		else begin
			del2_7 = i_data[143:128] - Base2 ;
			mark2_7 =1;
		end

		if (Base2 > i_data[159:144])
			del2_8 = Base2 - i_data[159:144];
		else begin
			del2_8 = i_data[159:144] - Base2 ;
			mark2_8 =1;
		end

		if (Base2 > i_data[175:160])
			del2_9 = Base2 - i_data[175:160];
		else begin
			del2_9 = i_data[175:160] - Base2 ;
			mark2_9 =1;
		end

		if (Base2 > i_data[191:176])
			del2_10 = Base2 - i_data[191:176];
		else begin
			del2_10 = i_data[191:176] - Base2 ;
			mark2_10 =1;
		end

		if (Base2 > i_data[191:176])
			del2_11 = Base2 - i_data[191:176];
		else begin
			del2_11 = i_data[191:176] - Base2 ;
			mark2_11 =1;
		end

		if (Base2 > i_data[207:192])
			del2_12 = Base2 - i_data[207:192];
		else begin
			del2_12 = i_data[207:192] - Base2 ;
			mark2_12 =1;
		end

		if (Base2 > i_data[223:208])
			del2_13 = Base2 - i_data[223:208];
		else begin
			del2_13 = i_data[223:208] - Base2 ;
			mark2_13 =1;
		end

		if (Base2 > i_data[239:224])
			del2_14 = Base2 - i_data[239:224];
		else begin
			del2_14 = i_data[239:224] - Base2 ;
			mark2_14 =1;
		end

		if (Base2 > i_data[255:240])
			del2_15 = Base2 - i_data[255:240];
		else begin
			del2_15 = i_data[255:240] - Base2 ;
			mark2_15 =1;
		end

		$display (" BASE 2: del1= %h, del2 =%h, del3 = %h del4 = %h del5 = %h del6 = %h del7 = %h	del8= %h, del9 =%h, del10 = %h del11 = %h del12 = %h del13 = %h del14 = %h del7 = %h \n"
						,del2_1,del2_2,del2_3,del2_4,del2_5,del2_6,del2_7,del2_8,del2_9,del2_10,del2_11,del2_12,del2_13,del2_14,del2_15);

		// DELTA = 1 BYTE 
		if( ((del2_1[15:8]==24'hFF) || (del2_1[15:8]==24'h00)) && ((del2_2[15:8]==24'hFF) || (del2_2[15:8]==24'h00))
				&& ((del2_3[15:8]==24'hFF) || (del2_3[15:8]==24'h00))  && ((del2_4[15:8]==24'hFF) || (del2_4[15:8]==24'h00))  
				&& ((del2_5[15:8]==24'hFF) || (del2_5[15:8]==24'h00))  && ((del2_6[15:8]==24'hFF) || (del2_6[15:8]==24'h00))
				&& ((del2_7[15:8]==24'hFF) || (del2_7[15:8]==24'h00))  && ((del2_8[15:8]==24'hFF) || (del2_8[15:8]==24'h00))
				&& ((del2_9[15:8]==24'hFF) || (del2_9[15:8]==24'h00))  && ((del2_10[15:8]==24'hFF) || (del2_10[15:8]==24'h00))
				&& ((del2_11[15:8]==24'hFF)|| (del2_11[15:8]==24'h00))&& ((del2_12[15:8]==24'hFF) || (del2_12[15:8]==24'h00))
				&& ((del2_13[15:8]==24'hFF)|| (del2_13[15:8]==24'h00))&& ((del2_14[15:8]==24'hFF) || (del2_14[15:8]==24'h00))
				&& ((del2_15[15:8]==24'hFF)|| (del2_15[15:8]==24'h00)))
		begin
			CoN6=1;
			CCL6 = {del2_15[7:0],del2_14[7:0],del2_13[7:0],del2_12[7:0],del2_11[7:0],del2_10[7:0],del2_9[7:0],del2_8[7:0],del2_7[7:0],del2_6[7:0],del2_5[7:0],del2_4[7:0],del2_3[7:0],del2_2[7:0],del2_1[7:0],8'd0,Base2};
		end

		else begin
			CoN6 =0;
		end
		$display ("CoN6 = %b, CCL6 = %h ", CoN6,CCL6);
	end
end


// Behavioural compraator 
always @ (posedge clk)
begin

		if(i_data==0) begin
			encoding =4'b0000;
			o_data = 0;
			ready = 1;
		end

		//BASE 8 DEL 1 BYTE
		else if(CoN1==1)
		begin
			o_data = CCL1;  // 96 bits
			ready=1;
			encoding=4'b0010;
		end

		//BASE 8 DEL 2 BYTES
		else if(CoN2==1) begin
			o_data = CCL2; // 192 bits
			ready=1;
			encoding=4'b0100;
		end

		//BASE 8 DEL 4 BYTES
		else if(CoN3==1) begin
			o_data = CCL3; // 128 bits
			ready=1;
			encoding=4'b0011;
		end

		//BASE 4 DEL 1 BYTE
		else if(CoN4==1) begin
			o_data = CCL4; //96 BITS
			ready=1;
			encoding=4'b0110;
		end

		//BASE 4 DEL 2 BYTES
		else if(CoN5==1) begin
			o_data = CCL5; //160 BITS
			ready=1;
			encoding=4'b0101;
		end


		//BASE 2 DEL 1 BYTE
		else if(CoN6==1) begin
			o_data = CCL6; //144 BITS
			ready=1;
			encoding=4'b0111;
		end

		else if(rst) begin
			ready=0;
		end

		//No Compression feasible
		else begin
			o_data = i_data;
			ready=1;
			encoding[3] = 1'b1;
		end
end

/*
// Jasper verification
property LOAD_W_EN_CHECK;
    @(posedge clk) 
    (enable && ~rst) |-> ##1 (ready);
endproperty

assert property (LOAD_W_EN_CHECK);

property P2;
    @(posedge clk) 
    i_data==0 && ~rst && enable |-> ##1 (encoding==4'b0);
endproperty

assert property (P2);


property P3;
    @(posedge clk) disable iff (rst)
    i_data==0 && ~rst && enable |->  o_data==0;
endproperty

assert property (P3);


property P4;
    @(posedge clk) 
    CoN1 && enable && ~rst && i_data!=0 |-> ##1 encoding==4'b0010;
endproperty
assert property (P4);

property P5;
    @(posedge clk) 
    CoN2 && ~CoN1 && enable && ~rst && i_data!=0 |-> ##1 encoding==4'b0100;
endproperty
assert property (P5);


property P6;
    @(posedge clk) 
    CoN3 && ~CoN2 && ~CoN1 && enable && ~rst && i_data!=0 |-> ##1 encoding==4'b0011;
endproperty
assert property (P6);


property P7;
    @(posedge clk) 
    CoN4 && ~CoN3 && ~CoN2 && ~CoN1 && enable && ~rst && i_data!=0 |-> ##1 encoding==4'b0110;
endproperty
assert property (P7);


property P8;
    @(posedge clk) 
    CoN5 && ~CoN4 && ~CoN3 && ~CoN2 && ~CoN1 && enable && ~rst && i_data!=0 |-> ##1 encoding==4'b0101;
endproperty
assert property (P8);
*/

endmodule
