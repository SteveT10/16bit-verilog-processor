module FSM(IR, 
				PC_clr, 
				IR_Id, 
				PC_up, 
				D_addr,
				D_wr, 
				RF_s, 
				RF_W_addr, 
				RF_W_en, 
				RF_Ra_addr, 
				RF_Rb_addr, 
				ALU_s0,
				clk);

	input [15:0] IR;
	input clk;
	output logic [7:0] D_addr;
	output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
	output logic PC_clr, IR_Id, PC_up, D_wr, RF_s, RF_W_en;
	output logic [2:0] ALU_s0;
	logic [3:0] currentState, nextState;
	
	localparam Init = 4'h0, Fetch = 4'h1, Decode = 4'h2, NOOP = 4'h3, LOAD_A = 4'h4, 
			   LOAD_B = 4'h5, STORE = 4'h6, ADD = 4'h7, HALT = 4'h8, SUB = 4'h9;
	
	always_comb begin
		case(currentState)
			Init: begin
				PC_clr = 1;
				nextState = Fetch;
			end
			Fetch: begin
				PC_up = 1; 
				IR_Id = 1;
				nextState = Decode;
			end
			Decode: begin
				if(IR[15:12] == 4'b0101) nextState = HALT;
				else if(IR[15:12] == 4'b0010) nextState = LOAD_A;
				else if(IR[15:12] == 4'b0001) nextState = STORE;
				else if(IR[15:12] == 4'b0011) nextState = ADD;
				else if(IR[15:12] == 4'b0100) nextState = SUB;
				else nextState = NOOP;
			end
			NOOP: begin
				nextState = Fetch;
			end
			LOAD_A: begin
				D_addr = IR[11:4];
				RF_s = 1;
				RF_W_addr = IR[3:0];
				nextState = LOAD_B;
			end
			LOAD_B: begin
				D_addr = IR[11:4];
				RF_s = 1;
				RF_W_addr = IR[3:0];
				RF_W_en = 1;
				nextState = Fetch;
			end
			STORE: begin
				D_addr = IR[7:0];
				D_wr = 1;
				RF_Ra_addr = IR[11:8];
				nextState = Fetch;
			end
			ADD: begin
				RF_W_addr = IR[3:0];
				RF_W_en = 1;
				RF_Ra_addr = IR[11:8];
				RF_Rb_addr = IR[7:4];
				ALU_s0 = 1;
				RF_s = 0;
				nextState = Fetch;
			end
			SUB: begin
				RF_W_addr = IR[3:0];
				RF_W_en = 1;
				RF_Ra_addr = IR[11:8];
				RF_Rb_addr = IR[7:4];
				ALU_s0 = 2;
				RF_s = 0;
				nextState = Fetch;
			end
			HALT: begin
				nextState = HALT;
			end
			default nextState = Init;
		endcase
	end
		
	always_ff @(posedge clk) begin
		currentState <= nextState;
	end

endmodule



module FSM_tb;
	logic clk, PC_clr, IR_Id, PC_up, D_wr, RF_s, RF_W_en;
	logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
	logic [7:0] D_addr;
	logic [15:0] IR;
	logic [2:0] ALU_s0;

	FSM DUT(IR, 
				PC_clr, 
				IR_Id, 
				PC_up, 
				D_addr,
				D_wr, 
				RF_s, 
				RF_W_addr, 
				RF_W_en, 
				RF_Ra_addr, 
				RF_Rb_addr, 
				ALU_s0,
				clk);

	always begin
		clk = 0; #10;
		clk = 1; #10;
	end

	initial begin
		//Init; test for clr
		IR = 16'b0011000000000001; #20;
		$display("Instruction Register Address: %b | PC_clr = %d", IR, PC_clr);
		
		//Fetch; test for IR_Id, PC_up
		#20;
		$display("IR_Id = %d, PC_up = %d", IR_Id, PC_up);

		//Decode
		#20;
		
		//Add
		#20;
		$display("Add Operation: Write Address = %b | Write Enable = %d | A Address = %b | B Address = %b | ALU Select = %b", RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0);
		
		//Sub
		IR = 16'b0100000000000001; #20;
		#100;
		$display("Sub Operation: Write Address = %b | Write Enable = %d | A Address = %b | B Address = %b | ALU Select = %b", RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0);
		
		//Load
		IR = 16'b0010000000000001; #20;
		#100;
		$display("Load Operation | Data Address: %b | Register File Select Bit: %b | Write Address: %b | Write Enable: %b", D_addr, RF_s, RF_W_addr, RF_W_en);
		
		//Store
		IR = 16'b0001000000000001; #20;
		$display("Store Operation | Data Address: %b | Data Write: %b | A Address: %b", D_addr, D_wr, RF_Ra_addr);
		
		//No-op
		IR = 16'b0000000000000001; #20;
		#100;
		$display("Previous Sub Operation w/ NOOP: Write Address = %b | Write Enable = %d | A Address = %b | B Address = %b | ALU Select = %b", RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0);
		
		//Halt
		IR = 16'b0101000000000001; #20;
		#100;
		
		//Store again after halt
		IR = 16'b0001101010101011; #20;
		$display("Store Operation After Halt (Should not Change from Previous Store) | Data Address: %b | Data Write: %b | A Address: %b", D_addr, D_wr, RF_Ra_addr);
		
		$stop;

	end

endmodule




























