`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:29 07/24/2024 
// Design Name: 
// Module Name:    router_cluster_wpsum 
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

module router_cluster_wpsum
	#(
		// parameter DATA_BITWIDTH = 16,
		parameter DATA_BITWIDTH = 16,
		parameter ADDR_BITWIDTH = 10,
		parameter ADDR_BITWIDTH_GLB = 10,
		parameter ADDR_BITWIDTH_SPAD = 9,
		parameter A_READ_ADDR = 100,
		parameter A_LOAD_ADDR = 0,
		parameter X_dim = 5,
        parameter Y_dim = 3,
        parameter kernel_size = 3,
        parameter act_size = 5,
		
		parameter W_READ_ADDR = 0, 
        
        parameter W_LOAD_ADDR = 0,
        parameter PSUM_READ_ADDR = 0,
        parameter PSUM_LOAD_ADDR = 0
        )
	(
	input clk,
	input reset,

	///////////////      ROUTER IACT      ///////////////////////////////////
	output [ADDR_BITWIDTH_GLB-1:0] west_0_addr_read_iact,
	output west_0_req_read_iact,
	//Source ports
	input [DATA_BITWIDTH-1:0] west_data_i_west_0_iact,
	input west_enable_i_west_0_iact,
	//Destination ports
	output [DATA_BITWIDTH-1:0] west_data_o_west_0_iact,
	output west_enable_o_west_0_iact,

	///////////////      ROUTER WGHT      ///////////////////////////////////
	output [ADDR_BITWIDTH_GLB-1:0] west_0_addr_read_wght,
	output west_0_req_read_wght,
	input [DATA_BITWIDTH-1:0] west_data_i_west_0_wght,
	input west_enable_i_west_0_wght,
	
	//Destination ports
	output [DATA_BITWIDTH-1:0] west_data_o_west_0_wght,
	output west_enable_o_west_0_wght,

	/////////////  IACT interports with other directions   ////////////


/////////////  ROuter interports ////////////
	output  [DATA_BITWIDTH-1:0] west_data_o_west_0_psum,
	output  west_enable_o_west_0_psum,
	input [DATA_BITWIDTH*X_dim-1:0] east_data_i_west_0_psum,
	input east_enable_i_west_0_psum,
	output  [DATA_BITWIDTH*X_dim-1:0] east_data_o_west_0_psum,
	output  [ADDR_BITWIDTH-1:0] west_addr_o_west_0_psum
		);
		
		
		
	// Routing input 	
	router_west_iact
		#(
			.DATA_BITWIDTH(DATA_BITWIDTH),
			.ADDR_BITWIDTH_GLB(ADDR_BITWIDTH_GLB),
			.ADDR_BITWIDTH_SPAD(ADDR_BITWIDTH_SPAD),
			
			.X_dim(X_dim),
		    .Y_dim(Y_dim),
		    .kernel_size(kernel_size),
		    .act_size(act_size),
			
			.A_READ_ADDR(A_READ_ADDR), 
		    .A_LOAD_ADDR(A_LOAD_ADDR)
		)
	router_iact
		(
			.clk(clk),
			.reset(reset),
			.west_req_read(west_0_req_read_iact),
			.west_addr_read(west_0_addr_read_iact),
			.west_data_i(west_data_i_west_0_iact),
			.west_enable_i(west_enable_i_west_0_iact),
			
			//Destination ports
			.west_data_o(west_data_o_west_0_iact),
			.west_enable_o(west_enable_o_west_0_iact)
		);
		
	router_west_wght
		#(
			.DATA_BITWIDTH(DATA_BITWIDTH),
			.ADDR_BITWIDTH_GLB(ADDR_BITWIDTH_GLB),
			.ADDR_BITWIDTH_SPAD(ADDR_BITWIDTH_SPAD),
			
			.X_dim(X_dim),
		    .Y_dim(Y_dim),
		    .kernel_size(kernel_size),
		    .act_size(act_size),
			
			.W_READ_ADDR(W_READ_ADDR), 
		    .W_LOAD_ADDR(W_LOAD_ADDR)
		)
	router_wght(
		.clk(clk),
		.reset(reset),
		.west_req_read(west_0_req_read_wght),
		.west_addr_read(west_0_addr_read_wght),
		//Source ports
		.west_data_i(west_data_i_west_0_wght),
		.west_enable_i(west_enable_i_west_0_wght),
		//Destination ports
		.west_data_o(west_data_o_west_0_wght),
		.west_enable_o(west_enable_o_west_0_wght)
		);

// Ruting the output
	assign	east_data_o_west_0_psum = {(DATA_BITWIDTH*X_dim){1'b0}};

	router_psum
	#(
		.DATA_BITWIDTH(DATA_BITWIDTH),
		.ADDR_BITWIDTH_GLB(ADDR_BITWIDTH_GLB),
		.ADDR_BITWIDTH_SPAD(ADDR_BITWIDTH_SPAD),
		.X_dim(X_dim),
	    .Y_dim(Y_dim),
	    .kernel_size(kernel_size),
	    .act_size(act_size),
		.PSUM_READ_ADDR(PSUM_READ_ADDR),
		.PSUM_LOAD_ADDR(PSUM_LOAD_ADDR)
		)
	router_psum
	(
		.clk(clk),
		.reset(reset),
		.r_data_spad_psum(east_data_i_west_0_psum),
		.w_addr_glb_psum(west_addr_o_west_0_psum),
		.write_en_glb_psum(west_enable_o_west_0_psum),
		.w_data_glb_psum(west_data_o_west_0_psum),
		.write_psum_ctrl(east_enable_i_west_0_psum)
		);

	endmodule