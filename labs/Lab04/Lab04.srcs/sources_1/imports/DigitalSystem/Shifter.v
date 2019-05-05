`timescale 1ns / 100ps
module mux16 (
input [15:0] input1,
input [15:0] input0,
input select1,
output [15:0] output1
);
    
//////////////////////////////////////////////////////////////
/////	assign output1
assign output1 = select1 ? input1 : input0;
//////////////////////////////////////////////////////////////  
endmodule
       
       
        
module shifter (
input	[15:0]	in,
input	[4:0]	RLamount,
input			lui,
output	[15:0]	out
);    
wire [15:0] out1,out2,out3,out4,out5,out6,out7,out8;

/////////////////////////////////////////////////////////////////////////
//// 		insert parameter

mux16 mux16_minus_3 (
    .input1({1'b0, in[15:1]}),
    .input0({9'b0, in[15:9]}),
    .select1(RLamount[3]),
    .output1(out1));
mux16 mux16_minus_2 (
    .input1(out1),
    .input0({4'b0, out1[15:4]}),
    .select1(RLamount[2]),
    .output1(out2));
mux16 mux16_minus_1 (
    .input1(out2),
    .input0({2'b0, out2[15:2]}),
    .select1(RLamount[1]),
    .output1(out3));
mux16 mux16_minus_0 (
    .input1(out3),
    .input0({1'b0, out3[15:1]}),
    .select1(RLamount[0]),
    .output1(out4));


mux16 mux16_plus_3 (
    .input1({in[7:0], 8'b0}),
    .input0(in),
    .select1(RLamount[3]),
    .output1(out5));
mux16 mux16_plus_2 (
    .input1({out5[11:0], 4'b0}),
    .input0(out5),
    .select1(RLamount[2]),
    .output1(out6));
mux16 mux16_plus_1 (
    .input1({out6[13:0], 2'b0}),
    .input0(out6),
    .select1(RLamount[1]),
    .output1(out7));
mux16 mux16_plus_0 (
    .input1({out7[14:0], 1'b0}),
    .input0(out7),
    .select1(RLamount[0]),
    .output1(out8));

////		insert some value
assign out = (lui) ? {in[7:0],8'b0} : ( (RLamount[4]) ? out4 : out8 );
///////////////////////////////////////////////////////////////////////////

endmodule
