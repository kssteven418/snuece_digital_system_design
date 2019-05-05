`timescale 1ns / 1ps
module dsd_processor
 (r0,r1,r2,r3,r4,r5,r6,r7, IMEM_ADDRESS , DMEM_ADDRESS, DMEM_DATA_WRITE,
  DMEM_WRITE_ENABLE , CLK ,RESET , IMEM_DATA , DMEM_DATA_READ ,
	src, dest);
  
  output [15:0] r0,r1,r2,r3,r4,r5,r6,r7 ;
  output [15:0] IMEM_ADDRESS, DMEM_ADDRESS , DMEM_DATA_WRITE;
  output        DMEM_WRITE_ENABLE;
  output [15:0] src, dest;
  input  [15:0] IMEM_DATA,DMEM_DATA_READ;
  input         CLK,RESET;
  

	/////////// write your code here ///////////
	//wires
	wire [15:0] instruction_out; // instruction on the 2nd pipeline

	wire [3:0] addrA, addrB;

	wire [15:0] data_in; // write data to reg file
	wire [15:0] src, dest; // src, dest register values
	
	wire [7:0] disp;
	wire [7:0] imm_8bit;
	wire [15:0] imm_16bit; 

	//PSR inputs outputs
	wire[4:0] flcnz_in, flcnz_out;

	//ALU inputs outputs
	wire [15:0] alu_in1, alu_in2, alu_out;
	
	//shifter inputs outputs
	wire [15:0] shifter_in, shifter_out;



	//control signals
	
	wire[4:0] tri_sel;
	wire register_we;
	wire [5:0] alu_sel;
	wire mux_sel0, shift_imm, mux_sel1, lui, jmp, br, imm_ex_sel;

	wire[4:0] shift_amount;

	//////


	//mux1
		
	assign alu_in1 = mux_sel0 ? imm_16bit : src;

	//mux2
	
	assign shifter_in = mux_sel1 ? imm_16bit : dest;

	//mux3

	assign shift_amount = shift_imm ? imm_16bit : src;

	//tri state sel
	
	assign data_in = (tri_sel==5'b00001) ? shifter_out
		: (tri_sel==5'b00010) ? alu_out
		: (tri_sel==5'b00100) ? alu_in1
		: (tri_sel==5'b01000) ? IMEM_ADDRESS
		: (tri_sel==5'b10000) ? DMEM_DATA_READ
		: 16'bz;

	/*genvar i;
	generate for (i=0; i<16; i=i+1) begin : tris
		
		bufif1 (data_in[i], shifter_out[i], tri_sel[0]);
		bufif1 (data_in[i], alu_out[i], tri_sel[1]);
		bufif1 (data_in[i], alu_in1[i], tri_sel[2]);
		bufif1 (data_in[i], DMEM_DATA_READ[i], tri_sel[3]);
		bufif1 (data_in[i], IMEM_ADDRESS[i], tri_sel[4]);
	end endgenerate*/


	//connect other wires	
	assign alu_in2 = dest;
	//sign extension
	assign imm_16bit [7:0] = imm_8bit;
	assign imm_16bit [15:8] = imm_ex_sel ? {8{imm_8bit[7]}} : {8{1'b0}};
	
	//DMEM wires
	assign DMEM_ADDRESS = src;
	assign DMEM_DATA_WRITE = dest;


  ////////////////////////////////////////////
  
	registerFile rf1(
		.addrA(addrA), 
		.addrB(addrB),
		.data_in(data_in), 
		.CLK(CLK), 
		.RST(RESET), 
		.WR(register_we), 
		.src(src), 
		.dest(dest),
		.r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7)
	);
  

	shifter shifter1( .in(shifter_in),
		.RLamount(shift_amount),
		.lui(lui),
		.out(shifter_out)
	);

	decoder decoder1( .instruction(instruction_out),
		.flcnz(flcnz_out),
		
		.tri_sel(tri_sel),
		.register_we(register_we),
		
		.alu_sel(alu_sel),
		.mux_sel0(mux_sel0),
		
		.shift_imm(shift_imm),
		.mux_sel1(mux_sel1),
		.lui(lui),

		.jmp(jmp),
		.br(br),

		.memory_we(DMEM_WRITE_ENABLE),
	
		.imm_ex_sel(imm_ex_sel)
	);

	ir ir1( .clk(CLK),
		.rst_n(RESET),
		.jmp(jmp),
		.br(br),
		.instruction_in(IMEM_DATA),
		.instruction_out(instruction_out),
		.imm(imm_8bit),
		.disp(disp),
		.addr_a(addrA),
		.addr_b(addrB)
	);

	
	pc pc1( .clk(CLK),
		.rst_n(RESET),
		.jmp(jmp),
		.br(br),
		.src(src),
		.disp(disp),
		.addr_instruction(IMEM_ADDRESS)
	);
    

	ALU alu1( .A(alu_in1),
		.B(alu_in2),
		.alu_sel(alu_sel),
		.out(alu_out),
		.flcnz(flcnz_in)
 	);

	PSR psr1( .flag_in(flcnz_in),
		.alu_sel(alu_sel),
		.RESETn(RESET),
		.CLK(CLK),
		.flag_out(flcnz_out) );
endmodule
