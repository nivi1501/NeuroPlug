`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:49 06/18/2024 
// Design Name: 
// Module Name:    filt_addr_generator 
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
module filt_addr_generator #(
    parameter DATA_WIDTH = 16, parameter ADDR_WIDTH = 31
) (
    input wire clk,
    input wire rst,
    input wire enable,
    //input wire [DATA_WIDTH-1:0] K,   // Total output feature maps
    input wire [DATA_WIDTH-1:0] C,   // Total input feature maps
    input wire [DATA_WIDTH-1:0] R,   // Total rows in a filter
    input wire [DATA_WIDTH-1:0] S,   // Total columns in a filter
    input wire [DATA_WIDTH-1:0] Tk,  // Tile output feature maps
    input wire [DATA_WIDTH-1:0] Tc,  // Tile input feature maps
    input wire [DATA_WIDTH-1:0] ko,  // Starting output feature map of the tile
    input wire [DATA_WIDTH-1:0] co,  // Starting input feature map of the tile
    output reg [ADDR_WIDTH:0] address,
    output reg done
);


    reg [DATA_WIDTH-1:0] k, c, r, s;

    always @(posedge clk) begin
        if (rst) begin
            k <= ko;
            c <= co;
            r <= 0;
            s <= 0;
            address <= 0;
            done <= 0;
        end else if (enable && !done) begin
            if (k < ko + Tk) begin
                if (c < co + Tc) begin
                    if (r < R) begin
                        if (s < S) begin
                            // Calculate the current address
                            address <= (((k * C + c) * R + r) * S + s);
                            s <= s + 1'b1;
                        end else begin
                            s <= 0;
                            r <= r + 1'b1;
                        end
                    end else begin
                        r <= 0;
                        c <= c + 1'b1;
                    end
                end else begin
                    c <= co;
                    k <= k + 1'b1;
                end
            end else begin
                // All elements in the specified tile processed
                done <= 1'b1;
            end
        end
    end
endmodule
