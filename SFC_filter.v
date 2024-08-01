`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:57:39 06/17/2024 
// Design Name: 
// Module Name:    SFC_filter 
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
module SFC_filter #(
    parameter DATA_WIDTH = 15, parameter ADDR_WIDTH=31)
(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH:0] W, // max value of x
    input wire [DATA_WIDTH:0] H, // max value of y
   // input wire [DATA_WIDTH:0] K, // max value of z
    output reg [DATA_WIDTH:0] x,
    output reg [DATA_WIDTH:0] y,
   // output reg [DATA_WIDTH:0] z,
    output reg done,
	 input enable
);

    // State machine states
    parameter IDLE = 2'b00;
    parameter COUNT= 2'b10;
    parameter DONE= 2'b11;

    reg[1:0] state, next_state;

    // Counters
    reg [DATA_WIDTH:0] x_counter;
    reg [DATA_WIDTH:0] y_counter;
    //reg [DATA_WIDTH:0] z_counter;

    // State machine
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            x_counter <= 0;
            y_counter <= 0;
    //        z_counter <= 0;
            x <= 0;
            y <= 0;
    //        z <= 0;
            done <= 0;
        end else begin
		    if(enable) begin
            state <= next_state;
            case (state)
                IDLE: begin
                    x_counter <= 0;
                    y_counter <= 0;
         //           z_counter <= 0;
                    x <= 0;
                    y <= 0;
       //             z <= 0;
                    done <= 0;
                end
                COUNT: begin
           //         if (z_counter < K) begin
           //             z_counter <= z_counter + 1'b1;
          //          end else begin
           //             z_counter <= 0;
                        if (x_counter < W) begin
                            x_counter <= x_counter + 1'b1;
                        end else begin
                            x_counter <= 0;
                            if (y_counter < H) begin
                                y_counter <= y_counter + 1'b1;
                            end else begin
                                done <= 1'b1;
                            end
                        end
             //       end
                    x <= x_counter;
                    y <= y_counter;
             //       z <= z_counter;
                end
                DONE: begin
                    done <= 1'b1;
                end
            endcase
			 end	
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = COUNT;
            COUNT: next_state = (done) ? DONE : COUNT;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule
