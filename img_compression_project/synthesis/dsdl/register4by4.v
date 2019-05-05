
module register4by4(CLK, RSTn, WR, ADDR_W, DATA_W, data_out);
		
	parameter W = 8;
	parameter N = 16;
	parameter LOGN = 4;

	input CLK,RSTn,WR;
	

	input[LOGN-1:0] ADDR_W;
	input[W-1:0] DATA_W;

	output [W*N-1:0] data_out;

	reg[W-1:0] data[15:0];

	assign data_out = {data[0],  data[1],  data[2],  data[3],
					   data[4],  data[5],  data[6],  data[7], 
					   data[8],  data[9],  data[10], data[11],
					   data[12], data[13], data[14], data[15] };

	integer i;

	always @(negedge RSTn or posedge CLK) begin
		if(!RSTn) begin
			data[0] <= 0;
			data[1] <= 0;
			data[2] <= 0;
			data[3] <= 0;
			data[4] <= 0;
			data[5] <= 0;
			data[6] <= 0;
			data[7] <= 0;
			data[8] <= 0;
			data[9] <= 0;
			data[10] <= 0;
			data[11] <= 0;
			data[12] <= 0;
			data[13] <= 0;
			data[14] <= 0;
			data[15] <= 0;

		end else if(WR) begin
			data[ADDR_W]<=DATA_W;
		end 
	end


endmodule
