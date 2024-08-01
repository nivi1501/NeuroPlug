`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:46 06/18/2024 
// Design Name: 
// Module Name:    lfsr 
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
module lfsr (
    input wire clk,
    input wire rst,
	 input enable,
    output wire [15:0] random_number
);

    reg [15:0] lfsr_reg;
    wire feedback;
    // Feedback value of the LFSR
    assign feedback = lfsr_reg[15] ^ lfsr_reg[13] ^ lfsr_reg[12] ^ lfsr_reg[10];
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_reg <= 16'h1; // Seed value
        end else if (enable) begin
            lfsr_reg <= {lfsr_reg[14:0], feedback};
        end
    end

    assign random_number = lfsr_reg;

endmodule
