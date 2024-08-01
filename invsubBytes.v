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

module invsubBytes(invstate1,invstate2);
			input [127:0] invstate1;
			output reg [127:0] invstate2;

			integer i;
			always@* begin

				 for (i = 0; i < 16; i = i + 1) begin : loop
					  invstate2[8*i +: 8] <= invsbox(invstate1[8*i+: 8]);
				 end
				 
			end

			function[7:0] invsbox(input[7:0] a);
			begin
					case (a)
					8'h00:invsbox =8'h52;
					8'h01:invsbox =8'h09;
					8'h02:invsbox =8'h6a;
					8'h03:invsbox =8'hd5;
					8'h04:invsbox =8'h30;
					8'h05:invsbox =8'h36;
					8'h06:invsbox =8'ha5;
					8'h07:invsbox =8'h38;
					8'h08:invsbox =8'hbf;
					8'h09:invsbox =8'h40;
					8'h0a:invsbox =8'ha3;
					8'h0b:invsbox =8'h9e;
					8'h0c:invsbox =8'h81;
					8'h0d:invsbox =8'hf3;
					8'h0e:invsbox =8'hd7;
					8'h0f:invsbox =8'hfb;
					8'h10:invsbox =8'h7c;
					8'h11:invsbox =8'he3;
					8'h12:invsbox =8'h39;
					8'h13:invsbox =8'h82;
					8'h14:invsbox =8'h9b;
					8'h15:invsbox =8'h2f;
					8'h16:invsbox =8'hff;
					8'h17:invsbox =8'h87;
					8'h18:invsbox =8'h34;
					8'h19:invsbox =8'h8e;
					8'h1a:invsbox =8'h43;
					8'h1b:invsbox =8'h44;
					8'h1c:invsbox =8'hc4;
					8'h1d:invsbox =8'hde;
					8'h1e:invsbox =8'he9;
					8'h1f:invsbox =8'hcb;
					8'h20:invsbox =8'h54;
					8'h21:invsbox =8'h7b;
					8'h22:invsbox =8'h94;
					8'h23:invsbox =8'h32;
					8'h24:invsbox =8'ha6;
					8'h25:invsbox =8'hc2;
					8'h26:invsbox =8'h23;
					8'h27:invsbox =8'h3d;
					8'h28:invsbox =8'hee;
					8'h29:invsbox =8'h4c;
					8'h2a:invsbox =8'h95;
					8'h2b:invsbox =8'h0b;
					8'h2c:invsbox =8'h42;
					8'h2d:invsbox =8'hfa;
					8'h2e:invsbox =8'hc3;
					8'h2f:invsbox =8'h4e;
					8'h30:invsbox =8'h08;
					8'h31:invsbox =8'h2e;
					8'h32:invsbox =8'ha1;
					8'h33:invsbox =8'h66;
					8'h34:invsbox =8'h28;
					8'h35:invsbox =8'hd9;
					8'h36:invsbox =8'h24;
					8'h37:invsbox =8'hb2;
					8'h38:invsbox =8'h76;
					8'h39:invsbox =8'h5b;
					8'h3a:invsbox =8'ha2;
					8'h3b:invsbox =8'h49;
					8'h3c:invsbox =8'h6d;
					8'h3d:invsbox =8'h8b;
					8'h3e:invsbox =8'hd1;
					8'h3f:invsbox =8'h25;
					8'h40:invsbox =8'h72;
					8'h41:invsbox =8'hf8;
					8'h42:invsbox =8'hf6;
					8'h43:invsbox =8'h64;
					8'h44:invsbox =8'h86;
					8'h45:invsbox =8'h68;
					8'h46:invsbox =8'h98;
					8'h47:invsbox =8'h16;
					8'h48:invsbox =8'hd4;
					8'h49:invsbox =8'ha4;
					8'h4a:invsbox =8'h5c;
					8'h4b:invsbox =8'hcc;
					8'h4c:invsbox =8'h5d;
					8'h4d:invsbox =8'h65;
					8'h4e:invsbox =8'hb6;
					8'h4f:invsbox =8'h92;
					8'h50:invsbox =8'h6c;
					8'h51:invsbox =8'h70;
					8'h52:invsbox =8'h48;
					8'h53:invsbox =8'h50;
					8'h54:invsbox =8'hfd;
					8'h55:invsbox =8'hed;
					8'h56:invsbox =8'hb9;
					8'h57:invsbox =8'hda;
					8'h58:invsbox =8'h5e;
					8'h59:invsbox =8'h15;
					8'h5a:invsbox =8'h46;
					8'h5b:invsbox =8'h57;
					8'h5c:invsbox =8'ha7;
					8'h5d:invsbox =8'h8d;
					8'h5e:invsbox =8'h9d;
					8'h5f:invsbox =8'h84;
					8'h60:invsbox =8'h90;
					8'h61:invsbox =8'hd8;
					8'h62:invsbox =8'hab;
					8'h63:invsbox =8'h00;
					8'h64:invsbox =8'h8c;
					8'h65:invsbox =8'hbc;
					8'h66:invsbox =8'hd3;
					8'h67:invsbox =8'h0a;
					8'h68:invsbox =8'hf7;
					8'h69:invsbox =8'he4;
					8'h6a:invsbox =8'h58;
					8'h6b:invsbox =8'h05;
					8'h6c:invsbox =8'hb8;
					8'h6d:invsbox =8'hb3;
					8'h6e:invsbox =8'h45;
					8'h6f:invsbox =8'h06;
					8'h70:invsbox =8'hd0;
					8'h71:invsbox =8'h2c;
					8'h72:invsbox =8'h1e;
					8'h73:invsbox =8'h8f;
					8'h74:invsbox =8'hca;
					8'h75:invsbox =8'h3f;
					8'h76:invsbox =8'h0f;
					8'h77:invsbox =8'h02;
					8'h78:invsbox =8'hc1;
					8'h79:invsbox =8'haf;
					8'h7a:invsbox =8'hbd;
					8'h7b:invsbox =8'h03;
					8'h7c:invsbox =8'h01;
					8'h7d:invsbox =8'h13;
					8'h7e:invsbox =8'h8a;
					8'h7f:invsbox =8'h6b;
					8'h80:invsbox =8'h3a;
					8'h81:invsbox =8'h91;
					8'h82:invsbox =8'h11;
					8'h83:invsbox =8'h41;
					8'h84:invsbox =8'h4f;
					8'h85:invsbox =8'h67;
					8'h86:invsbox =8'hdc;
					8'h87:invsbox =8'hea;
					8'h88:invsbox =8'h97;
					8'h89:invsbox =8'hf2;
					8'h8a:invsbox =8'hcf;
					8'h8b:invsbox =8'hce;
					8'h8c:invsbox =8'hf0;
					8'h8d:invsbox =8'hb4;
					8'h8e:invsbox =8'he6;
					8'h8f:invsbox =8'h73;
					8'h90:invsbox =8'h96;
					8'h91:invsbox =8'hac;
					8'h92:invsbox =8'h74;
					8'h93:invsbox =8'h22;
					8'h94:invsbox =8'he7;
					8'h95:invsbox =8'had;
					8'h96:invsbox =8'h35;
					8'h97:invsbox =8'h85;
					8'h98:invsbox =8'he2;
					8'h99:invsbox =8'hf9;
					8'h9a:invsbox =8'h37;
					8'h9b:invsbox =8'he8;
					8'h9c:invsbox =8'h1c;
					8'h9d:invsbox =8'h75;
					8'h9e:invsbox =8'hdf;
					8'h9f:invsbox =8'h6e;
					8'ha0:invsbox =8'h47;
					8'ha1:invsbox =8'hf1;
					8'ha2:invsbox =8'h1a;
					8'ha3:invsbox =8'h71;
					8'ha4:invsbox =8'h1d;
					8'ha5:invsbox =8'h29;
					8'ha6:invsbox =8'hc5;
					8'ha7:invsbox =8'h89;
					8'ha8:invsbox =8'h6f;
					8'ha9:invsbox =8'hb7;
					8'haa:invsbox =8'h62;
					8'hab:invsbox =8'h0e;
					8'hac:invsbox =8'haa;
					8'had:invsbox =8'h18;
					8'hae:invsbox =8'hbe;
					8'haf:invsbox =8'h1b;
					8'hb0:invsbox =8'hfc;
					8'hb1:invsbox =8'h56;
					8'hb2:invsbox =8'h3e;
					8'hb3:invsbox =8'h4b;
					8'hb4:invsbox =8'hc6;
					8'hb5:invsbox =8'hd2;
					8'hb6:invsbox =8'h79;
					8'hb7:invsbox =8'h20;
					8'hb8:invsbox =8'h9a;
					8'hb9:invsbox =8'hdb;
					8'hba:invsbox =8'hc0;
					8'hbb:invsbox =8'hfe;
					8'hbc:invsbox =8'h78;
					8'hbd:invsbox =8'hcd;
					8'hbe:invsbox =8'h5a;
					8'hbf:invsbox =8'hf4;
					8'hc0:invsbox =8'h1f;
					8'hc1:invsbox =8'hdd;
					8'hc2:invsbox =8'ha8;
					8'hc3:invsbox =8'h33;
					8'hc4:invsbox =8'h88;
					8'hc5:invsbox =8'h07;
					8'hc6:invsbox =8'hc7;
					8'hc7:invsbox =8'h31;
					8'hc8:invsbox =8'hb1;
					8'hc9:invsbox =8'h12;
					8'hca:invsbox =8'h10;
					8'hcb:invsbox =8'h59;
					8'hcc:invsbox =8'h27;
					8'hcd:invsbox =8'h80;
					8'hce:invsbox =8'hec;
					8'hcf:invsbox =8'h5f;
					8'hd0:invsbox =8'h60;
					8'hd1:invsbox =8'h51;
					8'hd2:invsbox =8'h7f;
					8'hd3:invsbox =8'ha9;
					8'hd4:invsbox =8'h19;
					8'hd5:invsbox =8'hb5;
					8'hd6:invsbox =8'h4a;
					8'hd7:invsbox =8'h0d;
					8'hd8:invsbox =8'h2d;
					8'hd9:invsbox =8'he5;
					8'hda:invsbox =8'h7a;
					8'hdb:invsbox =8'h9f;
					8'hdc:invsbox =8'h93;
					8'hdd:invsbox =8'hc9;
					8'hde:invsbox =8'h9c;
					8'hdf:invsbox =8'hef;
					8'he0:invsbox =8'ha0;
					8'he1:invsbox =8'he0;
					8'he2:invsbox =8'h3b;
					8'he3:invsbox =8'h4d;
					8'he4:invsbox =8'hae;
					8'he5:invsbox =8'h2a;
					8'he6:invsbox =8'hf5;
					8'he7:invsbox =8'hb0;
					8'he8:invsbox =8'hc8;
					8'he9:invsbox =8'heb;
					8'hea:invsbox =8'hbb;
					8'heb:invsbox =8'h3c;
					8'hec:invsbox =8'h83;
					8'hed:invsbox =8'h53;
					8'hee:invsbox =8'h99;
					8'hef:invsbox =8'h61;
					8'hf0:invsbox =8'h17;
					8'hf1:invsbox =8'h2b;
					8'hf2:invsbox =8'h04;
					8'hf3:invsbox =8'h7e;
					8'hf4:invsbox =8'hba;
					8'hf5:invsbox =8'h77;
					8'hf6:invsbox =8'hd6;
					8'hf7:invsbox =8'h26;
					8'hf8:invsbox =8'he1;
					8'hf9:invsbox =8'h69;
					8'hfa:invsbox =8'h14;
					8'hfb:invsbox =8'h63;
					8'hfc:invsbox =8'h55;
					8'hfd:invsbox =8'h21;
					8'hfe:invsbox =8'h0c;
					8'hff:invsbox =8'h7d;
			endcase
			end
			endfunction

endmodule