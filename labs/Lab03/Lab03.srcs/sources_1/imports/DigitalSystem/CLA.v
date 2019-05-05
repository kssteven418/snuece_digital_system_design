module CLA_16Bit
(
input [15:0] A, 
input [15:0] B, 
input 	C_in,			// if 0 --> add, 1 --> sub
output [15:0] S, 		// sum
output	C_out, 			// borrow if C_in = 1 (subtract)
output	OF			// overflow
//output [15:0] A_in
);

wire [3:0] C_out_LCU;		// carry
wire [3:0] P;
wire [3:0] G;

wire [15:0] A_l;		// if C_in = 1, inverse of A
wire [15:0] A_in;
wire C_temp;
//--------- assign A_1, C_out using C_in condition --------------

assign A_l = ~A;
assign A_in = C_in ? A_l : A;

assign C_out = C_in ? !C_out_LCU[3] : C_out_LCU[3];

//---------------------------------------------------------------


CLG4 clg4(.C_in(C_in), .p(P), .g(G), .C_out(C_out_LCU));
CLA4 cla4_0(.a(A_in[3:0]), .b(B[3:0]), .C_in(C_in), .s(S[3:0]), .C_out(), .p_g(P[0]), .g_g(G[0]), .of());
CLA4 cla4_1(.a(A_in[7:4]), .b(B[7:4]), .C_in(C_out_LCU[0]), .s(S[7:4]), .C_out(), .p_g(P[1]), .g_g(G[1]), .of());
CLA4 cla4_2(.a(A_in[11:8]), .b(B[11:8]), .C_in(C_out_LCU[1]), .s(S[11:8]), .C_out(), .p_g(P[2]), .g_g(G[2]), .of());
CLA4 cla4_3(.a(A_in[15:12]), .b(B[15:12]), .C_in(C_out_LCU[2]), .s(S[15:12]), .C_out(), .p_g(P[3]), .g_g(G[3]), .of(OF));

endmodule




module CLG4
(
input C_in,
input [3:0] p, 
input [3:0] g,
output [3:0] C_out
);

//-------- assign carry out ------------------------------------


assign C_out[0] = g[0] | (p[0] & C_in);
assign C_out[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & C_in);
assign C_out[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & C_in);
assign C_out[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & C_in);

//--------------------------------------------------------------

endmodule


module CLA4
(
input [3:0] a,
input [3:0] b,
input C_in,
output [3:0] s,
output C_out,
output p_g,
output g_g,
output of
);

wire [3:0] p;
wire [3:0] g;
wire [3:0] c;

//-------- assign each bits of g, p, s -------------------------

assign p = a ^ b;
assign g = a & b; 

//--------------------------------------------------------------


//-------- assign group p, group g, Carry_out, overflow --------

assign of = c[3] ^ c[2];
assign C_out = c[3];

assign p_g = p[0] & p[1] & p[2] & p[3];
assign g_g = g[3] | (p[3] * g[2]) | (p[3] * p[2] * g[1]) | (p[3] * p[2] * p[1] * g[0]);

assign s[3] = p[3] ^ c[2];
assign s[2] = p[2] ^ c[1];
assign s[1] = p[1] ^ c[0];
assign s[0] = p[0] ^ C_in;


//--------------------------------------------------------------


//-------- CLG_4bit --------------------------------------------
CLG4 clg4(.C_in(C_in),
    .p(p), 
    .g(g),
    .C_out(c)
);



endmodule
