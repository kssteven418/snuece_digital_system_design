module uart_baud(clk, reset_n, T_clk);
	input clk, reset_n;
	output reg T_clk;	
	
	reg[7:0] count;

	//50MHz, 115,200Hz  50M/115,200

	always @(posedge clk or negedge reset_n) begin
		if(~reset_n)begin
			count<=0;
			T_clk<=0;
		end else begin
			//if(count==8'd2) begin
			if(count==8'd217) begin
				count<=0;
				T_clk<=~T_clk;
			end else begin
				count<=count+1;
			end
		end
	end

endmodule
  
