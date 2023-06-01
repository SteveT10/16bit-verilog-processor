module regfile16x16a (clk, write, wrAddr, wrData, rdAddrA,
                      rdDataA, rdAddrB, rdDataB);

	input clk;
	input write;
	input [3:0] wrAddr;
	input [15:0] wrData;
	input [3:0] rdAddrA;
	input [3:0] rdAddrB;
	output logic [15:0] rdDataA;
	output logic [15:0] rdDataB;

	logic [15:0] regfile [0:15];
	always_ff @(posedge clk) begin
		if(write == 1) begin
			regfile[wrAddr] <= wrData;
		end else begin
			rdDataA <= regfile[rdAddrA];
			rdDataB <= regfile[rdAddrB];
		end
	end

endmodule

module regfile16x16a_tb;

	logic clk, write;
	logic [3:0] wrAddr, rdAddrA, rdAddrB;
	logic [15:0] wrData, rdDataA, rdDataB;

	regfile16x16a DUT(clk, write, wrAddr, wrData, rdAddrA, rdDataA, rdAddrB, rdDataB);
	
	always begin
		clk = 0;
		#10;
		clk = 1;
		#10;
	end

	initial begin
		write = 1;
		for(int i = 0; i < 64; i++) begin
			wrAddr = $random;
			wrData = $random;
			@(negedge clk) $display("Write case:%d, Write Address: %b, Write Data: %b", i, wrAddr, wrData);
		end
		write = 0;
		for(int i = 0; i < 64; i++) begin
			rdAddrA = $random;
			rdAddrB = $random;
			@(negedge clk) $display("Read Case:%d, Read Address A: %b, Read Address B: %b, Data A: %b, Data B: %b", i, rdAddrA, rdAddrB, rdDataA, rdDataB);
		end
		$stop;
	end

endmodule


		