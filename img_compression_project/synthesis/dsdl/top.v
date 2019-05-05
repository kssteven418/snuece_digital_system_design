`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:01:51 12/17/2017 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(clk, reset, sw, TxD/*, LED1, LED2, LED3, LED_start, LED_end, LED_idx1, LED_idx2, LED_idx3*/);

	parameter N=16;
	parameter W=8;
	parameter D = 1024; // memory sizez
	parameter LOGD = 11;
	
	input clk, reset, sw;

	//output reg LED1, LED3;
	//output LED2;
	
	//output LED_start;
	//output LED_end;
	//output LED_idx1, LED_idx2;
	//output LED_idx3;
	
	output TxD;
	
	wire rst = ~reset;
	wire [LOGD:0] mem_count;
	assign LED_idx1 = mem_count[0];
	assign LED_idx2 = mem_count[1];
	assign LED_idx3 = mem_count[2];
	
	wire[1:0] buffer_ps;
	//assign LED_start = buffer_ps[0];
	//assign LED_end = buffer_ps[1];
	
	//reg clk, rst;
	//reg mode;
	//reg[40:0] count;
	
	
	///////////////////////////////memory////////////////////////////////
	
	wire mem_start;
	wire mem_finish_ack;
	wire [W*N-1:0] data_out_mem;
	wire mem_finish;
	wire data_all_done;
	
	assign mem_start = sw;
	
	
	////////////////////////////////////dpcm//////////////////////////////////
	wire dpcm_start;
	wire dpcm_start_ack;
	wire dpcm_finish;
	wire dpcm_finish_ack;
	wire dpcm_mode;
	
	assign dpcm_start = mem_finish;
	
	
	wire [W-1:0] data_in_reg_dpcm[N-1:0];
	wire [W*N-1:0] data_in_dpcm;
	wire [N*W+N-1:0] data_out_dpcm;
	wire [W:0] data_out_arr_dpcm[N-1:0]; // for debugging
	
	assign data_in_dpcm = data_out_mem;
	assign mem_finish_ack = dpcm_start_ack;
	
	///////////////////////////////////////Golden//////////////////////////////
	
	wire golden_start;
	wire[W-1:0] golden_out;
	wire golden_stall_uart;
	//wire golden_finish;
	wire golden_data_enable;
	wire golden_mode;
	wire golden_start_ack;
	
	wire golden_all_done;
	
	assign golden_start = dpcm_finish;
	assign golden_mode = dpcm_mode;
	
	reg [W:0] data_in_reg_golden[N-1:0];
	wire [N*W+N-1:0] data_in_golden;
	
	assign data_in_golden = data_out_dpcm;
	assign dpcm_finish_ack = golden_start_ack;
	
	
	/////////////////////////////////////UART/////////////////////////////////
	wire buffer_idle;
	wire [W-1:0] buffer_out;
	wire write_TDR;
	wire trans_done, trans_done_Tclk;
	wire T_clk;
	
	assign golden_stall_uart = buffer_idle;	
	//assign LED_end = golden_all_done;
	//assign LED_buffer_idle = golden_data_enable;
	
	///////////////////////////////////////////////////////////////////////////
	
	
	wire new_clk;
	wire mem_clk = ~new_clk;
	
	wire WR;
	 wire[3:0] ADDR_W;
	 wire [13:0] imem_address;
	 wire [7:0] imem_data;
	
	imem u_imem (
		.clka(mem_clk), .addra(imem_address), .douta(imem_data));
   
	mem_controller u_controller(.clk(new_clk), .reset(rst), .start(mem_start), 
		.imem_address(imem_address), .WR(WR), .ADDR_W(ADDR_W), .finish(mem_finish), .finish_ack(mem_finish_ack));

	register4by4 u_register4by4(.CLK(new_clk), .RSTn(rst), .WR(WR), .ADDR_W(ADDR_W), .DATA_W(imem_data), .data_out(data_out_mem));
	
	
	
	//memory_model #(.D(D), .LOGD(LOGD)) u_memory(.clk(clk), .rst(rst), .start(mem_start), 
	//					  .finish_ack(mem_finish_ack), .data_out(data_out_mem), .finish(mem_finish), .data_all_out(data_all_done), .data_start(/*LED_start*/),
	//					  .index1(), .index2());
	
	dpcm u_dpcm(.clk(new_clk), .rst(rst), .start(dpcm_start), .data_in(data_in_dpcm), .finish_ack(dpcm_finish_ack), 
				.start_ack(dpcm_start_ack), .finish(dpcm_finish), .mode(dpcm_mode), .data_out(data_out_dpcm));
	
	golden #(.D(D), .LOGD(LOGD)) u_golden (.clk(new_clk), .rst(rst), .start(golden_start), .mode_in(golden_mode), .data_in(data_in_golden), .stall_uart(golden_stall_uart), 
			.start_ack(golden_start_ack), .data_all_done(data_all_done), .finish(), .data_enable(golden_data_enable), .data_out(golden_out), . golden_all_done(golden_all_done),
			.mem_count(mem_count));
	
	buffer u_buffer(.clk(new_clk), .rst(rst), .data_in(golden_out), .data_enable(golden_data_enable), .trans_done(trans_done), .trans_done_Tclk(trans_done_Tclk),
						.idle(buffer_idle), .data_out(buffer_out), .write_TDR(write_TDR), .present_state(buffer_ps));
	
	uart_baud u_uart_baud(.clk(clk), .reset_n(rst), .T_clk(T_clk));
	uart_trans u_uart_trans(.clk(new_clk), .resetn(rst), .T_clk(T_clk), .write_TDR(write_TDR), 
							.data_in(buffer_out), .TxD(TxD), .trans_done(trans_done), .trans_done_Tclk(trans_done_Tclk), .golden_all_done(golden_all_done));
		
	//make_clk u_make_clk(.clk(clk),.reset_n(rst),.clkdiv(new_clk));
	assign new_clk=clk;

    //for debugging only
    
	assign {data_out_arr_dpcm[0],
			data_out_arr_dpcm[1], 
			data_out_arr_dpcm[2], 
			data_out_arr_dpcm[3],
			data_out_arr_dpcm[4],
			data_out_arr_dpcm[5],
			data_out_arr_dpcm[6],
			data_out_arr_dpcm[7],
			data_out_arr_dpcm[8],
			data_out_arr_dpcm[9],
			data_out_arr_dpcm[10],
			data_out_arr_dpcm[11],
			data_out_arr_dpcm[12],
			data_out_arr_dpcm[13],
			data_out_arr_dpcm[14],
			data_out_arr_dpcm[15]} = data_out_dpcm;
		
		
		assign {data_in_reg_dpcm[0],
			data_in_reg_dpcm[1], 
			data_in_reg_dpcm[2], 
			data_in_reg_dpcm[3],
			data_in_reg_dpcm[4],
			data_in_reg_dpcm[5],
			data_in_reg_dpcm[6],
			data_in_reg_dpcm[7],
			data_in_reg_dpcm[8],
			data_in_reg_dpcm[9],
			data_in_reg_dpcm[10],
			data_in_reg_dpcm[11],
			data_in_reg_dpcm[12],
			data_in_reg_dpcm[13],
			data_in_reg_dpcm[14],
			data_in_reg_dpcm[15]} = data_in_dpcm;
			
//	assign  data_in_golden = 
//	        {data_in_reg_golden[0],
//			data_in_reg_golden[1], 
//			data_in_reg_golden[2], 
//			data_in_reg_golden[3],
//			data_in_reg_golden[4],
//			data_in_reg_golden[5],
//			data_in_reg_golden[6],
//			data_in_reg_golden[7],
//			data_in_reg_golden[8],
//			data_in_reg_golden[9],
//			data_in_reg_golden[10],
//			data_in_reg_golden[11],
//			data_in_reg_golden[12],
//			data_in_reg_golden[13],
//			data_in_reg_golden[14],
//			data_in_reg_golden[15]};
	
	//assign golden_stall_uart = 1'b0;
	
	/*
	initial begin
		clk <= 0;
		mem_start <= 0;
		#10 rst=0;
		#10 rst=1;
		
		#10 mem_start <= 1;
		#50 mem_start <= 0;
		
		
	end
	
	always #10 clk=~clk;
	*/
	
	
	/*
	initial begin
	
			mode <= 1'b1;
			data_in_reg[0] <=167;
			data_in_reg[1] <=278;
			data_in_reg[2] <=0;
			data_in_reg[3] <=278;
			data_in_reg[4] <=31;
			data_in_reg[5] <=286;
			data_in_reg[6] <=10;
			data_in_reg[7] <=30;
			data_in_reg[8] <=296;
			data_in_reg[9] <=8;
			data_in_reg[10] <=24;
			data_in_reg[11] <=267;
			data_in_reg[12] <=24;
			data_in_reg[13] <=10;
			data_in_reg[14] <=34;
			data_in_reg[15] <=21;
	end
*/

//for input debug
/*
initial begin
	LED1 <= 0;
	count <= 0;
	LED3 <= 1;
end


always @(posedge clk) begin
	if(rst) LED1 <= 1;
	else LED1 <= 0;
end

assign LED2 = golden_stall_uart;

always @(posedge clk) begin
	
	//if(count==8'd2) begin
	if(count==100000000) begin
		count<=0;
		LED3<=~LED3;
	end else begin
		count<=count+1;
	end
	
end
		*/	
endmodule
