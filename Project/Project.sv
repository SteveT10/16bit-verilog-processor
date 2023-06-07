module Project(CLOCK_50, LEDR, LEDG, KEY, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SW);
	input [2:1] KEY;
	input CLOCK_50;
	input [17:15] SW;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output [17:15] LEDR;
	output [2:1] LEDG;
	wire [15:0] IR_Out, ALU_A, ALU_B, ALU_Out, muxOut;
	wire [3:0] nextState, state, m0, m1, m2, m3, m4, m5, m6, m7;
	wire [6:0] PC_Out;
	wire ButtonOut, FilterOut, Strobe;
	assign LEDR = SW;
	assign LEDG[2] = KEY[2];
	assign LEDG[1] = KEY[1];
	
	//ButtonSyncReg( Clk, Bis, Bo );
	ButtonSyncReg button(CLOCK_50, ~KEY[2], ButtonOut);
	
	//KeyFilter( Clock, In, Out, Strobe );
	KeyFilter Filter(CLOCK_50, ButtonOut, FilterOut, Strobe);
	
	//Processor(Clk, Reset, IR_Out, PC_Out, State, nextState, ALU_A, ALU_B, ALU_Out);
	Processor process(FilterOut, KEY[1], IR_Out, PC_Out, state, nextState, ALU_A, ALU_B, ALU_Out);
	
	/*SW[17:15] determines what HEX 7, 6, 5, and 4 displays as follow
		case SW[17:15]
			4'h0: HEX7, HEX6 = {1'b0, PC}; HEX5, HEX4 = {4'h0, Current State};
			4'h1: HEX7, 6, 5, 4 = ALU_A (A-side input to ALU)
			4'h2: HEX7, 6, 5, 4 = ALU_B (B-side input to ALU)
			4'h3: HEX7, 6, 5, 4 = ALU_Out (ALU output)
			4'h4: Next State (FSM next state variable, if you use one)
			default: HEX 7, 6, 5, 4 = 16'h0
	 */
	//Mux_16w_8_to_1(in1, in2, in3, in4, in5, in6, in7, in8, s, out);
	Mux_16w_8_to_1 multiplexer({1'b0, PC_Out, 4'b0, state}, ALU_A, ALU_B, ALU_Out, {12'b0, nextState}, 16'b0, 16'b0, 16'b0, SW[17:15], muxOut);
	
	assign m0 = muxOut[3:0];
	assign m1 = muxOut[7:4];
	assign m2 = muxOut[11:8];
	assign m3 = muxOut[15:12];
	
	assign m4 = IR_Out[3:0];
	assign m5 = IR_Out[7:4];
	assign m6 = IR_Out[11:8];
	assign m7 = IR_Out[15:12];
	
	Decoder hex0(m4, HEX0);
	Decoder hex1(m5, HEX1);
	Decoder hex2(m6, HEX2);
	Decoder hex3(m7, HEX3);
	Decoder hex4(m0, HEX4);
	Decoder hex5(m1, HEX5);
	Decoder hex6(m2, HEX6);
	Decoder hex7(m3, HEX7);
	
endmodule
	
	