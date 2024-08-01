`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:29 07/24/2024 
// Design Name: 
// Module Name:    PE_cluster_new 
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
module PE_cluster_new #(parameter DATA_BITWIDTH = 16,
					parameter ADDR_BITWIDTH = 9,
					
					parameter X_dim = 5,
					parameter Y_dim = 3,
   
					parameter kernel_size = 3,
					parameter act_size = 5,
					
					parameter W_READ_ADDR = 0,  
					parameter A_READ_ADDR = 100,
					
					parameter W_LOAD_ADDR = 0,  
					parameter A_LOAD_ADDR = 100,
					
					parameter PSUM_ADDR = 500
					)
					( 
					input clk, reset,
					input [DATA_BITWIDTH-1:0] act_in,
					input [DATA_BITWIDTH-1:0] filt_in,
					input [DATA_BITWIDTH*X_dim-1:0] pe_before,
					input load_en_wght, load_en_act,
					input start,
					output reg [DATA_BITWIDTH*X_dim-1:0] pe_out,
					output  compute_done,
					output  load_done
					);
		
		wire [DATA_BITWIDTH-1:0] psum_out[0 : X_dim*Y_dim-1];
		
		wire cluster_done[0 : X_dim*Y_dim-1];
		wire cluster_load_done[0 : X_dim*Y_dim-1];
		
		generate
		genvar i;
		for(i=0; i<X_dim; i=i+1) 
			begin:gen_X
				genvar j;
				for(j=0; j<Y_dim; j=j+1)
					begin:gen_Y
					
						PE_new #( 	.DATA_BITWIDTH(DATA_BITWIDTH),
								.ADDR_BITWIDTH(ADDR_BITWIDTH),
								.kernel_size(kernel_size),
								.act_size(act_size),
								.W_READ_ADDR(W_READ_ADDR + kernel_size*j),  
								.A_READ_ADDR(A_READ_ADDR + act_size*j + i),
								.W_LOAD_ADDR(W_LOAD_ADDR),  
								.A_LOAD_ADDR(A_LOAD_ADDR),
								.PSUM_ADDR(PSUM_ADDR)
							)
						pe (	
								.clk(clk),
								.reset(reset),
								.act_in(act_in),
								.filt_in(filt_in),
								.load_en_wght(load_en_wght),
								.load_en_act(load_en_act),
								.start(start),
								.pe_out(psum_out[i*Y_dim+j]),
								.compute_done(cluster_done[i*Y_dim+j]),
								.load_done(cluster_load_done[i*Y_dim+j])
							);
					
					end
			end
		endgenerate
		

		
		// Add partial sums and register at pe_out
		always@(posedge clk) begin
			if(reset)
			begin
					pe_out <= 0;
			end 
			else
			begin
				pe_out[DATA_BITWIDTH-1:0] <= pe_before[DATA_BITWIDTH-1:0]+psum_out[0]+psum_out[1]+psum_out[2];
				pe_out[2*DATA_BITWIDTH-1:DATA_BITWIDTH] <= pe_before[2*DATA_BITWIDTH-1 -:DATA_BITWIDTH]+psum_out[1*Y_dim+0]+psum_out[1*Y_dim+1]+psum_out[1*Y_dim+2];
				pe_out[3*DATA_BITWIDTH-1:2*DATA_BITWIDTH] <= pe_before[3*DATA_BITWIDTH-1 -:DATA_BITWIDTH]+psum_out[2*Y_dim+0]+psum_out[2*Y_dim+1]+psum_out[2*Y_dim+2];
			end
			
		end
		
		
		assign compute_done = cluster_done[0];
		assign load_done = cluster_load_done[0];
		
		  
endmodule
				   
				   