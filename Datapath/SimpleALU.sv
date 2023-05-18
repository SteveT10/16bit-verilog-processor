/*
Steven Tieu
TCES 380 Midterm Bonus.
Simple 3-bit ALU unit using hierarchical design.
Based on figure 7 in mideterm.

Overflow and underflow allowed to occur.
 */

module SimpleALU(Sel, A, B, Q);
	input [2:0] Sel, A, B; //Select and the inputs
	output [2:0] Q; //output;
	
	//Mux_3w_8_to_1( M, S, R, T, U, V, W, X, Y, Z);
	Mux_3w_8_to_1 unit(Q, Sel, 3'b000, A + B, A - B, A, A ^ B, A | B, A & B, A + 3'b001);
	
endmodule

module SimpleALU_tb;
	logic [2:0] Sel; //Select
	logic [2:0] A, B; //ALU inputs
	logic [2:0] Q; //ALU output
	SimpleALU DUT(.Sel(Sel), .A(A), .B(B), .Q(Q));
	initial begin
		A = 3'b101;
		B = 3'b010;

		for(int k = 0; k < 8; k++) begin
			Sel = k;
			#10;
		end

		for(int j = 0; j < 10; j++) begin
			{Sel, A, B} = $random;
			#10;
		end
	end
	initial
	$monitor( "Sel = %d \t A = %b \t B = %b \t Q = %b", Sel, A, B, Q);
endmodule
	