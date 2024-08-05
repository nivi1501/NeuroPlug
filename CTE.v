`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:23 07/27/2024 
// Design Name: 
// Module Name:    CTE 
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
module CTE(i_data,key,rst,clk,o_data,en,done,hold);

input clk,rst,en;
input [255:0] i_data;
input [127:0] key;
output [127:0] o_data;
// hold signifies --- do not send input, I have a full FIFO
output hold;
output done;
wire [255:0] compressedData;
wire compression_done;
wire [3:0] encoding;
wire [8:0] compressed_data_size;
reg [9:0] total_compressed_data;
reg encry_enable;
wire compr_enable;
reg fifo_rd_en,fifo_wr_en;
wire [127:0] plaintext;

// Compress the input
Compressor C1(.clk(clk),.i_data(i_data),.o_data(compressedData),.rst(rst), 
.enable(en),.encoding(encoding),.ready(compression_done));

reg  [1:0] state;
wire [4:0] round;
localparam ENCRYPT=2'b01;
localparam LOAD_BUFFER=2'b00;
localparam WAIT=2'b10;
// Decode the size of the compressed data	
Decoder_Compressed_Size Decoder(encoding, compressed_data_size, clk);

// Encrypt the compressed data
encryption E1 (
    .clk(clk),
    .start(encry_enable),
    .rstn(~rst),
    .plain_text(plaintext),
    .cipher_key(key),
    .done(done),
    .completed_round(round),
    .cipher_text(o_data)
);

// Controller for CTE -- variable compression size
reg hold; // Tells to stop sending data to CTE and wait
integer i,j;
always @(posedge clk) begin
    if (rst) begin
        total_compressed_data <= 0;
        //buffer <= 0;
        hold <= 0;
        encry_enable <= 0;
        state <= LOAD_BUFFER; // Initialize state
		  fifo_wr_en<=0;
		  fifo_rd_en<=0;
    end else if (compression_done) begin
        $display ("Uncompressed = %h\n", compressedData);
        case (state)
       
            // Encryption takes 10 cycles (pipleined). This is done in parallel
            LOAD_BUFFER: begin
                encry_enable <= 0; // Disable encryption while loading buffer
                // This part is for updating the buffer with the content of the compressedData
                if (total_compressed_data + compressed_data_size <= 512) begin
					     fifo_wr_en<=1;
						  fifo_rd_en<=0;
                    hold <= 0;
                    total_compressed_data <= total_compressed_data + compressed_data_size;
						  state <= ENCRYPT;
                end else begin
                    hold <= 1;
						  fifo_wr_en<=0;
						  fifo_rd_en<=0;
                    state <= ENCRYPT;
                end
            end // LOAD_BUFFER end
				
				
				// Start encryption
            ENCRYPT: begin				    
				    // Encryption is done, load new data if available
					 if (total_compressed_data >= 128) begin
                    total_compressed_data <= total_compressed_data - 10'd128;
                    // Shift buffer content by 128 bits 
                    encry_enable <= 1;
                    fifo_rd_en<=1;
						  fifo_wr_en<=0;
                    state <= WAIT;
					 // encryption is done, load data from buffer	  
                end else if(total_compressed_data < 128)  begin // Less data in the buffer
                    encry_enable <= 0;
                    state <= LOAD_BUFFER;
						  fifo_rd_en<=0;
						  fifo_wr_en<=0;
                end
            end
            // WAIT for encryption to finish
				WAIT: begin
				      if(done==0) begin
				        state <= WAIT;
						  hold <= 1;
						  end
						else 
						  state <= LOAD_BUFFER;
						  hold <= 0;
				end
				
        endcase // case end
    end // else if end
end // always end

wire full,empty;
FIFO_Buffer FIFO(
    .clk(clk),
    .rst(rst),
    .i_data(compressedData),         // Input data
    .i_data_size(compressed_data_size),      // Input data size in bits
    .write_en(fifo_wr_en),               // Write enable signal
    .read_en(fifo_rd_en),                // Read enable signal
    .o_data(plaintext),    // Output data
    .full(full),              // Full flag
    .empty(empty)              // Empty flag
);



endmodule
