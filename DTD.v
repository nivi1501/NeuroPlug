`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:04:54 07/27/2024 
// Design Name: 
// Module Name:    DTD 
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
module DTD#(parameter binSize=400) 
(clk,rst,i_data,o_data,key ,encoding, binRead,en,data_ready   );
input clk,rst;
input [255:0] i_data;
input [127:0] key;
input en;
output binRead;
output [255:0] o_data;
wire [255:0] decompressed_data;
wire decom_done;
input [3:0] encoding; //from DRAM
output data_ready;

// Decompress the input data of 256 bits
Decompressor decompress_engine( .i_data(i_data),  .o_data(decompressed_data), .enable(en),
 .ready(decom_done), .clock(clk), .rst(rst) ,.encoding(encoding)
);

// Encrypt all 256 bits using two parallel AES engines
AES_Decrypt decry_engine1(.datain(decompressed_data[127:0]),.key(key),.state(o_data[127:0]),
.reset(rst),.clk(clk),.start(data_ready),.en(decom_done));


AES_Decrypt decry_engine2(.datain(decompressed_data[255:128]),.key(key),.state(o_data[255:128]),
.reset(rst),.clk(clk),.start(),.en(decom_done)
);

wire [8:0] current_data_size;
Decoder_Compressed_Size D1(encoding, current_data_size, clk);

// Keep on tracking the amount of data read from the DRAM
reg [8:0] dataReadFromDRAM;
always@(posedge clk) begin
		if (rst || (dataReadFromDRAM >= binSize)) begin
				dataReadFromDRAM <=0;
		end
		else if(en) begin
				dataReadFromDRAM <= dataReadFromDRAM + current_data_size ;
      end
end

// Make BinRead Signal High when data is completely read from the DRAM
assign binRead = (dataReadFromDRAM >= binSize)? 1'b1:1'b0;

endmodule
