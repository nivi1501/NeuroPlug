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

module router_cluster
	#(
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
	output [ADDR_BITWIDTH_GLB-1:0] val_0_addr_read_iact,
	output val_0_req_read_iact,
	//Source ports
	input [DATA_BITWIDTH-1:0] val_data_i_val_0_iact,
	input val_enable_i_val_0_iact,
	//Destination ports
	output [DATA_BITWIDTH-1:0] val_data_o_val_0_iact,
	output val_enable_o_val_0_iact,

	///////////////      ROUTER WGHT      ///////////////////////////////////
	output [ADDR_BITWIDTH_GLB-1:0] val_0_addr_read_wght,
	output val_0_req_read_wght,
	input [DATA_BITWIDTH-1:0] val_data_i_val_0_wght,
	input val_enable_i_val_0_wght,
	
	//Destination ports
	output [DATA_BITWIDTH-1:0] val_data_o_val_0_wght,
	output val_enable_o_val_0_wght,

	/////////////  IACT interports with other directions   ////////////


/////////////  ROuter interports ////////////
	output  [DATA_BITWIDTH-1:0] val_data_o_val_0_psum,
	output  val_enable_o_val_0_psum,
	input [DATA_BITWIDTH*X_dim-1:0] out_data_i_val_0_psum,
	input out_enable_i_val_0_psum,
	output  [DATA_BITWIDTH*X_dim-1:0] out_data_o_val_0_psum,
	output  [ADDR_BITWIDTH-1:0] val_addr_o_val_0_psum
		);
		
		
	// Routing input 	
	router_input
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
	router_iact_1
		(
			.clk(clk),
			.reset(reset),
			.val_req_read(val_0_req_read_iact),
			.val_addr_read(val_0_addr_read_iact),
			.val_data_i(val_data_i_val_0_iact),
			.val_enable_i(val_enable_i_val_0_iact),
			
			//Destination ports
			.val_data_o(val_data_o_val_0_iact),
			.val_enable_o(val_enable_o_val_0_iact)
		);
		
	router_wght
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
	router_wght_1 (
		.clk(clk),
		.reset(reset),
		.val_req_read(val_0_req_read_wght),
		.val_addr_read(val_0_addr_read_wght),
		//Source ports
		.val_data_i(val_data_i_val_0_wght),
		.val_enable_i(val_enable_i_val_0_wght),
		//Destination ports
		.val_data_o(val_data_o_val_0_wght),
		.val_enable_o(val_enable_o_val_0_wght)
		);

// Ruting the output
	assign	out_data_o_val_0_psum = {(DATA_BITWIDTH*X_dim){1'b0}};

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
	router_psum_1
	(
		.clk(clk),
		.reset(reset),
		.r_data_spad_psum(out_data_i_val_0_psum),
		.w_addr_glb_psum(val_addr_o_val_0_psum),
		.write_en_glb_psum(val_enable_o_val_0_psum),
		.w_data_glb_psum(val_data_o_val_0_psum),
		.write_psum_ctrl(out_enable_i_val_0_psum)
		);

	endmodule