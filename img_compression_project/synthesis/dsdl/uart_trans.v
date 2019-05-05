module buffer(clk, rst, data_in, data_enable, trans_done, trans_done_Tclk, idle, data_out, write_TDR, present_state);
	
	input clk, rst;
	input [7:0] data_in;
	input data_enable;
	input trans_done;
	input trans_done_Tclk;
	
	output idle;
	output [7:0] data_out;
	output reg write_TDR;
	
	parameter W = 8;
	reg [W-1:0] buffer;
	reg buffer_in;
	
	output reg[1:0] present_state;
	reg [1:0]  next_state;
	parameter IDLE= 2'b00, WAIT= 2'b01, WAIT_AGAIN= 2'b10;
	
	assign idle = buffer_in;
	assign data_out = buffer;
	
	
	always @(posedge clk or negedge rst) 
		if(!rst) present_state <= IDLE;
		else present_state <= next_state;
	
	always @(*) 
		case(present_state)
			IDLE : 
				if(data_enable) next_state = WAIT;
				else next_state = IDLE;
				
			WAIT :
				if(trans_done) next_state = WAIT_AGAIN;
				else next_state = WAIT;
				
			WAIT_AGAIN : if(!trans_done) next_state = IDLE;
			default: next_state=IDLE;
		endcase
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			buffer <= 0;
			buffer_in <= 0;
			write_TDR <= 0;
		end
		
		else case(present_state)
			IDLE : 
				if(data_enable) begin
					buffer <= data_in;
					buffer_in <= 1'b1;
					write_TDR <= 1;
				end
			
			WAIT : 
				if(trans_done) begin
					write_TDR <= 0;
				end
			WAIT_AGAIN : if(!trans_done) buffer_in <= 0;
		endcase
	end
	
	
endmodule





module uart_trans(clk, resetn, T_clk, write_TDR, data_in, TxD, trans_done, trans_done_Tclk, golden_all_done );
	parameter W = 8;
	
	input clk;
	input resetn, T_clk, write_TDR;
	input [7:0] data_in;
	
	output TxD;
	output trans_done;
	output reg  trans_done_Tclk;
	
	//output idle;
	
	//for debugging
	input golden_all_done;

	reg[8:0] TDR;
	reg[3:0] BitCnt;
	   
	reg state_Tclk;
	
	reg state_clk;

	reg [W-1:0] buffer;
	reg buffer_in;
	
	assign TxD = TDR[0];

	assign trans_done = (trans_done_Tclk == 1'b1 && state_clk == 1'b0) ? 1 : 0;
  	
  	
  	/*assign idle = buffer_in; // 0 if not busy
  	
  	always @ (posedge clk or negedge resetn) begin
  		if(!resetn) begin
  			buffer <= 0; buffer_in <= 1'b0;
  		end
  		else begin
  			if(!buffer_in & write_TDR) begin
  				buffer_in <= 1'b1;
  				buffer <= data_in;
  			end
  			else if(buffer_in & tranext_state_done) buffer_in <= 1'b0;
  		end
  	end
  	*/
	always @ (posedge T_clk or negedge resetn)begin
		if (!resetn) begin
			state_Tclk <= 1'b0;
			TDR <= 9'b1111_1111_1;
			BitCnt <= 3'd0;	
			trans_done_Tclk <= 1'b0;
		end
	
		else begin
			case(state_Tclk)
				1'b0 :
					if (write_TDR) begin 
						TDR <={data_in[0],data_in[1],data_in[2],data_in[3],data_in[4],data_in[5],data_in[6],data_in[7],1'b0}; 
						//TDR <={data_in,1'b0}; 
						BitCnt<=0; 
						state_Tclk <=1'b1; 
						trans_done_Tclk <=1'b0; /* inext_stateert your code */ 
					end else begin 
						TDR <=TDR; /* inext_stateert your code */ 
						BitCnt<=0; 
						state_Tclk <=1'b0; /* inext_stateert your code */ 
						trans_done_Tclk <=1'b0; /* inext_stateert your code */ 
					end			
				1'b1 :
					if (BitCnt < 8)begin
						TDR <={1'b1,TDR[8:1]}; /* inext_stateert your code */ 
						BitCnt<=BitCnt+1; 
						state_Tclk <=1'b1; /* inext_stateert your code */
						trans_done_Tclk <=1'b0; /* inext_stateert your code */ 
						if(BitCnt != 0) begin
							//$display("%", TxD);
							//$fwrite(f,"%b", TxD);
						end
					end else begin 
						//TDR <=; /* inext_stateert your code */
						TDR<=9'b1111_1111_1;
						BitCnt<=0;        
						state_Tclk <=1'b0; /* inext_stateert your code */
						trans_done_Tclk <=1'b1; /* inext_stateert your code */
						
						
						//$fwrite(f,"%b", TxD);
						//$display("%", TxD);
					end	
					/*
				2'b11 : begin
					if(idle_count != 0) begin
						TDR<=9'b1111_1111_1;
						BitCnt<=0;
						state_Tclk <=2'b11;
						trans_done_Tclk <=1'b0;
						idle_count <= idle_count-1;
					end
					else begin
						TDR<=9'b1111_1111_1;
						BitCnt<=0;        
						state_Tclk <=2'b00; 
						trans_done_Tclk <=1'b1;
					end
				end
					*/
				
				
			endcase		
		end
	end
	
	
	always @ (posedge clk or negedge resetn)
	begin
	if (resetn == 1'b0) begin
		state_clk <= 1'b0;
	end
	else case (state_clk)
		1'b0:	begin
		/* inext_stateert your code */
			
			if(trans_done_Tclk)begin
				state_clk<=1;
			end
			else begin
				state_clk <= 0;
			end
		end
		1'b1: begin
			if(trans_done_Tclk)begin
				state_clk<=1;
			end	
			else state_clk<=0;
		/* inext_stateert your code	 */
		end
		endcase
	end
	
	


endmodule


