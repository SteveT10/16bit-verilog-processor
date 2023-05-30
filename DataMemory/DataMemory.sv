module DataMemory(addrData, writeEnable, writeData, readData, clk);
	input [7:0] addrData;
	input writeEnable, clk;
	input [15:0] writeData;
	output logic [15:0] readData;
	logic [255:0] data [0:15];

	always_ff @(posedge clk) begin
		if(writeEnable == 1) begin
			data[addrData] <= writeData;
			readData <= data[addrData];
		end else begin
			readData <= data[addrData];
		end
	end

	
endmodule

module DataMemory_tb;
	logic [7:0] addrData;
	logic writeEnable, clk;
	logic [15:0] writeData, readData;

	DataMemory DUT(addrData, writeEnable, writeData, readData, clk);

	always begin
		clk = 0;
		#10;
		clk = 1;
		#10;
	end

	initial begin
		addrData = 8'b00000001;
		writeEnable = 1;
		writeData = 8'b10101010;
		#20;
		$display("Test Case 1: Address: %b, Write Enable: %d, Write Data: %b, Read Data: %b", addrData, writeEnable, writeData, readData);
		#20;
		$display("Test Case 1: Address: %b, Write Enable: %d, Write Data: %b, Read Data: %b", addrData, writeEnable, writeData, readData);

		addrData = 8'b00000001;
		writeEnable = 0;
		writeData = 8'b10000000;
		#20;
		$display("\nTest Case 2: Address: %b, Write Enable: %d, Write Data: %b, Read Data: %b", addrData, writeEnable, writeData, readData);
		#20;
		$display("Test Case 2: Address: %b, Write Enable: %d, Write Data: %b, Read Data: %b", addrData, writeEnable, writeData, readData);
		
		for(int i = 0; i < 64; i++) begin
			{addrData, writeEnable, writeData, readData} = $random;
			#10;
			$display("Test Case %d: Address: %b, Write Enable: %d, Write Data: %b, Read Data: %b", i+2,addrData, writeEnable, writeData, readData);
			#10;
		end

			
		$stop;
	end

endmodule









		
		