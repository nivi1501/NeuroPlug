`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:10:53 06/17/2024 
// Design Name: 
// Module Name:    SFC_input 
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
module SFC_input#( 
parameter DATA_WIDTH = 15
)
(
    input clk,
    input rst,
    input wire [DATA_WIDTH:0] m, // max value of x
    input wire [DATA_WIDTH:0] n, // max value of y
    output reg [DATA_WIDTH:0] x,
    output reg [DATA_WIDTH:0] y,
	 input wire inc_enable
	 //input reg increment ; 	 
);

    // State machine states
    //typedef enum reg [1:0] {
    parameter IDLE = 2'b00;
    parameter COUNT= 2'b10;
    parameter DONE= 2'b11;
    //} state_t;

    reg [1:0] state, next_state;

    // Counters
    reg [DATA_WIDTH:0] x_counter;
    reg [DATA_WIDTH:0] y_counter;

    // State machine
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            x_counter <= 0;
            y_counter <= 0;
            x <= 0;
            y <= 0;
      //      done <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    x_counter <= 0;
                    y_counter <= 0;
                    x <= 0;
                    y <= 0;
                    //done <= 0;
                end
                COUNT: begin
					   if(inc_enable==1'b1) begin
                    if (x_counter < n) begin
                        x_counter <= x_counter + 1'b1;
                    end else begin
                        x_counter <= 0;
                        if (y_counter < m) begin
                            y_counter <= y_counter + 1'b1;
                        end //else begin
                            //done <= 1;
                        //end
                    end
                    x <= x_counter;
                    y <= y_counter;
                  end
					 end
                DONE: begin
                   // done <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = COUNT;
            COUNT: next_state =  COUNT;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule


