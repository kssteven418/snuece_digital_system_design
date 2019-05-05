`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/17 11:54:06
// Design Name: 
// Module Name: golden
// Project Name: 
// Target Devices: 
// Tool Versionext_state: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module golden( clk, rst, start, mode_in, data_in, stall_uart, data_all_done, start_ack, finish, data_enable, data_out, golden_all_done, mem_count);
	
	parameter W = 8; // bit    
	parameter LOGW = 3;
	parameter N = 16;
	parameter LOGN = 4;
	
	parameter R = 2; //reminder bit
	parameter D = 8;
	parameter LOGD = 3;
	
	input clk, rst, start;
	input mode_in;
	input [N*W+N-1:0] data_in;
	
	input stall_uart;
	input data_all_done; // no more memory data left
	
	output reg start_ack;
	output reg finish;
	//output data_enable;
	output reg data_enable;
	output reg [W-1:0] data_out;
	
	output reg golden_all_done;
	
	reg [LOGW-1:0] shift_count;
	
	wire stall = stall_uart && (&shift_count);
	//reg stall;
	
	wire [W:0] data_in_wire[N-1:0];
	reg [W:0] data[N-1:0];
	reg mode;
	
	reg reseted;
	
	reg sign_to_send;
	reg [W-1:0] data_to_send;
	reg [R-1:0] reminder;
	reg [LOGN-1:0] data_left;
	reg [W-1:0] count;
	
	
	reg [2:0] present_state, next_state;
	parameter[2:0] idle = 3'b000, print_mode = 3'b001, print_first = 3'b010;
	parameter[2:0] encode_sign = 3'b011, encode_p = 3'b100, encode_one = 3'b101, encode_r = 3'b110, done = 3'b111;
	
	output reg [LOGD:0] mem_count;
	

	
	//assign data_enable = reseted & (&shift_count);
	
	assign {data_in_wire[0],
		data_in_wire[1], 
		data_in_wire[2], 
		data_in_wire[3],
		data_in_wire[4],
		data_in_wire[5],
		data_in_wire[6],
		data_in_wire[7],
		data_in_wire[8],
		data_in_wire[9],
		data_in_wire[10],
		data_in_wire[11],
		data_in_wire[12],
		data_in_wire[13],
		data_in_wire[14],
		data_in_wire[15]} = data_in;
		
	initial begin
		shift_count <= W-1;
	end
	
	
	always @(posedge clk) begin
		if (shift_count == 0) begin 
			data_enable <= 1'b1;
		end
		else if(!stall_uart) data_enable <= 1'b0;
	end
	
	// stage 1 : state change
	always @(posedge clk or negedge rst) begin
		if(!rst) present_state <= idle;
		else begin 
			if(stall) present_state <= present_state;
			else present_state <= next_state;
		end
	end
	
	//stage 2 : next stage
	always @(*) begin
		case(present_state)
			idle:
				if(start) next_state = print_mode;
				else next_state = idle;
				
			print_mode : 
				next_state = print_first;
			
			print_first :
				if(count == 0) next_state = encode_sign;
				else next_state = print_first;
			
			encode_sign:
				if(~|data_to_send[W-1:R]) next_state = encode_one; // if quotient is zero
				else next_state = encode_p;
			
			encode_p:
				if(count==0) next_state = encode_one;
				else next_state = encode_p;
			
			encode_one: 
				next_state = encode_r;
				
			encode_r : begin
				if(count!=0) next_state = encode_r;
				
				else begin
					if(data_left==0) begin
						if(mem_count == 0) next_state = done;
						else next_state = idle;
					end
					else next_state=encode_sign;
				end
			end
			
			done : next_state = done;
			
		endcase
	end
	
	//stage 3
	always@(posedge clk or negedge rst) begin
		
		
		if(!rst) begin
			golden_all_done <= 1'b0;
			//data_enable <= 1'b0;
			reseted <= 0;
			shift_count<=W-1;
			finish <= 1'b0;
			mem_count <= D;
		end
		
		else begin
			if(stall) begin
				if(start_ack==1'b1) start_ack <= 1'b0;
			end
			
			//not stall
			else case(present_state) 
					
				idle: if(start) begin
					//get mode from the input
					mode <= mode_in;
					start_ack <= 1;
					mem_count <= mem_count-1;
					
					//get data from the input
					{data[0],   data[1],  data[2],  data[3],
					   data[4],   data[5],  data[6],  data[7],
					   data[8],   data[9], data[10], data[11],
					   data[12], data[13], data[14], data[15]}
					<= {data_in_wire[0],   data_in_wire[1],  data_in_wire[2],  data_in_wire[3],
					   data_in_wire[4],   data_in_wire[5],  data_in_wire[6],  data_in_wire[7],
					   data_in_wire[8],   data_in_wire[9], data_in_wire[10], data_in_wire[11],
					   data_in_wire[12], data_in_wire[13], data_in_wire[14], data_in_wire[15]};
				end 
				else begin
					
				end
				
				print_mode : begin
				
					start_ack <= 0;
					//send out mode bit
					data_out <= {mode, data_out[W-1:1]};
					shift_count <= shift_count -1;
					reseted <= 1;
					
					//first data to send
					data_to_send <= data[0];
					data_left <= N-1;
					count <= W-1;
					
					//shift register
					data[0] <= data[1]; data[8] <= data[9];
					data[1] <= data[2]; data[9] <= data[10];
					data[2] <= data[3]; data[10] <= data[11];
					data[3] <= data[4]; data[11] <= data[12];
					data[4] <= data[5]; data[12] <= data[13];
					data[5] <= data[6]; data[13] <= data[14];
					data[6] <= data[7]; data[14] <= data[15];
					data[7] <= data[8]; data[15] <= {(W+1){1'b0}};
					
				end
				
				print_first : begin
					data_out <= {data_to_send[W-1], data_out[W-1:1]};
					shift_count <= shift_count -1;
					
					if(count==0) begin
						data[0] <= data[1]; data[8] <= data[9];
						data[1] <= data[2]; data[9] <= data[10];
						data[2] <= data[3]; data[10] <= data[11];
						data[3] <= data[4]; data[11] <= data[12];
						data[4] <= data[5]; data[12] <= data[13];
						data[5] <= data[6]; data[13] <= data[14];
						data[6] <= data[7]; data[14] <= data[15];
						data[7] <= data[8]; data[15] <= {(W+1){1'b0}};
						
						
						sign_to_send <= data[0][W];
						data_to_send <= data[0];
						
						data_left <= data_left-1;
						
					end
					else begin
						data_to_send <= {data_to_send[W-2:0], 1'b0};
						count <= count-1;
					end
					
				end
				
				encode_sign : begin
				
					//send out sign bit
					data_out <= {sign_to_send, data_out[W-1:1]};
					shift_count <= shift_count -1;
					
					count <= data_to_send[W-1:R]-1;
					reminder <= data_to_send[R-1:0];
					
				end
				
				encode_p : begin
					data_out <= {1'b0, data_out[W-1:1]};
					shift_count <= shift_count -1;
					
					if(count != 1'b0) count <= count -1;
				end
				
				encode_one : begin
					data_out <= {1'b1, data_out[W-1:1]};
					shift_count <= shift_count -1;
					
					count <= R-1;
				end
				
				encode_r : begin
					data_out <= {reminder[R-1], data_out[W-1:1]};
					shift_count <= shift_count -1;
					
					reminder <= {reminder[R-2:0], 1'b0};
					
					if(count!=0) begin
						count <= count-1;
					end
					
					else begin
						
						if(data_left==0) begin 
							finish <= 1;
							
						end
						
						else begin
						
							data_left <= data_left-1;
							//shift data
							data[0] <= data[1]; data[8] <= data[9];
							data[1] <= data[2]; data[9] <= data[10];
							data[2] <= data[3]; data[10] <= data[11];
							data[3] <= data[4]; data[11] <= data[12];
							data[4] <= data[5]; data[12] <= data[13];
							data[5] <= data[6]; data[13] <= data[14];
							data[6] <= data[7]; data[14] <= data[15];
							data[7] <= data[8]; data[15] <= {(W+1){1'b0}};
							
							sign_to_send <= data[0][W];
							data_to_send <= data[0];
							
						end
					end
				end
				
				done : 
					if(golden_all_done == 0) begin
						
						data_out <= {1'b0, data_out[W-1:1]};
						shift_count <= shift_count -1;
						if(shift_count == 0) begin
							golden_all_done <= 1'b1;
						end
						
					end
					
					else begin
						golden_all_done <= 1'b1;
					end 
				
			endcase
		end
	end
	
endmodule
