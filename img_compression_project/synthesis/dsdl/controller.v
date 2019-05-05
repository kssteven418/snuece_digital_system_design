

module mem_controller(clk, reset, start, imem_address, WR, ADDR_W, finish, finish_ack);
	input clk,reset, start;
	input finish_ack;
	output [13:0] imem_address;
	
	output reg WR;
	output [3:0] ADDR_W;

	output reg finish;

	reg[9:0] row_col;
	wire[4:0] row_count;
	wire[4:0] col_count;
	reg[3:0] count;// 0Î∂Ä15ÍπåÏ Ï¶ùÍ.
	
	assign row_count = row_col[9:5];
	assign col_count = row_col[4:0];
	
	reg[1:0] ps, ns;
	parameter idle = 2'b00, update = 2'b01, done = 2'b10, real_done = 2'b11;

	assign ADDR_W = count;
	assign imem_address = {row_count,9'b000000000}+{col_count,2'b00}+{count[3:2],7'b0000000}+count[1:0];

	// always@(posedge clk or negedge reset)begin
	// 	if(!reset)begin
	// 		dpcm_addr1=0; dpcm_addr2=0;	
	// 	end else begin
	// 		if(count==0)begin
	// 			dpcm_addr1<=local_addr;
	// 			dpcm_addr2<=dpcm_addr1;
	// 		end else begin
	// 			dpcm_addr1<=local_addr;
	// 			dpcm_addr2<=local_addr;
	// 		end
	// 	end
	// end

	always @ (posedge clk or negedge reset) begin
		
		if(!reset) ps <= idle;
		else ps <= ns;

	end


	always @(*) case (ps)

		idle : 
			if(start == 1'b1) ns = update;
			else ns = idle;

		update :
			if(count == 4'b1111) begin
				if(row_count == 5'b11111 && col_count == 5'b11111) ns = real_done;
				else ns = done;
			end
			else ns = update;

		done : 
			if(finish_ack == 1'b1) ns = update;
			else ns = done;

		real_done : ns = real_done;

	endcase


	//memory address controller
	always@(posedge clk or negedge reset)begin
		
		if(!reset)begin
			//row_count<=0;
			//col_count<=0;
			row_col <= 0;
			count<=0;
			
			finish <= 0;
			WR <= 0;
		end 

		else case (ps)
			idle : 
				if(start == 1'b1) begin
					WR <= 1'b1;
					count <= 0;
					finish <= 1'b0;
				end

			update: begin

				count <= count + 1'b1;

				if(count == 4'b1111) begin
					
					row_col <= row_col + 1;
					

					finish <= 1'b1;
					WR <= 1'b0;


				end
			end

			done : begin
				if(finish_ack == 1'b1) begin
					WR <= 1'b1;
					count <= 0;
					finish <= 1'b0;
				end

			end

			
		endcase
	end

endmodule