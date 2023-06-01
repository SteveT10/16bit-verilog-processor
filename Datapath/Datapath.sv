/*
Steven Tieu
TCES 380 Project, Datapath unit
Assembles ALU, Mux, RegFIle and a LPM 1 Port 1 into Datapath unit.

Overflow and underflow allowed to occur in ALU.
Based on Figure 4 in Datapath view.
 */
module Datapath(ALU_s0, D_addr, clk, rdAddrA, D_wr, RF_sel, WriteAddr, 
                rdAddrB, RF_W_en, ALU_A_out, ALU_B_out, ALUout);

	input clk;
	input D_wr, RF_sel, RF_W_en; //Data write enable, Register select, Register write enable.
	input [7:0] D_addr; //Data address to access.
	input [3:0] WriteAddr, rdAddrA, rdAddrB; //write address, read address A, and B
	input [2:0] ALU_s0; //ALU select

    logic [15:0] Data_to_Mux; //Data output to Mux input B
	logic [15:0] Wr_Data; //Mux to RegFiles: data to write
	logic [15:0] ALU_A_in, ALU_B_in; //RegFiles to ALU
    logic [15:0] ALU_out_to_Mux; //ALU out to mux input
 	
    //Monitor outputs
	output logic [15:0] ALU_A_out, ALU_B_out, ALUout;
	assign ALU_A_out = ALU_A_in;
	assign ALU_B_out = ALU_B_in;
	assign ALUout = ALU_out_to_Mux;

    //DataMemory (address, clock, data, wren, q);
    DataMemory RAMunit(D_addr, clk, rdAddrA, D_wr, Data_to_Mux);

    //Mux_16w_2to1(Sel, A, B, M);
    Mux_16w_2to_1 MuxUnit(RF_sel, ALU_out_to_Mux, Data_to_Mux, Wr_Data);

	/*regfile16x16a
	(input clk,
	 input write,
	 input [3:0] wrAddr,
	 input [15:0] wrData,
	 input [3:0] rdAddrA,
	 output logic [15:0] rdDataA,
	 input [3:0] rdAddrB,
	 output logic [15:0] rdDataB );*/
	regfile16x16a RegUnit(clk, RF_W_en, WriteAddr, Wr_Data, rdAddrA, ALU_A_in, rdAddrB, ALU_B_in); 

    //ALU(SelectFunc, A, B, Q); 
    ALU ALUunit(ALU_s0, ALU_A_in, ALU_B_in, ALU_out_to_Mux);

endmodule

`timescale 1ns/1ns
module Datapath_tb();

    logic clk;
	logic D_wr, RF_sel, RF_W_en; //Data write enable, Register select, Register write enable.
	logic [7:0] D_addr; //Data address to access.
	logic [3:0] WriteAddr, rdAddrA, rdAddrB; //write address, read address A, and B
	logic [2:0] ALU_s0; //ALU select
 	
    //Monitor outputs
	logic [15:0] ALU_A_out, ALU_B_out, ALUout;

    //Instruction from IR to be executed:

    //First 4 bits of instruction ommitted due to being OpCode.
    logic [11:0] IR;
    assign WriteAddr = IR[3:0];
    assign rdAddrA = IR[11:8];
    assign rdAddrB = IR[7:4];
    //D_addr can be either IR[11:4] or IR[7:0]

    Datapath DUT(ALU_s0, D_addr, clk, rdAddrA, D_wr, RF_sel, WriteAddr, 
                rdAddrB, RF_W_en, ALU_A_out, ALU_B_out, ALUout);
    
    always begin //50 Mhz Clock
		clk = 0; #10;
		clk = 1; #10;
	end 

    //TODO 
        //Does assert and monitor ram work?
        //DO we need to run the tests posted on classes
        //What do we run quartus projects on?
        //Why do we need to wait clock cycle to enable w_en

        //EDGE CASES: START AND END OF REG, START AND END OF DATA MEM?
        //CLEAR SIGNALS AFTER TESTING EVERY OP?
    
    initial begin
        //Init: PC_clr = 1, Fetch IR_Id = 1, PC_up = 1, Decode are 
        //Controller Unit states only.

        #2; //Neccesary?

        /**************ADD 1**************/
        //WriteAddr =  IR[3:0];//RF_W_addr = IR[3:0]
        //rdAddrA = IR[11:8];
        //rdAddrB = IR[7:4];
        IR = 12'h123; //Reg 3 = Reg 1 + Reg 2 
        RF_W_en = 1'b1;
        ALU_s0 = 1'b1;
        RF_sel = 1'b0;
        @(negedge clk)
        $display($time,,,"Add Operation: Wr Addr = %b | Wr En = %d | A Addr = %b | B Addr = %b | ALU Sel = %b",
                 WriteAddr, RF_W_en, rdAddrA, rdAddrB, ALU_s0);
        //assert(Reg 3 = 1111 + 2222 = 3333)
        #5;

        /**************ADD 2**************/
        IR = 12'h234; //Reg 4 = Reg 2 + Reg 3
        @(negedge clk)
        $display($time,,,"Add Operation 2: Wr Addr = %b | Wr En = %d | A Addr = %b | B Addr = %b | ALU Sel = %b",
                 WriteAddr, RF_W_en, rdAddrA, rdAddrB, ALU_s0); 
        //assert(Reg 4 = 2222 + 3333 = 5555)       
        #5;

        /**************SUB 1**************/
        IR = 12'h021; //Reg 0 = Reg 2 - Reg 1? double check with order
        //WriteAddr = IR[3:0]; 
        //rdAddrA = IR[11:8];
        //rdAddrB = IR[7:4];
        RF_W_en = 1'b1;
        ALU_s0 = 2'd2;
        RF_sel = 1'b0;
        @(negedge clk)
        $display($time,,,"Sub Operation: Wr Addr = %b | Wr En= %d | A Addr = %b | B Addr = %b | ALU Sel = %b",
                 WriteAddr, RF_W_en, rdAddrA, rdAddrB, ALU_s0); 
        $display($time,,,"Sub Operation: Wr Addr = %b | Wr En= %d | A Addr = %b | B Addr = %b | ALU Sel = %b",
                 WriteAddr, RF_W_en, rdAddrA, rdAddrB, ALU_s0); 
        //assert(Reg 0 = 2222 - 1111 = 1111)
        assert(DUT.RAMunit.address == 8'h00 && DUT.RAMunit.wrData == 4'b1111);       
        #5;

        /**************LOAD A (First clock cycle)**************/
        RF_W_en = 1'b0;
        IR = 12'h1BA; // RF[0A] = D[1B]
        D_addr = IR[11:4];
        //WriteAddr = IR[3:0];
        RF_sel = 1'b1;
        @(negedge clk)
        $display($time,,,"Load Operation A | Data Addr: %b | RF Sel: %b | Wr Addr: %b | Write En: %b",
                 D_Addr, RF_sel, WriteAddr, RF_W_en);        
        #5;

        /**************LOAD B (Second clock cycle)**************/
        //D_addr = IR[11:4];
        //WriteAddr = IR[3:0];
        RF_W_en = 1'b1;
        @(negedge clk)
        $display($time,,,"Load Operation B | Data Addr: %b | RF Sel: %b | Wr Addr: %b | Write En: %b",
                 D_Addr, RF_sel, WriteAddr, RF_W_en);        
        #5;

        /**************STORE**************/
        IR = 12'hA6A; //D[6A] = RF[0A]
        D_addr = IR[7:0]; 
        D_wr = 1'b1;
        //rdAddrA = IR[11:8];
        @(negedge clk)
        $display($time,,,"Store Operation | Data Addr: %b | D Wr: %b | A Addr: %b",
                  D_addr, D_wr, rdAddrA);        
        #5;

        /**************NO-OP AND HALT**************/
        D_wr = 1'b0;
        RF_sel = 1'b0;
        RF_W_en = 1'b0;
        @(negedge clk)
        $display($time,,,"Attempted Store After Halt Operation | Data Addr: %b | D Wr: %b | A Addr: %b",
                  D_addr, D_wr, rdAddrA);        
        #5;

        $stop;
    end

endmodule