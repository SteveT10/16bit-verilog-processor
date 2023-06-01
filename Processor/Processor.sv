module Processor(Clk, Reset, IR_Out, PC_Out, State, nextState, ALU_A, ALU_B, ALU_Out);
	input Clk, Reset;
	output [15:0] IR_Out, ALU_A, ALU_B, ALU_Out;
	output [7:0] PC_out;
	output [3:0] State, nextState;

	Control