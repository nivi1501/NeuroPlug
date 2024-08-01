`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:43:05 06/17/2024 
// Design Name: 
// Module Name:    SFC_main 
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
//////////////////////////////////////////////////////////////////////////////////module main (
// Module to generate addresses to write data to DRAM. 
// Used by the user, during training operation
// Used by the input provider as well

module SFC_main#(parameter DATA_WIDTH = 15, parameter ADDR_WIDTH = 31) (
    input clk,
    input rst,
    output wire [ADDR_WIDTH:0] inp_addr,
    output wire [ADDR_WIDTH:0] filt_addr,
	 output done1,
	 output done2,
	 input inp_SFC_enable,inp_addr_enable,filt_addr_enable,SFC_filt_enable,
	 input [DATA_WIDTH:0]  C, R, S, Tk, Tc, Th, W, Tw, H
);

   // wire done_inp, done_filt, done1, done2;
    wire [DATA_WIDTH:0] m;
    wire [DATA_WIDTH:0] n;
	 assign m = H/Th;
	 assign n = W/Tw;
    //wire inc_enable;
    //wire increment;
    wire [DATA_WIDTH:0] x_filt, y_filt, z_filt, x_inp, y_inp;
	 
	 SFC_input ip (
        .clk(clk),
        .rst(rst),
        .m(m),
        .n(n),
        .x(x_inp),
        .y(y_inp),
        .inc_enable(inp_SFC_enable)
    );

	 //assign inc_enable = 1'b1;
	 //assign enable = 1'b1;
	 
	 ip_addr_generator inp(
        .clk(clk),
        .rst(rst),
        .enable(inp_addr_enable),
		  	.H(H),   // Total height
			.W(W),   // Total width
			.C(C),   // Total channels
			.Th(Th),  // Tile height
			.Tw(Tw),  // Tile width
//			.Tc(Tc),  // Tile channels
			.ho(x_inp),  // Starting row of the tile
			.wo(y_inp),  // Starting column of the tile
			.address(inp_addr),
			.done(done2)
		);

	 
    // Instantiate SFC_filter
    wire done3;
    SFC_filter filtr (
        .clk(clk),
        .rst(rst),
        .W(W),
        .H(H),
//      .K(K),
        .x(x_filt),
        .y(y_filt),
  //    .z(z_filt),
        .done(done3),
		  .enable(SFC_filt_enable)
    );

     // Instantiate the address generator
    filt_addr_generator filt_addr_gen (
        .clk(clk),
        .rst(rst),
        .enable(filt_addr_enable),
//      .K(K),
        .C(C),
        .R(R),
        .S(S),
        .Tk(Tk),
        .Tc(Tc),
        .ko(x_filt),
        .co(y_filt),
        .address(filt_addr),
        .done(done1)
    );


endmodule 

