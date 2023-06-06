module Decoder(c, Hex);

	input [3:0] c;
	output [0:6] Hex;
	
	always @(c)
	begin
		case(c)
			0: Hex = 7'b0000001;
			1: Hex = 7'b1001111;
			2: Hex = 7'b0010010;
			3: Hex = 7'b0000110;
			4: Hex = 7'b1001100;
			5: Hex = 7'b0100100;
			6: Hex = 7'b0100000;
			7: Hex = 7'b0001111;
			8: Hex = 7'b0000000;
			9: Hex = 7'b0000100;
			10: Hex = 7'b0001000;
			11: Hex = 7'b1100000;
			12: Hex = 7'b1000010;
			13: Hex = 7'b1000010;
			14: Hex = 7'b0110000;
			15: Hex = 7'b0111000;
			default Hex = 7'bx;
		endcase
		end
			
		
endmodule