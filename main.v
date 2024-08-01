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

// Top module for connecting the AES controller with N AES cores.
module encryption  (input   clk,
    input   start,
    input   rstn,
    input   [127:0] plain_text,
    input   [127:0] cipher_key,

    // to testbench
    output  done,
    output  [9:0] completed_round,
    output  [127:0] cipher_text
);

	wire accept;
	wire [3:0] rndNo;
	wire en;
	wire enbMC;

	AEScntx aes_cnt (
    clk,
    start,
    rstn,
    accept,
    rndNo,
    en,
    enbMC,
    done,
    completed_round
	);

	AESCore aes_core (
            clk,
            rstn,
            plain_text,
            cipher_key,
            accept,
            rndNo,
            en,
            enbMC,
            cipher_text
        );

endmodule
