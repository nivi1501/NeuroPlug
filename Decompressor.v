`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:01:38 07/27/2024 
// Design Name: 
// Module Name:    Decompressor 
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
module Decompressor(i_data, o_data, enable, ready, clock, rst ,encoding );

input clock;
input enable;
output reg [255:0] o_data;
input rst;
input [3:0] encoding;
output reg ready;
input [255:0]i_data;


// For now set marks==0
reg  mark8_1,mark8_2,mark8_3;
reg  mark4_1 , mark4_2 ,mark4_3 ,mark4_4 ,mark4_5 ,mark4_6 ,mark4_7 ;
reg mark2_1 , mark2_2 ,mark2_3 ,mark2_4 ,mark2_5 ,mark2_6 ,mark2_7 ,mark2_8 ,
    mark2_9 ,mark2_10 ,mark2_11 ,mark2_12 ,mark2_13 ,mark2_14 ,mark2_15 ;
reg CoN1,CoN2,CoN3,CoN4,CoN5,CoN6,CoN7;


reg [63:0]Base8;
reg [63:0]del8_1,del8_2,del8_3;
reg [31:0]Base4;
reg [31:0] del4_1,del4_2,del4_3,del4_4,del4_5,del4_6,del4_7;
reg [15:0]Base2;
reg [15:0] del2_1,del2_2,del2_3,del2_4,del2_5,del2_6,del2_7,del2_8,del2_9,del2_10,del2_11,del2_12,del2_13,del2_14,del2_15;


// Decoder 
always @(*) begin
    // Reset all CoN signals before setting the appropriate one
    CoN1 = 0;
    CoN2 = 0;
    CoN3 = 0;
    CoN4 = 0;
    CoN5 = 0;
    CoN6 = 0;
    CoN7 = 0;
    case (encoding)
        4'd2: CoN1 = 1;
        4'd4: CoN2 = 1;
        4'd3: CoN3 = 1;
        4'd6: CoN4 = 1;
        4'd5: CoN5 = 1;
        4'd7: CoN6 = 1;
		  4'd0: CoN7 = 1;
        default: begin
            // Do nothing if encoding doesn't match any case
        end
    endcase
end



// DECOMPRESSOR BLOCK

always @ (posedge clock) begin
			if(rst) begin
					o_data = 0;
					ready=0;
					Base8 = 0; //Base is the first value
					Base4 = 0;
					Base2 = 0;
					//FIXME: How will I know whether to add or subtact the deltas?
					mark2_1 = 0; mark2_2 = 0;mark2_3 = 0;mark2_4 = 0;mark2_5 = 0;mark2_6 = 0;mark2_7 = 0;mark2_8 = 0;
					mark2_9 = 0;mark2_10 = 0;mark2_11 = 0;mark2_12 = 0;mark2_13 = 0;mark2_14 = 0;mark2_15 = 0;
					mark4_1 = 0; mark4_2 = 0;mark4_3 = 0;mark4_4 = 0;mark4_5 = 0;mark4_6 = 0;mark4_7 = 0;
					mark8_1=0;mark8_2=0;mark8_3=0;
			end  

			else if(enable) begin
					ready = 0;
					Base8 = i_data[63:0]; //Base is the first value
					Base4 = i_data[31:0];
					Base2 = i_data[15:0];
				
					//BASE 8 DEL 1 BYTE
					if(CoN1==1)
					begin
							o_data[63:0] = i_data[63:0]; //Base8
							ready = 1;
							if (mark8_1 ==0)
									o_data[127:64] = Base8 - i_data[79:72];
							else 
									o_data[127:64] = i_data[79:72]- Base8 ;

							if (mark8_2 ==0)
									o_data[191:128] = Base8 - i_data[87:80];
							else 
									o_data[191:128] = i_data[87:80]- Base8 ;

							if (mark8_3 ==0)
									o_data[255:192] = Base8 - i_data[95:88];
							else 
									o_data[255:192] = i_data[95:88]- Base8 ;
					end 
					else if(CoN7 ==1) begin
							o_data = 255'd0;
							ready=1;
					end

					//BASE 8 DEL 2 BYTES
					else if(CoN2==1) begin
							ready=1;
							o_data[63:0] = i_data[63:0]; //Base8

							if (mark8_1 ==0)
									o_data[127:64] = Base8 - i_data[95:80];
							else 
									o_data[127:64] = i_data[95:80]- Base8 ;

							if (mark8_2 ==0)
									o_data[191:128] = Base8 - i_data[111:96];
							else 
									o_data[191:128] = i_data[111:96]- Base8 ;

							if (mark8_3 ==0)
									o_data[255:192] = Base8 - i_data[127:112];
							else 
									o_data[255:192] = i_data[127:112]- Base8 ;
					end

					//BASE 8 DEL 4 BYTES
					else if(CoN3==1) begin
							o_data[63:0] = i_data[63:0]; //Base8
							ready=1;
							if (mark8_1 ==0)
									o_data[127:64] = Base8 - i_data[127:96];
							else 
									o_data[127:64] = i_data[127:96]- Base8 ;

							if (mark8_2 ==0)
									o_data[191:128] = Base8 - i_data[159:128];
							else 
									o_data[191:128] = i_data[159:128]- Base8 ;

							if (mark8_3 ==0)
									o_data[255:192] = Base8 - i_data[191:160];
							else 
									o_data[255:192] = i_data[191:160]- Base8 ;
							end

					//BASE 4 DEL 1 BYTE
					else if(CoN4==1) begin
							ready=1;
							 //96 BITS
							o_data[31:0] = i_data[31:0]; //Base4

							if (mark4_1 == 0)
									o_data[63:32] = Base4 - i_data[47:40];
							else 
									o_data[63:32] = i_data[47:40]- Base4 ;

							if (mark4_2 == 0)
									o_data[95:64] = Base4 - i_data[55:48];
							else 
									o_data[95:64] = i_data[55:48]- Base4 ;

							if (mark4_3 == 0)
									o_data[127:96] = Base4 - i_data[63:56];
							else 
									o_data[127:96] = i_data[63:56]- Base4 ;

							if (mark4_4 == 0)
									o_data[159:128] = Base4 - i_data[71:64];
							else 
									o_data[159:128] = i_data[71:64]- Base4 ;

							if (mark4_5 == 0)
									o_data[191:160] = Base4 - i_data[79:72];
							else 
									o_data[191:160] = i_data[79:72]- Base4 ;

							if (mark4_6 == 0)
									o_data[223:192] = Base4 - i_data[87:80];
							else 
									o_data[223:192] = i_data[87:80]- Base4 ;

							if (mark4_7 == 0)
									o_data[255:224] = Base4 - i_data[95:88];
							else 
									o_data[255:224] = i_data[95:88]- Base4 ;
							end

					//BASE 4 DEL 2 BYTES
					else if(CoN5==1)
					begin
							ready=1;
							//160 BITS
							o_data[31:0] = i_data[31:0]; //Base4
							if (mark4_1 == 0)
									o_data[63:32] = Base4 - i_data[63:48];
							else 
									o_data[63:32] = i_data[63:48]- Base4 ;

							if (mark4_2 == 0)
									o_data[95:64] = Base4 - i_data[79:64];
							else 
									o_data[95:64] = i_data[79:64]- Base4 ;

							if (mark4_3 == 0)
									o_data[127:96] = Base4 - i_data[95:80];
							else 
									o_data[127:96] = i_data[95:80]- Base4 ;

							if (mark4_4 == 0)
									o_data[159:128] = Base4 - i_data[111:96];
							else 
									o_data[159:128] = i_data[111:96]- Base4 ;

							if (mark4_5 == 0)
									o_data[191:160] = Base4 - i_data[127:112];
							else 
									o_data[191:160] = i_data[127:112]- Base4 ;

							if (mark4_6 == 0)
									o_data[223:192] = Base4 - i_data[143:128];
							else 
									o_data[223:192] = i_data[143:128]- Base4 ;

							if (mark4_7 == 0)
									o_data[255:224] = Base4 - i_data[159:144];
							else 
									o_data[255:224] = i_data[159:144]- Base4 ;
					end


					//BASE 2 DEL 1 BYTE
					else if(CoN6==1) begin
							ready=1;
							 //144 BITS
							o_data[15:0] = i_data[15:0]; //Base2

							if (mark2_1 == 0)
									o_data[31:16] = Base2 - i_data[31:24];
							else 
									o_data[31:16] = i_data[31:24]- Base2 ;

							if (mark2_2 == 0)
									o_data[47:32] = Base2 - i_data[39:32];
							else 
									o_data[47:32] = i_data[39:32]- Base2 ;

							if (mark2_3 == 0)
									o_data[63:48] = Base2 - i_data[47:40];
							else 
									o_data[63:48] = i_data[47:40]- Base2 ;

							if (mark2_4 == 0)
									o_data[79:64] = Base2 - i_data[55:48];
							else 
									o_data[79:64] = i_data[55:48]- Base2 ;

							if (mark2_5 == 0)
									o_data[95:80] = Base2 - i_data[63:56];
							else 
									o_data[95:80] = i_data[63:56]- Base2 ;

							if (mark2_6 == 0)
									o_data[111:96] = Base2 - i_data[71:64];
							else 
									o_data[111:96] = i_data[71:64]- Base2 ;

							if (mark2_7 == 0)
									o_data[127:112] = Base2 - i_data[79:72];
							else 
									o_data[127:112] = i_data[79:72]- Base2 ;

							if (mark2_8 == 0)
									o_data[143:128] = Base2 - i_data[87:80];
							else 
									o_data[143:128] = i_data[87:80]- Base2 ;

							if (mark2_9 == 0)
									o_data[159:144] = Base2 - i_data[95:88];
							else 
									o_data[159:144] = i_data[95:88]- Base2 ;

							if (mark2_10 == 0)
									o_data[175:160] = Base2 - i_data[103:96];
							else 
									o_data[175:160] = i_data[103:96]- Base2 ;

							if (mark2_11 == 0)
									o_data[191:176] = Base2 - i_data[111:104];
							else 
									o_data[191:176] = i_data[111:104]- Base2 ;

							if (mark2_12 == 0)
									o_data[207:192] = Base2 - i_data[119:112];
							else 
									o_data[207:192] = i_data[119:112]- Base2 ;

							if (mark2_13 == 0)
									o_data[223:208] = Base2 - i_data[127:120];
							else 
									o_data[223:208] = i_data[127:120]- Base2 ;

							if (mark2_14 == 0)
									o_data[239:224] = Base2 - i_data[135:128];
							else 
									o_data[239:224] = i_data[135:128]- Base2 ;

							if (mark2_15 == 0)
									o_data[255:240] = Base2 - i_data[143:136];
							else 
									o_data[255:240] = i_data[143:136]- Base2 ;
					
					end

					//No Decompression feasible
					else begin
							ready=1;
							o_data = i_data;
					end

		end
end

endmodule

