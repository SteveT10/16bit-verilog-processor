module Processor(Clk, Reset, IR_Out, PC_Out, State, nextState, ALU_A, ALU_B, ALU_Out);
	input Clk, Reset;
	output logic [15:0] IR_Out, ALU_A, ALU_B, ALU_Out;
	output logic [6:0] PC_Out;
	output logic [3:0] State, nextState;
	logic [2:0] ALU_s0;
	logic [7:0] D_Addr;
	logic D_Wr, RF_W_en, RF_s;
	logic [3:0] RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;

	/*ControlUnit(Clk, Reset, ALU_s0, D_Addr, D_Wr, IR_Out, nextState, outState, 	
		   PC_Out, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, RF_W_en, RF_s);*/
	ControlUnit controller(.Clk(Clk), .Reset(Reset), .ALU_s0(ALU_s0), 
							.D_Addr(D_Addr), .D_Wr(D_Wr), .IR_Out(IR_Out), 
							.nextState(nextState), .outState(State), .PC_Out(PC_Out),
							.RF_Ra_Addr(RF_Ra_Addr), .RF_Rb_Addr(RF_Rb_Addr), 
							.RF_W_Addr(RF_W_Addr), .RF_W_en(RF_W_en), .RF_s(RF_s));

	/*module Datapath(ALU_s0, D_addr, clk, rdAddrA, D_wr, RF_sel, WriteAddr, 
                rdAddrB, RF_W_en, ALU_A_out, ALU_B_out, ALUout);*/
	Datapath datapath(.ALU_s0(ALU_s0), .D_addr(D_Addr), .clk(Clk), .rdAddrA(RF_Ra_Addr), 
						.D_wr(D_Wr), .RF_sel(RF_s), .WriteAddr(RF_W_Addr), .rdAddrB(RF_Rb_Addr), 
						.RF_W_en(RF_W_en), .ALU_A_out(ALU_A), .ALU_B_out(ALU_B), .ALUout(ALU_Out));

	
endmodule



