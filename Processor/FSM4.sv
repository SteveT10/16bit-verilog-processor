/**
 * File              : ControllerStateMachine.sv
 * Author            : Souleymane Dembele <sdembele@uw.edu>
 * Date              : 05.27.2023
 * Last Modified Date: 05.28.2023
 * Last Modified By  : Souleymane Dembele <sdembele@uw.edu>
 */

module FSM (
    Clk,
    instruction,
    Rst,
    ALUSelect,
    CurrentStateOut,
    DAddr,
    DWrite,
    IRLd,
    NextStateOut,
    PCClr,
    PCUp,
    RFAReadAddr,
    RFBReadAddr,
    RFSelect,
    RFWriteAddr,
    RFWriteEnable
);
  // Define inputs and outputs
  // inputs
  input Clk, Rst;
  input [15:0] instruction;
  // outputs
  output logic [2:0] ALUSelect;
  output [3:0] CurrentStateOut;
  output logic [7:0] DAddr;
  output logic DWrite;
  output logic IRLd;
  output [3:0] NextStateOut;
  output logic PCClr;
  output logic PCUp;
  output logic [3:0] RFAReadAddr;
  output logic [3:0] RFBReadAddr;
  output logic RFSelect;
  output logic [3:0] RFWriteAddr;
  output logic RFWriteEnable;

  localparam INIT = 4'b1000,  // initial state
  FETCH = 4'b1111,  // fetch instruction
  DECODE = 4'b1100,  // decode instruction
  NOOP = 4'b0000,  // no operation
  LOAD_A = 4'b0010,  // load A
  STORE = 4'b0001,  // store
  ADD = 4'b0011,  // ADD
  SUB = 4'b0100,  // SUB
  HALT = 4'b0101,  // halt
  LOAD_B = 4'b0110;  // load B

  // Define the current state
  reg [3:0] CurrentState, NextState;

  always_ff @(posedge Clk, negedge Rst)
    if (Rst) CurrentState <= INIT;
    else CurrentState <= NextState;

  // Define the next state logic
  always_comb
    case (CurrentState)
      INIT: begin
        // INIT
        PCClr = 1'b1;  // clear PC
        NextState = FETCH;  // go to fetch
      end
      FETCH: begin
        // FETCH
        PCUp = 1'b1;  // increment PC
        IRLd = 1'b1;  // load instruction
        NextState = DECODE;  // go to decode
      end
      DECODE: begin  // decode instruction
        NextState = instruction[15:12] == 4'b0000 ? NOOP :  // no operation
        instruction[15:12] == 4'b0010 ? LOAD_A :  // load A
        instruction[15:12] == 4'b0001 ? STORE :  // store
        instruction[15:12] == 4'b0011 ? ADD :  // ADD
        instruction[15:12] == 4'b0100 ? SUB :  // SUB
        instruction[15:12] == 4'b0101 ? HALT :  // halt
        DECODE;  // decode
      end
      NOOP: NextState = FETCH;  // go to fetch
      LOAD_A: begin  // load A
        DAddr = instruction[11:4];  // set DAddr
        RFSelect = 1'b1;  // select RF
        RFWriteAddr = instruction[3:0];  // set RFWriteAddr
        NextState = LOAD_B;  // go to load B
      end
      STORE: begin  // store
        DAddr = instruction[7:0];  // set DAddr
        DWrite = 1'b1;  // enable DWrite
        RFAReadAddr = instruction[11:8];  // set RFAReadAddr
        NextState = FETCH;  // go to fetch
      end
      ADD: begin  // ADD
        RFWriteAddr = instruction[3:0];  // set RFWriteAddr
        RFWriteEnable = 1'b1;  // enable RFWrite
        RFAReadAddr = instruction[11:8];  // set RFAReadAddr
        RFBReadAddr = instruction[7:4];  // set RFBReadAddr
        ALUSelect = 3'b001;  // set ALUSelect
        RFSelect = 1'b0;  // select RF
        NextState = FETCH;  // go to fetch
      end
      SUB: begin  // SUB
        RFWriteAddr = instruction[3:0];  // set RFWriteAddr
        RFWriteEnable = 1'b1;  // enable RFWrite
        RFAReadAddr = instruction[11:8];  // set RFAReadAddr
        RFBReadAddr = instruction[7:4];  // set RFBReadAddr
        ALUSelect = 3'b010;  // set ALUSelect
        RFSelect = 1'b0;  // select RF
        NextState = FETCH;  // go to fetch
      end
      HALT: begin  // halt
        NextState = HALT;  // stay in halt
      end
      LOAD_B: begin  // load B
        DAddr = instruction[11:4];  // set DAddr
        RFSelect = 1'b1;  // select RF
        RFWriteAddr = instruction[3:0];  // set RFWriteAddr
        RFWriteEnable = 1'b1;  // enable RFWrite
        NextState = FETCH;  // go to fetch
      end
      default: NextState = INIT;  // go to init
    endcase
  // outputs
  assign CurrentStateOut = CurrentState;
  assign NextStateOut = NextState;

endmodule

module FSM_tb;
  reg Clk, Rst;
  reg [15:0] instruction;
  wire [2:0] ALUSelect;
  wire [3:0] CurrentStateOut;
  wire [7:0] DAddr;
  wire DWrite;
  wire IRLd;
  wire [3:0] NextStateOut;
  wire PCClr;
  wire PCUp;
  wire [3:0] RFAReadAddr;
  wire [3:0] RFBReadAddr;
  wire RFSelect;
  wire [3:0] RFWriteAddr;
  wire RFWriteEnable;

  FSM FSM (
      .Clk(Clk),
      .Rst(Rst),
      .instruction(instruction),
      .ALUSelect(ALUSelect),
      .CurrentStateOut(CurrentStateOut),
      .DAddr(DAddr),
      .DWrite(DWrite),
      .IRLd(IRLd),
      .NextStateOut(NextStateOut),
      .PCClr(PCClr),
      .PCUp(PCUp),
      .RFAReadAddr(RFAReadAddr),
      .RFBReadAddr(RFBReadAddr),
      .RFSelect(RFSelect),
      .RFWriteAddr(RFWriteAddr),
      .RFWriteEnable(RFWriteEnable)
  );

  always begin
    Clk = 0;
    #10;
    Clk = 1;
    #10;
  end


  initial begin
    Rst = 1;
    instruction = 16'b0000000000000000;
    #20;
    Rst = 0;
    instruction = 16'b0000000000000000;
    #20;
    for (int i = 0; i < 65536; i = i + 1) begin  //  65536
      instruction = i;
      #20;
    end
    $stop;
  end
  initial begin
    $monitor(
        $time,,,,
        "instruction = %b, ALUSelect = %b, CurrentStateOut = %b, DAddr = %b, DWrite = %b, IRLd = %b, NextStateOut = %b, PCClr = %b, PCUp = %b, RFAReadAddr = %b, RFBReadAddr = %b, RFSelect = %b, RFWriteAddr = %b, RFWriteEnable = %b",
        instruction, ALUSelect, CurrentStateOut, DAddr, DWrite, IRLd, NextStateOut, PCClr, PCUp,
        RFAReadAddr, RFBReadAddr, RFSelect, RFWriteAddr, RFWriteEnable);
  end
endmodule
