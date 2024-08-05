`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:00 07/27/2024 
// Design Name: 
// Module Name:    GBDRAM 
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
module GBDRAM#(parameter binSize=400)
(i_data, key, rst, clk, en, binWrite, en_noise, o_data, hold, 	w_addr );
// i_data comes from the ofmap GB, collected over time to get 256 bits 
// en shows that enable the compression process
// o_data needs to be written to the GB

		input [255:0] i_data;
		output [127:0] o_data;
		input  [9:0] w_addr; //address for writing the data in compressbuffer
		input [127:0] key;
		output hold;
		input clk,rst,en,en_noise;
		output binWrite;
		wire enc_done, noise_ready;
		reg [15:0] noise;
		wire [15:0] noise_val;
      reg [255:0] i_data_cte;
		// Perform CTE
		CTE CTEEngine(i_data_cte,key,rst,clk,o_data,en,enc_done,hold);
		// o_data (compressed and encrypted data is written to the global buffer)

		// Noise generation module
		noise_main heterosk(
			// module top_module (
			 .clk(clk),
			 .rst(rst),
			 .enable(en_noise), // Enable signal to generate noise
			 .gaussian_number(noise_val),
			 .data_valid(noise_ready)  // You can read the noise value
		);


		// Store in a buffer
		wire en_buffer_write = enc_done||noise_ready;

		reg [15:0] w_data;
		/*CompressBinBuffer CompressBinBuffer2
		   ( 
				.clk(clk),
			   .reset(rst),
			   .read_req(),
			   .write_en(en_buffer_write),
			   .r_addr(),
			   .w_addr(w_addr),
			   .w_data(w_data),
			   .r_data()
		);*/

		// Whenever data is encrypted and send to be written to GB, increment the count of
		// the transferred data
		reg [10:0] dataReadFromGB;
		always@(posedge clk) begin
				if (rst|| (dataReadFromGB >= binSize)) begin
						dataReadFromGB = 0;
				end
				else if(enc_done) begin
						// 128 bits are encrypted at a time
						dataReadFromGB = dataReadFromGB+128;
				end
				else if (en_noise) begin
				      dataReadFromGB = dataReadFromGB+noise;
				end
		end

		// Update the noise register only when askd by the user to add noise.
		always@(posedge clk) begin
				if(rst || en_noise==0) begin
						noise <= 0;
				end
				else if (en_noise==1) begin
				      //w_data <= 129; // For testing dummy values given
						if (noise_ready)
							 noise <= noise_val;
						else
							 noise <= 0;
						end	 
				else if (enc_done) begin
   						 w_data <= o_data;
 							 noise <= 0;
				end
		end
		
		
	   // Update the noise register only when askd by the user to add noise.
		always@(posedge clk) begin
				if(rst) begin
						i_data_cte <= 0;
				end
				// if compression enable for dummy data
				else if (en_noise==1 && en) begin
						if (noise_ready)
							 i_data_cte <= 129; // for testing dummy data 
						else
							 i_data_cte <= 0;
						end	 
				// compression enable for 		
				else if (en && en_noise==0) begin
				      	 i_data_cte <= i_data;
				end
		end
		

		// binWrite to DRAM is active only when all the content is written
		assign binWrite = (dataReadFromGB >= binSize)? 1:0;

endmodule

