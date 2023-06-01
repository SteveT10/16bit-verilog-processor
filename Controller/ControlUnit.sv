module ControlUnit(Clk, Reset, ALU_s0, D_Addr, D_Wr, IR_Out, nextState, outState, 	
		   PC_Out, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, RF_W_en, RF_s);

		input Clk, Reset;
		output logic [15:0] IR_Out;
		output logic [7:0] D_Addr;
		output logic [6:0] PC_Out;
		output logic [3:0] nextState, outState, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;
		output logic [2:0] ALU_s0;
		output logic D_Wr, RF_W_en, RF_s;
	
		wire [15:0] q;
		wire PCClr, PCUp, IRLd;

		PC unit3(.Clk(Clk), PCClr, PCUp, PC_Out);
		InstructionMemory unit(PC_Out, Clk, q);
		IR unit1(Clk, q, IR_Out, IRLd);
		FSM unit2(IR_Out, PCClr, IRLd, PCUp, D_Addr, D_Wr, RF_s, RF_W_Addr, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, ALU_s0, outState, nextState, Clk);
		
	
		
endmodule

`timescale 1ns/1ns
module ControlUnit_tb;
	logic Clk, Reset;
	wire D_Wr, RF_W_en, RF_s;
	wire [15:0] IR_Out;
	wire [7:0] D_Addr;
	wire [6:0] PC_Out;
	wire [3:0] nextState, outState, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;
	wire [2:0] ALU_s0;

	ControlUnit DUT(Clk, Reset, ALU_s0, D_Addr, D_Wr, IR_Out, nextState, outState, PC_Out, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, RF_W_en, RF_s);
	
	always begin
		Clk = 0; #10;
		Clk = 1; #10;
	end

	initial begin
		Reset = 1; #20;
		Reset = 0; #20;
		#5000;
		$stop;
	end

endmodule







