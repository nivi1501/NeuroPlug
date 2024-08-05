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

	input val_0_req_read_psum,
	output [DATA_BITWIDTH-1:0] r_data_psum,

	
	input val_enable_i_val_0_wght,

	input val_enable_i_val_0_iact
	);

	wire [ADDR_BITWIDTH_GLB-1:0] val_0_addr_read_wght;
	wire [ADDR_BITWIDTH_GLB-1:0] val_0_addr_read_iact;
	wire [ADDR_BITWIDTH-1:0] val_addr_o_val_0_psum;
	wire val_0_req_read_wght;
	wire val_0_req_read_iact;
	wire [DATA_BITWIDTH-1:0] val_data_i_val_0_wght;
	wire [DATA_BITWIDTH-1:0] val_data_i_val_0_iact;
	wire  val_enable_o_val_0_wght;
	wire  val_enable_o_val_0_iact;
	wire [DATA_BITWIDTH-1:0] val_data_o_val_0_iact;
	wire [DATA_BITWIDTH-1:0] val_data_o_val_0_wght;
	wire [DATA_BITWIDTH-1:0] val_data_o_val_0_psum;
	wire val_enable_o_val_0_psum;
	wire [DATA_BITWIDTH*X_dim-1:0] out_data_i_val_0_psum;
	wire out_enable_i_val_0_psum;
	wire [DATA_BITWIDTH*X_dim-1:0] out_data_o_val_0_psum;

	assign compute_done = out_enable_i_val_0_psum;

	router_cluster
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

		.val_0_addr_read_iact(val_0_addr_read_iact),
		.val_0_req_read_iact(val_0_req_read_iact),
		.val_data_i_val_0_iact(val_data_i_val_0_iact),
		.val_enable_i_val_0_iact(val_enable_i_val_0_iact),
		.val_data_o_val_0_iact(val_data_o_val_0_iact),
		.val_enable_o_val_0_iact(val_enable_o_val_0_iact),

		.val_0_addr_read_wght(val_0_addr_read_wght),
		.val_0_req_read_wght(val_0_req_read_wght),
		.val_data_i_val_0_wght(val_data_i_val_0_wght),
		.val_enable_i_val_0_wght(val_enable_i_val_0_wght),
		.val_data_o_val_0_wght(val_data_o_val_0_wght),
		.val_enable_o_val_0_wght(val_enable_o_val_0_wght),

		.val_data_o_val_0_psum(val_data_o_val_0_psum),
		.val_enable_o_val_0_psum(val_enable_o_val_0_psum),
		.out_data_i_val_0_psum(out_data_i_val_0_psum),
		.out_enable_i_val_0_psum(out_enable_i_val_0_psum),
		.out_data_o_val_0_psum(out_data_o_val_0_psum),
		.val_addr_o_val_0_psum(val_addr_o_val_0_psum)

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
				.read_req_iact(val_0_req_read_iact),
				.read_req_psum(val_0_req_read_psum), 
				.read_req_wght(val_0_req_read_wght),
				.r_data_iact(val_data_i_val_0_iact),
			    .r_data_psum(r_data_psum), 
				.r_data_wght(val_data_i_val_0_wght),
				.r_addr_iact(val_0_addr_read_iact),
			    .r_addr_psum(r_addr_psum), 
				.r_addr_wght(val_0_addr_read_wght),
				.w_addr_iact(w_addr_iact), 
			    .w_addr_psum(val_addr_o_val_0_psum),
				.w_addr_wght(w_addr_wght),
 
			    .w_data_iact(w_data_iact), 
				.w_data_psum(val_data_o_val_0_psum),
				.w_data_wght(w_data_wght), 
				.write_en_iact(write_en_iact), 
				.write_en_psum(val_enable_o_val_0_psum),
				.write_en_wght(write_en_wght) 			
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
	pe_cluster
    			(
					.clk(clk),
				   .reset(reset),					
				   .act_in(val_data_o_val_0_iact),
				   .filt_in(val_data_o_val_0_wght),
				   .pe_before(out_data_o_val_0_psum),
					.load_en_wght(val_enable_o_val_0_wght),
					.load_en_act(val_enable_o_val_0_iact),					
					.start(start),
               .pe_out(out_data_i_val_0_psum),
					.compute_done(out_enable_i_val_0_psum),
					.load_done(load_done)
    			);
	

    endmodule