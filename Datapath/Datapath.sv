/*
Steven Tieu
TCES 380 Project, Datapath unit
Assembles ALU, Mux, RegFIle and a LPM 1 Port 1 into Datapath unit.

Overflow and underflow allowed to occur in ALU.

 */
module Datapath(ALU_s0, D_addr, Clk, rdAddrA, D_wr, RF_sel, WriteAddr, rdAddrB, RF_W_en);
	
	input Clk;
	input D_wr, RF_sel, RF_W_en;
	input [7:0] D_addr;
	input [3:0] WriteAddr, rdAddrA, rdAddrB;
	input [2:0] ALU_s0;

	logic [15:0] Wr_Data;
	logic [15:0] ALU_A_in, ALU_B_in;
	
	output logic [15:0] ALU_A_out, ALU_B_out, ALUOut;

	assign ALU_A_out = ALU_A_in;
	assign ALU_B_out = 

	/*regfile16x16a
	(input clk,
	 input write,
	 input [3:0] wrAddr,
	 input [15:0] wrData,
	 input [3:0] rdAddrA,
	 output logic [15:0] rdDataA,
	 input [3:0] rdAddrB,
	 output logic [15:0] rdDataB );*/
	regfile16x16a RegUnit(Clk, RF_W_en, WriteAddr, Wr_Data, rdAddrA,  

	//Mux_16w_2to1(Sel, A, B, M);

	//DataMemory()

	//ALU(SelectFunc, A, B, Q); 

	

	output ALU_A_in, ALU_B_in, ALUOut;
	

endmodule