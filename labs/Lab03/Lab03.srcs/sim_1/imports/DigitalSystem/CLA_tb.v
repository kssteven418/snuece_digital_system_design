
 module test_bench_for_lab3
();
  reg [15:0] A,B;
  reg C_IN; 
  wire [15:0]S;
  wire C,  F;
/*
input [15:0] A, 
input [15:0] B, 
input 	C_in,			// if 0 --> add, 1 --> sub
output [15:0] S, 		// sum
output	C_out, 			// borrow if C_in = 1 (subtract)
output	OF
*/


   CLA_16Bit u_CLA_16Bit 
	(.A(A), 
	.B(B), 
	.C_in(C_IN), 
	.S(S), 
	.C_out(C), 
	.OF(F)
	);


  initial
  begin
  C_IN= 0;
  A = 16'hf; B = 16'h1;
  #50 A= 16'hffff; B = 16'h1;
  #50 A= 16'd2009; B = 16'd12345;  
  #50 A= 16'hcabb; B = 16'h0880;
  #50 A= 16'h7fff; B= 16'h1;

  
  //subtraction (b-a)
  #50 C_IN= 1;
  A = 16'h1; B = 16'h1;
  #50 A = 16'h1; B = 16'h100;
  #50 A= 16'd2009; B = 16'd12345;
  #50 A = 16'h1; B = 16'h1000;
  #50 A = 16'h1; B = 16'h0;//borrow
  #50 A = 16'h8000; B = 16'h7fff;//overflowend
  
  end

endmodule

