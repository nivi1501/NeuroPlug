`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:04:05 06/18/2024 
// Design Name: 
// Module Name:    top_noise 
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
module noise_main(
    input wire clk,
    input wire rst,
    input wire enable, // Enable signal to generate noise
    output wire [15:0] gaussian_number,
	 output data_valid  // You can read the noise value
);

    wire [15:0] uniform_random;
    wire [15:0] variance;

    // Instantiate LFSR for uniform random number to determine variance
    lfsr lfsr_variance (
        .clk(clk),
        .rst(rst),
		  .enable(enable),
        .random_number(uniform_random)
    );
    
	 // Use uniform random number as variance
    assign variance = uniform_random; 

    wire [15:0] z0;
	 
    gng noise_generator 
    (
        .clk(clk),
        .rstn(~rst),
		  .ce(enable),
        .valid_out(data_valid),
        .data_out(z0)
    );
    
	 wire [31:0] gaussian_number_temp;
    assign gaussian_number_temp = (z0 * variance) >> 16; // Scale by variance: E(aX) = aE(X)
    assign gaussian_number = gaussian_number_temp[15:0];
endmodule
