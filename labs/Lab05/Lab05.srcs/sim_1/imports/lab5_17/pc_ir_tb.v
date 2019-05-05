`timescale 1ns/1ps
module pc_ir_tb;

   parameter p = 5;


   reg RST_N;
   reg CLK;
   reg JMP;
   reg BR;
   wire [7:0] DISP;
   wire [7:0] IMM;
   reg [15:0] SRC;
   wire [15:0] ADDR_IMEM;
   
   reg [15:0] INSTRUCTION_IN;
   wire [15:0] INSTRUCTION_OUT;
   
   wire [3:0] ADDR_A;
   wire [3:0] ADDR_B;
   
   pc uut_pc0 (
	   .clk(CLK), 
	   .rst_n(RST_N), 
	   
	   .jmp(JMP), 
	   .br(BR),
	   
	   .src(SRC), 
	   .disp(DISP), 
	   
	   .addr_instruction(ADDR_IMEM)
   );
   
   ir uut_ir0 (
	   .clk(CLK), 
	   .rst_n(RST_N),

	   .jmp(JMP), 
	   .br(BR),
	   
	   .instruction_in(INSTRUCTION_IN),
	   .instruction_out(INSTRUCTION_OUT),

	   .addr_a(ADDR_A), 
	   .addr_b(ADDR_B), 
	   .imm(IMM), 
	   .disp(DISP)
   );


   initial begin
   		CLK = 1'b1;
        forever #p CLK = !CLK;
   end
 
   initial begin
        RST_N = 1'b1;
        #(2*p) RST_N = 1'b0;
        #(1*p) RST_N = 1'b1;
   end

	initial begin
		#0.05
		//test begin
		JMP = 1'b0;
		BR = 1'b0;
		SRC = 16'h16f0;
		//0. Initial PC value set
		#(4*p)
		//PC value is 16'h0001
		JMP = 1'b1;
		BR = 1'b0;
		SRC = 16'h16f0;
		//1. Normal
		#(2*p)
		//PC value is 16'h16f0
		JMP = 1'b0;
		BR = 1'b0;
		SRC = 16'h16f0;

		//2. JAL or Jcond
		#(2*p)
		//PC value is 16'h16f1
		JMP = 1'b1;
		BR = 1'b0;
		SRC = 16'h06f0;
		#(2*p)
		//PC value is 16'h06f2
		JMP = 1'b0;
		BR = 1'b0;
		SRC = 16'h06f0;
		#(2*p)
		//PC value is 16'h06f1
		JMP = 1'b1;
		BR = 1'b1;
		SRC = 16'h16f0;
		#(2*p)
		//PC value is 16'h16f0
		JMP = 1'b0;
		BR = 1'b0;
		SRC = 16'h16f0;

		//3. Bcond
		#(4*p)
		//PC value is 16'h16f1
		JMP = 1'b0;
		BR = 1'b1;
		SRC = 16'h16f0;
		#(2*p)
		//PC value is 16'h16ef
		JMP = 1'b0;
		BR = 1'b0;
		SRC = 16'h16f0;
		#(2*p)
		//PC value is 16'h16f0
  		JMP = 1'b0;
  		BR = 1'b1;
  		SRC = 16'h16f0;
		#(2*p)
		//PC value is 16'h16f4
		JMP = 1'b0;
		BR = 1'b0;
		SRC = 16'h16f0;
		//4. Normal Infinity
		//test end
		#(2*p)
		$stop;

	end



	//Virtual Instruction Memory
	always@* begin
		

    	case(ADDR_IMEM)
    	16'h0000 : INSTRUCTION_IN <= 16'h0000;
    	16'h06f0 : INSTRUCTION_IN <= 16'h1111;
		16'h16ef : INSTRUCTION_IN <= 16'h2204;
		16'h16f0 : INSTRUCTION_IN <= 16'h3333;
		16'h16f1 : INSTRUCTION_IN <= 16'h44fd;
		16'h16f2 : INSTRUCTION_IN <= 16'h5555;
		16'h16f3 : INSTRUCTION_IN <= 16'h6666;
		default : INSTRUCTION_IN <= 16'hffff;
		endcase

	end




endmodule

