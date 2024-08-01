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

module main_local
#(
	parameter ADDR_BITWIDTH_GLB = 10,
	parameter ADDR_BITWIDTH_SPAD = 9,
	parameter DATA_BITWIDTH = 16,
	parameter ADDR_BITWIDTH = 10,
   parameter A_READ_ADDR = 100,
	parameter A_LOAD_ADDR = 100,
	parameter W_READ_ADDR = 0,
	parameter W_LOAD_ADDR = 0,
	parameter PSUM_READ_ADDR = 0,
	parameter PSUM_LOAD_ADDR = 0,
	parameter PSUM_ADDR= 500,
   parameter X_dim = 3,
   parameter Y_dim = 3,
   parameter kernel_size = 3,
   parameter act_size = 5,
   parameter NUM_GLB_IACT = 1,
   parameter NUM_GLB_PSUM = 1,
   parameter NUM_GLB_WGHT = 1
	)
(
	
	// PE interports
	input clk, reset,
	input start,

	output compute_done,
	output load_done,
	
	// GLB Interports
	input write_en_iact,
	input write_en_wght,
	
	input [DATA_BITWIDTH-1:0] w_data_iact,
	input [ADDR_BITWIDTH-1:0] w_addr_iact,
	
	input [DATA_BITWIDTH-1:0] w_data_wght,
	input [ADDR_BITWIDTH-1:0] w_addr_wght,
	input [ADDR_BITWIDTH-1:0] r_addr_psum,
	input [ADDR_BITWIDTH-1:0] r_addr_psum_inter,
	input west_0_req_read_psum_inter,
	input west_0_req_read_psum,
	output [DATA_BITWIDTH-1:0] r_data_psum,

	
	//ROUTER Interports

	input west_enable_i_west_0_wght,

	input west_enable_i_west_0_iact


	);

	wire [ADDR_BITWIDTH_GLB-1:0] west_0_addr_read_wght;

	wire [ADDR_BITWIDTH_GLB-1:0] west_0_addr_read_iact;

	wire [ADDR_BITWIDTH-1:0] west_addr_o_west_0_psum;

	wire west_0_req_read_wght;

	wire west_0_req_read_iact;

	wire [DATA_BITWIDTH-1:0] west_data_i_west_0_wght;

	wire [DATA_BITWIDTH-1:0] west_data_i_west_0_iact;

	wire  west_enable_o_west_0_wght;

	wire  west_enable_o_west_0_iact;

	wire [DATA_BITWIDTH-1:0] west_data_o_west_0_iact;

	wire [DATA_BITWIDTH-1:0] west_data_o_west_0_wght;
	

	wire [DATA_BITWIDTH-1:0] west_data_o_west_0_psum;
	wire west_enable_o_west_0_psum;
	wire [DATA_BITWIDTH*X_dim-1:0] east_data_i_west_0_psum;
	wire east_enable_i_west_0_psum;
	wire [DATA_BITWIDTH*X_dim-1:0] east_data_o_west_0_psum;

	assign compute_done = east_enable_i_west_0_psum;

	router_cluster_wpsum
	#(
		.DATA_BITWIDTH(DATA_BITWIDTH),
		.ADDR_BITWIDTH(ADDR_BITWIDTH),
		.ADDR_BITWIDTH_GLB(ADDR_BITWIDTH_GLB),
		.ADDR_BITWIDTH_SPAD(ADDR_BITWIDTH_SPAD),
		.A_READ_ADDR(A_READ_ADDR),
		.A_LOAD_ADDR(A_LOAD_ADDR),
		.X_dim(X_dim),
	   .Y_dim(Y_dim),
	   .kernel_size(kernel_size),
	   .act_size(act_size),
		.PSUM_READ_ADDR(PSUM_READ_ADDR),
		.PSUM_LOAD_ADDR(PSUM_LOAD_ADDR),
		.W_READ_ADDR(W_READ_ADDR), 
	   .W_LOAD_ADDR(W_LOAD_ADDR)
		)
	router_cluster
	(
		.clk(clk),
		.reset(reset),

		.west_0_addr_read_iact(west_0_addr_read_iact),
		.west_0_req_read_iact(west_0_req_read_iact),
		.west_data_i_west_0_iact(west_data_i_west_0_iact),
		.west_enable_i_west_0_iact(west_enable_i_west_0_iact),
		.west_data_o_west_0_iact(west_data_o_west_0_iact),
		.west_enable_o_west_0_iact(west_enable_o_west_0_iact),

		.west_0_addr_read_wght(west_0_addr_read_wght),
		.west_0_req_read_wght(west_0_req_read_wght),
		.west_data_i_west_0_wght(west_data_i_west_0_wght),
		.west_enable_i_west_0_wght(west_enable_i_west_0_wght),
		.west_data_o_west_0_wght(west_data_o_west_0_wght),
		.west_enable_o_west_0_wght(west_enable_o_west_0_wght),

		.west_data_o_west_0_psum(west_data_o_west_0_psum),
		.west_enable_o_west_0_psum(west_enable_o_west_0_psum),
		.east_data_i_west_0_psum(east_data_i_west_0_psum),
		.east_enable_i_west_0_psum(east_enable_i_west_0_psum),
		.east_data_o_west_0_psum(east_data_o_west_0_psum),
		.west_addr_o_west_0_psum(west_addr_o_west_0_psum)

		);
		
	

	GB_Cluster 
			#(	.DATA_BITWIDTH(DATA_BITWIDTH),
				.ADDR_BITWIDTH(ADDR_BITWIDTH),
				.X_dim(X_dim),
				.Y_dim(Y_dim),
				.NUM_GLB_IACT(NUM_GLB_IACT),
				.NUM_GLB_PSUM(NUM_GLB_PSUM),
				.NUM_GLB_WGHT(NUM_GLB_WGHT)
			)
	GB_cluster
			(
				.clk(clk),   //TestBench/Controller
				.reset(reset),  //TestBench/Controller
				
				//Signals for reading from GLB
				.read_req_iact(west_0_req_read_iact),
				.read_req_psum(west_0_req_read_psum), //Read by testbench/controller
				.read_req_wght(west_0_req_read_wght),
				.read_req_psum_inter(west_0_req_read_psum_inter),

			    .r_data_iact(west_data_i_west_0_iact),
			    .r_data_psum(r_data_psum), //Read by testbench/controller
				.r_data_wght(west_data_i_west_0_wght),

				.r_addr_iact(west_0_addr_read_iact),
			    .r_addr_psum(r_addr_psum), //testbench for reading final psums
				.r_addr_wght(west_0_addr_read_wght),
				.r_addr_psum_inter(r_addr_psum_inter),
				
				//Signals for writing to GLB
			    .w_addr_iact(w_addr_iact), //testbench for writing
			    .w_addr_psum(west_addr_o_west_0_psum),
				.w_addr_wght(w_addr_wght), //testbench for writing
 
			    .w_data_iact(w_data_iact), //testbench for writing
				.w_data_psum(west_data_o_west_0_psum),
				.w_data_wght(w_data_wght), //testbench for writing

				.write_en_iact(write_en_iact), //testbench for writing
				.write_en_psum(west_enable_o_west_0_psum),
				.write_en_wght(write_en_wght) //testbench for writing
			
			);
	
	
	/////// INST PE CLUSTER
		
	PE_cluster_new #(
					.DATA_BITWIDTH(DATA_BITWIDTH),
					.ADDR_BITWIDTH(ADDR_BITWIDTH),
					
					.kernel_size(kernel_size),
					.act_size(act_size),
					
					.X_dim(X_dim),
					.Y_dim(Y_dim),
					.W_READ_ADDR(W_READ_ADDR),
					.W_LOAD_ADDR(W_LOAD_ADDR),
					.A_READ_ADDR(A_READ_ADDR),
					.A_LOAD_ADDR(A_LOAD_ADDR),
					.PSUM_ADDR(PSUM_ADDR)

    			)
	pe_cluster_west_0
    			(
					.clk(clk),
				   .reset(reset),
					
				   .act_in(west_data_o_west_0_iact),
				   .filt_in(west_data_o_west_0_wght),
				   .pe_before(east_data_o_west_0_psum),

					.load_en_wght(west_enable_o_west_0_wght),
					.load_en_act(west_enable_o_west_0_iact),
					
					.start(start),
               .pe_out(east_data_i_west_0_psum),
					.compute_done(east_enable_i_west_0_psum),
					.load_done(load_done)
    			);
	

    endmodule