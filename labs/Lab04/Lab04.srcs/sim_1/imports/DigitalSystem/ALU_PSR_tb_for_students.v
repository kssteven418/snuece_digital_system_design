`timescale 1ns/1ps
module ALU_PSR_tb ();

    reg rst;
    reg clk;
    reg [5:0] alu_sel;
    reg [15:0] a, b;
    wire [15:0] OUT;
    wire [4:0] FLCNZ;
    wire [4:0] FLAG_OUT;
    
    ALU ALU1 
(.A(a), 
.B(b),
.alu_sel(alu_sel),
.out(OUT),
.flcnz(FLCNZ));

    PSR PSR1 
(.flag_in(FLCNZ),
.alu_sel(alu_sel),
.RESETn(rst),
.CLK(clk),
.flag_out(FLAG_OUT));

    parameter p=10;

   initial
   begin
   	clk = 1'b0;
   	forever #p clk = !clk;
   end

   initial
   begin
   	rst = 1'b0;		// negedge reset on
   	#(4*p) rst = 1'b1;	// negedge reset off
   end

   initial
   begin:stimuli
	#(8*p)
	       a = 16'h0;
	       b = 16'h0; 
	       alu_sel = 6'b001000;	
	#(4*p)
	       a = 16'h46d3;
	       b = 16'hc9ba;
	       alu_sel = 6'b100000;	
	#(2*p) alu_sel = 6'b010000;	
	#(2*p) alu_sel = 6'b001000;	
 	#(2*p) alu_sel = 6'b000100;	
 	#(2*p) alu_sel = 6'b000010;	
 	#(2*p) alu_sel = 6'b000001;	
	#(2*p)
	       a = 16'h96c4;
	       b = 16'h5d3f;
	       alu_sel = 6'b100000;	
	#(2*p) alu_sel = 6'b010000;	
 	#(2*p) alu_sel = 6'b001000;	
 	#(2*p)
	       a = 16'h1234;
	       b = 16'h1234;
 	#(2*p) alu_sel = 6'b001000;	
   end

    
endmodule

