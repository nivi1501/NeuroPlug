`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:45 07/27/2024 
// Design Name: 
// Module Name:    Decoder_Compressed_Size 
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
module Decoder_Compressed_Size(input [3:0] encoding, output reg [8:0] current_data_size, input clk);

always @(*) begin
    current_data_size = 0;
    case (encoding)
	 // These sizes are given in bits
        4'd2: current_data_size = 96;
        4'd4: current_data_size = 192;
        4'd3: current_data_size = 128;
        4'd6: current_data_size = 160;
        4'd5: current_data_size = 96;
        4'd7: current_data_size = 144;
		  4'd0: current_data_size = 1;
        default: begin
					current_data_size = 256;
            // means the data was not compressed
        end
    endcase
end

endmodule
