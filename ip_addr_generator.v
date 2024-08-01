`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:19:05 06/18/2024 
// Design Name: 
// Module Name:    ip_addr_generator 
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
module ip_addr_generator#(
    parameter DATA_WIDTH = 15, parameter ADDR_WIDTH = 31
)(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [DATA_WIDTH:0] H,   // Total height
    input wire [DATA_WIDTH:0] W,   // Total width
    input wire [DATA_WIDTH:0] C,   // Total channels
    input wire [DATA_WIDTH:0] Th,  // Tile height
    input wire [DATA_WIDTH:0] Tw,  // Tile width
    //input wire [DATA_WIDTH:0] Tc,  // Tile channels
    input wire [DATA_WIDTH:0] ho,  // Starting row of the tile
    input wire [DATA_WIDTH:0] wo,  // Starting column of the tile
    output reg [ADDR_WIDTH:0] address,
    output reg done
);

    reg [DATA_WIDTH:0] h, w, co, c;
       
    always @(posedge clk) begin
        if (rst) begin
            h <= ho;
            w <= wo;
            co <= 0;
            address <= 0;
            done <= 0;
        end else if (enable && !done) begin
            if (co < C) begin
                // Calculate the current address
                address <= ((h * W + w) * C + co);
                co <= co + 1'b1;
            end else begin
                co <= 0;
                if (w < wo + Tw - 1'b1) begin
                    w <= w + 1'b1;
                end else begin
                    w <= wo;
                    if (h < ho + Th - 1'b1) begin
                        h <= h + 1'b1;
                    end else begin
                        // All elements in the specified tile processed
                        done <= 1'b1;
                    end
                end
            end
        end
    end
endmodule

	 
