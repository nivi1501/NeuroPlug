`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:39:33 07/28/2024 
// Design Name: 
// Module Name:    FIFO_Buffer 
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
module FIFO_Buffer (
    input clk,
    input rst,
    input [255:0] i_data,         // Input data
    input [8:0] i_data_size,      // Input data size in bits
    input write_en,               // Write enable signal
    input read_en,                // Read enable signal
    output reg [127:0] o_data,    // Output data
    output reg full,              // Full flag
    output reg empty              // Empty flag
);

parameter FIFO_SIZE = 512;       // FIFO buffer size in bits
parameter WORD_SIZE = 128;       // Word size to be read in bits

reg [FIFO_SIZE-1:0] buffer;      // FIFO buffer
reg [8:0] data_count;            // Number of bits currently in the buffer

always @(posedge clk or posedge rst) begin
    if (rst) begin
        buffer <= 0;
        data_count <= 0;
        full <= 0;
        empty <= 1;
        o_data <= 0;
    end else begin
        // Write operation
        if (write_en && (data_count + i_data_size <= FIFO_SIZE)) begin
            // Shift the buffer to the left by i_data_size bits
            buffer <= (buffer << i_data_size) | (i_data >> (256 - i_data_size));
            data_count <= data_count + i_data_size;
            full <= (data_count + i_data_size >= FIFO_SIZE);
            empty <= 0;
        end

        // Read operation
        if (read_en && (data_count >= WORD_SIZE)) begin
            o_data <= buffer[data_count-1 -: WORD_SIZE];  // Read the most significant valid WORD_SIZE bits
            buffer <= buffer << WORD_SIZE;  // Shift the buffer to the left by WORD_SIZE bits
            data_count <= data_count - WORD_SIZE;
            full <= 0;
            empty <= (data_count - WORD_SIZE == 0);
        end
    end
end

endmodule
