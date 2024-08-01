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

// AES controller. Used for controlling the AES core.
module AEScntx(
    input   clk,
    input   start,
    input   rstn,

    output  accept,
    output reg [3:0] rndNo,
    output  enbSB,
    output  enbMC,
    output reg done,
    output  [9:0] completed_round
);

always @ (posedge clk)
begin
    if (~rstn)
    begin
        // Clear all registers
        rndNo <= 4'b0;
        done <= 1'b0;
    end
    else if (start)
    begin
        // Update state of implicit FSM (11 states in total)
        rndNo <= (rndNo < 4'd10) ? (rndNo + 1'b1) : 4'b0;
        done <= (rndNo == 4'd10);
    end
end

assign enbSB = (rndNo >= 4'd1) && (rndNo <= 4'd10);
assign enbMC = (rndNo >= 4'd1) && (rndNo <= 4'd9);
assign accept = (rndNo == 0);   // Notify core to accept new inputs at round 0
assign completed_round = 10'b1000000000 >> (4'd10 - rndNo);

endmodule