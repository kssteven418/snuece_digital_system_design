`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:52:31 12/21/2017 
// Design Name: 
// Module Name:    make_clk 
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
module make_clk(input clk,input reset_n,output reg clkdiv);
	reg[7:0] clk_count;

	//50MHz, 115,200Hz  50M/115,200=

	//clkdiv generator
	always @(posedge clk or negedge reset_n) begin
		if(~reset_n)begin
			clk_count<=0;
			clkdiv<=0;
		end else begin
			if(clk_count==8'd1) begin
				clk_count<=0;
				clkdiv<=~clkdiv;
			end else begin
				clk_count<=clk_count+1;
			end
		end
	end

endmodule
