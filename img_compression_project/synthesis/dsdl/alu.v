module subtractor8(a, b, s, c_out);
    //s = a-b
	input[7:0] a, b;
	output [7:0] s;
	output c_out;
	
	wire[7:0] a_inv = ~a;
	wire[7:0] b_inv = ~b;
	
	wire[7:0] s1, s2;
	wire c1, c2;
		
	wire [1:0] C_out_LCU1;		
	wire [1:0] P1;
	wire [1:0] G1;
	
	wire [1:0] C_out_LCU2;		
	wire [1:0] P2;
	wire [1:0] G2;
	
	CLG2 clg2_1(.c_in(1'b1), .p(P1), .g(G1), .c_out(C_out_LCU1));
	CLA4 cla4_0_1(.a(a_inv[3:0]), .b(b[3:0]), .C_in(1'b1),          .s(s1[3:0]), .C_out(), .p_g(P1[0]), .g_g(G1[0]));
	CLA4 cla4_1_1(.a(a_inv[7:4]), .b(b[7:4]), .C_in(C_out_LCU1[0]), .s(s1[7:4]), .C_out(), .p_g(P1[1]), .g_g(G1[1]));
	
	CLG2 clg2_2(.c_in(1'b1), .p(P2), .g(G2), .c_out(C_out_LCU2));
	CLA4 cla4_0_2(.a(a[3:0]), .b(b_inv[3:0]), .C_in(1'b1),          .s(s2[3:0]), .C_out(), .p_g(P2[0]), .g_g(G2[0]));
	CLA4 cla4_1_2(.a(a[7:4]), .b(b_inv[7:4]), .C_in(C_out_LCU2[0]), .s(s2[7:4]), .C_out(), .p_g(P2[1]), .g_g(G2[1]));
	
	assign c_out = !C_out_LCU2[1];
	assign s = (c_out == 1'b1) ? s1 : s2;
	
	 
endmodule



module adder12(
	input [11:0] A, 
	input [11:0] B, 		
	output [11:0] S 		// sum
);

	wire [2:0] C_out_LCU;		// carry
	wire [2:0] P;
	wire [2:0] G;

	
	CLG3 clg3(.C_in(1'b0), .p(P), .g(G), .C_out(C_out_LCU));
	CLA4 cla4_0(.a(A[3:0]),   .b(B[3:0]),   .C_in(1'b0),         .s(S[3:0]),   .C_out(), .p_g(P[0]), .g_g(G[0]) );
	CLA4 cla4_1(.a(A[7:4]),   .b(B[7:4]),   .C_in(C_out_LCU[0]), .s(S[7:4]),   .C_out(), .p_g(P[1]), .g_g(G[1]));
	CLA4 cla4_2(.a(A[11:8]),  .b(B[11:8]),  .C_in(C_out_LCU[1]), .s(S[11:8]),  .C_out(), .p_g(P[2]), .g_g(G[2]));

endmodule


module comparator12(a, b, c_out);
    
	input[11:0] a, b;
	output c_out;
	
	wire[11:0] a_inv = ~a;
	
	wire [2:0] C_out_LCU1;		
	wire [2:0] P1;
	wire [2:0] G1;
	
	
	CLG3 clg3(.C_in(1'b1), .p(P1), .g(G1), .C_out(C_out_LCU1));
	CLA4 cla4_0(.a(a_inv[3:0]), .b(b[3:0]), .C_in(1'b1),          .C_out(), .p_g(P1[0]), .g_g(G1[0]));
	CLA4 cla4_1(.a(a_inv[7:4]), .b(b[7:4]), .C_in(C_out_LCU1[0]), .C_out(), .p_g(P1[1]), .g_g(G1[1]));
	CLA4 cla4_2(.a(a_inv[11:8]),  .b(b[11:8]),  .C_in(C_out_LCU1[1]), .C_out(), .p_g(P1[2]), .g_g(G1[2]));
	
	assign c_out = !C_out_LCU1[2];
	
	 
endmodule

//////////////////////////////////////////////////////////////////////////////////////

module CLG4(C_in, p, g, C_out);

	input C_in;
	input [3:0] p; 
	input [3:0] g;
	output [3:0] C_out;
	
	assign C_out[0] = g[0] | (p[0] & C_in);
	assign C_out[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & C_in);
	assign C_out[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & C_in);
	assign C_out[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & C_in);


endmodule

///////////////////////////////////////////////////////////////////////////////////////

module CLG3(C_in, p, g, C_out);

	input C_in;
	input [2:0] p; 
	input [2:0] g;
	output [2:0] C_out;
	
	assign C_out[0] = g[0] | (p[0] & C_in);
	assign C_out[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & C_in);
	assign C_out[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & C_in);


endmodule

///////////////////////////////////////////////////////////////////////////////////////

module CLG2(c_in, p, g, c_out);

input c_in;
input [1:0] p; 
input [1:0] g;
output [1:0] c_out;

assign c_out[0] = g[0] | (p[0] & c_in);
assign c_out[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c_in);

endmodule

////////////////////////////////////////////////////////////////////////////////////////

module CLA4
(
	input [3:0] a,
	input [3:0] b,
	input C_in,
	output [3:0] s,
	output C_out,
	output p_g,
	output g_g
);

	wire [3:0] p;
	wire [3:0] g;
	wire [3:0] c;
	
	
	assign p = a ^ b;
	assign g = a & b; 
	
	assign C_out = c[3];
	
	assign p_g = p[0] & p[1] & p[2] & p[3];
	assign g_g = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
	
	assign s[3] = p[3] ^ c[2];
	assign s[2] = p[2] ^ c[1];
	assign s[1] = p[1] ^ c[0];
	assign s[0] = p[0] ^ C_in;
	
	
	CLG4 clg4(.C_in(C_in),
		.p(p), 
		.g(g),
		.C_out(c)
	);

endmodule
