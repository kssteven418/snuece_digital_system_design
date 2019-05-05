module dpcm(clk, rst, start, data_in, finish_ack, start_ack, finish, mode, data_out);
    
    parameter W = 8; // bit    
    parameter N = 16;
    parameter LOGN = 4;
    
    input clk, rst, start;
    input[N*W-1:0] data_in;
    input finish_ack;
    
    output reg start_ack;
    output reg finish;
    output reg mode;   //mode that has lower sum
    output[N*W+N-1:0] data_out;
    
    //data register for each of 2 modes
    wire [W:0] data1_wire [N-1:0];
	wire [W:0] data2_wire [N-1:0];
	reg [W:0] data1 [N-1:0];
	reg [W:0] data2 [N-1:0];
	
	wire [W:0] data_out_wire [N-1:0];
	
	//sum of absolute values for each of 2 modes
	reg[11:0] sum1, sum2;
	
	reg[LOGN-1:0] cnt;
    
    
    reg [1:0] present_state, next_state;
    parameter idle = 2'b00, subtract = 2'b01, compare = 2'b10, done = 2'b11;
    
    
    //////////subtractors///////////
    wire [W-1:0] sub1_in1, sub1_in2, sub2_in1, sub2_in2, sub1_out, sub2_out;
    
    assign sub1_in1 = data1[N-1];
    assign sub1_in2 = data1[N-2];
    assign sub2_in1 = data2[N-1];
    assign sub2_in2 = data2[N-2];
    
    subtractor8 sub1(sub1_in1, sub1_in2, sub1_out, sub1_c);
    subtractor8 sub2(sub2_in1, sub2_in2, sub2_out, sub2_c);
    
    
    //////////adder///////////   
    wire [11:0] add1_in1, add1_in2, add2_in1, add2_in2, add1_out, add2_out;
    adder12 add1(add1_in1, add1_in2, add1_out);
    adder12 add2(add2_in1, add2_in2, add2_out);
    
    assign add1_in1 = sum1;
    assign add2_in1 = sum2;
    
    assign add1_in2 = {4'b0, data1[0][W-1:0]};
    assign add2_in2 = {4'b0, data2[0][W-1:0]};
        
        
    /////////comparator/////////
    wire[11:0] cmp_in1, cmp_in2;
    wire cmp_out;
    comparator12 cmp(cmp_in1, cmp_in2, cmp_out);
    
    assign cmp_in1 = sum1;
    assign cmp_in2 = sum2;
    
        
        
    assign {data1_wire[0][W-1:0],
    	data1_wire[1][W-1:0], 
        data1_wire[2][W-1:0], 
    	data1_wire[3][W-1:0],
    	data1_wire[7][W-1:0],
    	data1_wire[6][W-1:0],
    	data1_wire[5][W-1:0],
    	data1_wire[4][W-1:0],
    	data1_wire[8][W-1:0],
    	data1_wire[9][W-1:0],
    	data1_wire[10][W-1:0],
    	data1_wire[11][W-1:0],
    	data1_wire[15][W-1:0],
    	data1_wire[14][W-1:0],
    	data1_wire[13][W-1:0],
    	data1_wire[12][W-1:0]} = data_in; 
    	
	assign {data2_wire[0][W-1:0],
		data2_wire[7][W-1:0], 
		data2_wire[8][W-1:0], 
		data2_wire[15][W-1:0],
		data2_wire[1][W-1:0],
		data2_wire[6][W-1:0],
		data2_wire[9][W-1:0],
		data2_wire[14][W-1:0],
		data2_wire[2][W-1:0],
		data2_wire[5][W-1:0],
		data2_wire[10][W-1:0],
		data2_wire[13][W-1:0],
		data2_wire[3][W-1:0],
		data2_wire[4][W-1:0],
		data2_wire[11][W-1:0],
		data2_wire[12][W-1:0]} = data_in;
	
	genvar i;
	generate for (i=0; i<N; i=i+1) begin : wire_generation
		assign data1_wire[i][W] = 1'b0;
		assign data2_wire[i][W] = 1'b0;
		assign data_out_wire[i] = (mode == 1'b1) ? data2[i] : data1[i];
	end endgenerate
	
	
	assign data_out = 
	    {data_out_wire[0],
		data_out_wire[1], 
		data_out_wire[2], 
		data_out_wire[3],
		data_out_wire[4],
		data_out_wire[5],
		data_out_wire[6],
		data_out_wire[7],
		data_out_wire[8],
		data_out_wire[9],
		data_out_wire[10],
		data_out_wire[11],
		data_out_wire[12],
		data_out_wire[13],
		data_out_wire[14],
		data_out_wire[15]};
	
	
	
	initial begin
		finish <= 1'b0;
		
	end
	
	
	
	
	// stage 1 : state change
	always @(posedge clk or negedge rst) begin
		if(!rst) present_state <= idle;
		else present_state <= next_state;
	end
	
	//stage 2 : next stage
	always @(*) begin
		case(present_state)
			idle:
				if(start) next_state = subtract;
				else next_state = idle;
			
			subtract:
				if(cnt!=0) next_state = subtract;
				else next_state = compare;
			
			compare :
				next_state = done;
			
			done :
				if(finish_ack) next_state = idle;
				else next_state = done;
		endcase
	end
	
	//stage 3
	always@(posedge clk or negedge rst) begin
	
		if(!rst) begin
			finish <= 1'b0;
			start_ack <= 1'b0;
		end
		
		else case(present_state)
			
			idle : 
				//fill data arrays with the input
				if(start) begin
					{data1[0],   data1[1],  data1[2],  data1[3],
					   data1[4],   data1[5],  data1[6],  data1[7],
					   data1[8],   data1[9], data1[10], data1[11],
					   data1[12], data1[13], data1[14], data1[15]}
					<= {data1_wire[0],   data1_wire[1],  data1_wire[2],  data1_wire[3],
					   data1_wire[4],   data1_wire[5],  data1_wire[6],  data1_wire[7],
					   data1_wire[8],   data1_wire[9], data1_wire[10], data1_wire[11],
					   data1_wire[12], data1_wire[13], data1_wire[14], data1_wire[15]};
					   
					{data2[0],   data2[1],  data2[2],  data2[3],
					   data2[4],   data2[5],  data2[6],  data2[7],
					   data2[8],   data2[9], data2[10], data2[11],
					   data2[12], data2[13], data2[14], data2[15]}
					<= {data2_wire[0],   data2_wire[1],  data2_wire[2],  data2_wire[3],
					   data2_wire[4],   data2_wire[5],  data2_wire[6],  data2_wire[7],
					   data2_wire[8],   data2_wire[9], data2_wire[10], data2_wire[11],
					   data2_wire[12], data2_wire[13], data2_wire[14], data2_wire[15]};
					
					sum1 <= 12'b0;
					sum2 <= 12'b0;
					cnt <= N-1;
					start_ack<=1;
					
				end
			
			subtract : begin
				start_ack <= 0;
				if(cnt!=1'b0) begin
					cnt <= cnt-1;
					
					//shift
					data1[1]<=data1[0];  data1[2]<=data1[1];
					data1[3]<=data1[2];  data1[4]<=data1[3];
					data1[5]<=data1[4];  data1[6]<=data1[5];
					data1[7]<=data1[6];  data1[8]<=data1[7];
					data1[9]<=data1[8];  data1[10]<=data1[9];
					data1[11]<=data1[10];data1[12]<=data1[11];
					data1[13]<=data1[12];data1[14]<=data1[13];
					data1[15]<=data1[14];data1[0]<={sub1_c, sub1_out};
					
					//shift
					data2[1]<=data2[0];  data2[2]<=data2[1];
					data2[3]<=data2[2];  data2[4]<=data2[3];
					data2[5]<=data2[4];  data2[6]<=data2[5];
					data2[7]<=data2[6];  data2[8]<=data2[7];
					data2[9]<=data2[8];  data2[10]<=data2[9];
					data2[11]<=data2[10];data2[12]<=data2[11];
					data2[13]<=data2[12];data2[14]<=data2[13];
					data2[15]<=data2[14];data2[0]<={sub2_c, sub2_out};
					
				
					//data1[cnt] <= {sub1_c, sub1_out};
					//data2[cnt] <= {sub2_c, sub2_out};
					if(cnt!=N-1) begin
						sum1 <= add1_out;
						sum2 <= add2_out;
					end
				end
				else begin
					//shift
					data1[1]<=data1[0];  data1[2]<=data1[1];
					data1[3]<=data1[2];  data1[4]<=data1[3];
					data1[5]<=data1[4];  data1[6]<=data1[5];
					data1[7]<=data1[6];  data1[8]<=data1[7];
					data1[9]<=data1[8];  data1[10]<=data1[9];
					data1[11]<=data1[10];data1[12]<=data1[11];
					data1[13]<=data1[12];data1[14]<=data1[13];
					data1[15]<=data1[14];data1[0]<=data1[15];
					
					//shift
					data2[1]<=data2[0];  data2[2]<=data2[1];
					data2[3]<=data2[2];  data2[4]<=data2[3];
					data2[5]<=data2[4];  data2[6]<=data2[5];
					data2[7]<=data2[6];  data2[8]<=data2[7];
					data2[9]<=data2[8];  data2[10]<=data2[9];
					data2[11]<=data2[10];data2[12]<=data2[11];
					data2[13]<=data2[12];data2[14]<=data2[13];
					data2[15]<=data2[14];data2[0]<=data2[15];
					
					//data1[cnt] <= data1[cnt];
					//data2[cnt] <= data2[cnt];
					sum1 <= add1_out;
					sum2 <= add2_out;
				end
			end
			
			compare : begin  
				mode <= cmp_out;
				finish <= 1;
			end
			
			done : 
				if(finish_ack) finish <= 0;
			
		endcase
	
	end  		   
endmodule