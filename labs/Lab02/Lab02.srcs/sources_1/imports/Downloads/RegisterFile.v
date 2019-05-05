

module RegisterFile(addrA, addrB, data_in, CLK, RST, WR, src, dest);

	input [3:0] addrA, addrB; 
	input [15:0] data_in;
	input CLK, RST, WR;

	output reg [15:0] src, dest;

	
	reg [15:0] data[7:0];
	reg [15:0] i;

	initial begin
		src <= 16'b0;
		dest <= 16'b0;
	end

	//write
	always @(posedge CLK or negedge RST) begin
		
		if(!RST) begin
			for(i=0; i<8; i = i+1) data[i]<=0;
		end

		else if(WR) data[addrB[2:0]] <= data_in;
	
	end

	//read
	always @(*) begin
		src = data[addrA[2:0]];
 		dest = data[addrB[2:0]];
	end


endmodule