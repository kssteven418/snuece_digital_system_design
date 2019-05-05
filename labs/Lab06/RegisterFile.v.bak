module registerFile(addrA, addrB, data_in, CLK, RST, WR, src, dest,
	r0, r1, r2, r3, r4, r5, r6, r7);

	input [3:0] addrA, addrB; 
	input [15:0] data_in;
	input CLK, RST, WR;

	output reg [15:0] src, dest;
	
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	

	reg [15:0] data[7:0];
	reg [15:0] i;

	assign r0 = data[0];
	assign r1 = data[1];
	assign r2 = data[2];
	assign r3 = data[3];
	assign r4 = data[4];
	assign r5 = data[5];
	assign r6 = data[6];
	assign r7 = data[7];

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