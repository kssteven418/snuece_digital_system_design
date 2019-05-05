// DSD Ex6
// Top testbench
`timescale 1ns/1ns

// At the end, the registers should contain (hex):
// r0=0040, r1=ed00, r2=000a, r3=0008
// r4=0005, r5=8000, r6=0178, r7=0280
`define R0_RESULT	16'h0040
`define R1_RESULT	16'hed00
`define R2_RESULT	16'h000a
`define R3_RESULT	16'h0008
`define R4_RESULT	16'h0005
`define R5_RESULT	16'h8000
`define R6_RESULT	16'h0178
`define R7_RESULT	16'h0280

`define PROG_END_TIME	4700	// in ns

module tb_top;
   parameter CLK_PERIOD = 40;	// 40ns (Freq. 25MHz)
   parameter HALF_CLK_PERIOD = CLK_PERIOD/2;

   reg 	     clk;
   reg 	     reset;
   wire      mem_clk;

   wire [15:0]		dmem_address;
   wire [15:0]		dmem_data_write;
   wire [15:0] 		dmem_data_read;
   wire			dmem_write_enable;
   wire [15:0]		imem_address;
   wire [15:0] 		imem_data;
   wire [15:0]		r0;
   wire [15:0]		r1;
   wire [15:0]		r2;
   wire [15:0]		r3;
   wire [15:0]		r4;
   wire [15:0]		r5;
   wire [15:0]		r6;
   wire [15:0]		r7;

	wire[15:0] src, dest;


   // Processor
   dsd_processor u_dsd_processor (
				  .CLK			(clk),
				  .RESET		(reset),
				  .IMEM_DATA		(imem_data),
				  .DMEM_DATA_READ	(dmem_data_read),
				  .IMEM_ADDRESS		(imem_address),
				  .DMEM_ADDRESS		(dmem_address),
				  .DMEM_DATA_WRITE	(dmem_data_write),
				  .DMEM_WRITE_ENABLE	(dmem_write_enable),
				  .r0			(r0),
				  .r1			(r1),
				  .r2			(r2),
				  .r3			(r3),
				  .r4			(r4),
				  .r5			(r5),
				  .r6			(r6),
				  .r7			(r7),
				  .src(src), .dest(dest));

   // Instruction memory (Width: 16, Depth: 1024)
   // Code initialization file: imem.mif (from imem.coe)
   imem u_imem (
		.clk(mem_clk), .addr(imem_address[9:0]), .dout(imem_data));

   // Data memory (Width: 16, Depth: 1024)
   dmem u_dmem (
		.clk(mem_clk),
		.addr(dmem_address[9:0]),
		.din(dmem_data_write), .dout(dmem_data_read), .we(dmem_write_enable));

   /////////////////////////////////////////////////////////////////////
   // Simulation
   /////////////////////////////////////////////////////////////////////
   

//debug

reg[15:0] data_in;
reg[4:0] tri_sel;
reg[15:0] instruction_out;

reg[15:0] ir_inst_in, ir_inst_out;
reg [15:0] alu_in1, alu_in2;
reg[5:0] alu_sel;
reg [15:0] alu_out;

reg[15:0] shift_in, shift_out;

reg jmp, br, lui;

always @(*) begin
	data_in = u_dsd_processor.data_in;
	tri_sel = u_dsd_processor.tri_sel;
	instruction_out= u_dsd_processor.instruction_out;
//ir_inst_in = u_dsd_processor.ir1.instruction_in;
//ir_inst_out = u_dsd_processor.ir1.instruction_out;
	alu_in1 = u_dsd_processor.alu_in1;
	alu_out = u_dsd_processor.alu_out;
	alu_in2 = u_dsd_processor.alu_in2;
	alu_sel = u_dsd_processor.alu_sel;
jmp = u_dsd_processor.jmp;
br = u_dsd_processor.br;
lui = u_dsd_processor.lui;
shift_in = u_dsd_processor.shifter_in;
shift_out = u_dsd_processor.shifter_out;
end


   // Clock
   initial
     begin
	clk = 1'b1;
	forever #HALF_CLK_PERIOD
	  clk = ~clk;
     end

   // Memory clock
   assign mem_clk = ~clk;

   // Reset
   initial
     begin
	#0 reset = 1'b1;
	#1 reset = 1'b0;
	repeat(10) @(posedge clk);
	reset = 1'b1;
     end

   // Result checker
   initial
     begin
	$monitor($time, "\tR0: %x, R1: %x, R2: %x, R3: %x, R4: %x, R5: %x, R6: %x, R7: %x",
		 r0, r1, r2, r3, r4, r5, r6, r7);
     end

   integer error = 0;
   
   task ResultCheck;
      input [2:0] index;
      input [15:0] data;
      input [15:0] expected;
      begin
	 if (!(data === expected)) begin
	    $display("Error: R%d should be 0x%x! (Your R%d is 0x%x)", index, expected, index, data);
	    error = 1;
	 end
      end
   endtask // ResultCheck
      
   initial
     begin
	error = 0;
	#`PROG_END_TIME;
	ResultCheck(0, r0, `R0_RESULT);
	ResultCheck(1, r1, `R1_RESULT);
	ResultCheck(2, r2, `R2_RESULT);
	ResultCheck(3, r3, `R3_RESULT);
	ResultCheck(4, r4, `R4_RESULT);
	ResultCheck(5, r5, `R5_RESULT);
	ResultCheck(6, r6, `R6_RESULT);
	ResultCheck(7, r7, `R7_RESULT);
	if (error == 0)
	  $display("Simulation completed successfully.");
	else
	  $display("Simulation failed!");
	$stop;
     end // initial begin
   
endmodule // tb_top

