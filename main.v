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


/*

property result1;
	@(posedge clk) 
	(((plain_text == 128'hd3b930ac8979195ea7276b61dfe9d438) && start && accept && rstn && (cipher_key == 128'b0) ) |->  ##11 (cipher_text == 128'hc99261d5e548d92738ebba428b544bbb ));
endproperty

result_test1 : assert property (result1);

property result2;
	@(posedge clk) 
	(((plain_text == 128'hec90b696c95db75c6258bb52e7ce9c65) && accept && rstn && (cipher_key == 128'b0) ) |->  ##11 (cipher_text == 128'hbbd24a0555b6227de5140e4cf0f00d11 && done == 'b1));
endproperty

result_test2 : assert property (result2);

property result3;
	@(posedge clk) 
	(((plain_text == 128'h00000000000000000000000000000000) && accept && rstn && (cipher_key == 128'b0) ) |->  ##11 (cipher_text == 128'h66e94bd4ef8a2c3b884cfa59ca342b2e));
endproperty

result_test3 : assert property (result3);

property result4;
	@(posedge clk) 
	(((plain_text == 128'h95d70dc6855a9d46a74997ac72b94089) && accept && rstn && (cipher_key == 128'b0) ) |->  ##11 (cipher_text == 128'h59225d2494044b9f0e35f2b133dc3f81));
endproperty

result_test4 : assert property (result4);

property result5;
	@(posedge clk) 
	(((plain_text == 128'h871a089b5f66929d6e8f13291a1c6f66) && accept && rstn && (cipher_key == 128'b0) ) |->  ##11 (cipher_text == 128'h84f1f434bf769e48428a4b13176800c4));
endproperty

result_test5 : assert property (result5);
*/










endmodule
