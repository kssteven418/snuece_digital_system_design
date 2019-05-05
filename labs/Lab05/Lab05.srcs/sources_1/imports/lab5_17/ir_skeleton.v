`timescale 1ns/1ps
module ir (
	//global signal
	input clk,
	input rst_n,
	
	//control signal
	input jmp,
	input br,
	
	//datapath
    input [15:0] instruction_in,
    
    output reg [15:0] instruction_out,
    output [7:0] imm,disp,
    output [3:0] addr_a,addr_b
);
    
////// insert right value
    assign imm = instruction_out[7:0];
    assign disp = instruction_out[7:0];
    assign addr_a = instruction_out[3:0];
    assign addr_b = instruction_out[11:8];   // addr_b is different from addr_a
    

    always@(posedge clk) begin
////// insert code 
		if(~rst_n) instruction_out <= 16'b0;
		
		else begin
			if(jmp || br) instruction_out<=16'h0020;
			else instruction_out<=instruction_in;
		end
		//if jump or 	
	end

endmodule
