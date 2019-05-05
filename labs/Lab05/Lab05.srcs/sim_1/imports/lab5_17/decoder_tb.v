`timescale 1ns/100ps

module decoder_tb;

parameter p = 5;

reg [15:0] INSTRUCTION;
reg [4:0] PSR_FLCNZ;

wire [4:0] TRI_SEL;
wire [5:0] ALU_SEL;

wire WR;
wire JMP;
wire BR;
wire IMM_EX_SEL;
wire MUX_SEL0;
wire MUX_SEL1;
wire SHIFT_IMM;
wire LUI;
wire WE;

initial
begin
        INSTRUCTION <= 16'h0020;	
        PSR_FLCNZ <= 5'b00000;
        #(p)
        INSTRUCTION <= 16'h5001;	
        #(p)
        INSTRUCTION <= 16'h03d2;
        #(p)
        INSTRUCTION <= 16'hd40f;	
        #(p)
        INSTRUCTION <= 16'h8045;	
        #(p)
        INSTRUCTION <= 16'h8006;
        #(p)
        INSTRUCTION <= 16'hf1ed;
        #(p)
        INSTRUCTION <= 16'h4600;
        #(p)
        INSTRUCTION <= 16'h4347;	
        #(p)
        INSTRUCTION <= 16'h4687;
        #(p)
        INSTRUCTION <= 16'h4dc0;	
        #(p)
        PSR_FLCNZ <= 5'b00010;
        #(p)
        PSR_FLCNZ <= 5'b00010;
        INSTRUCTION <= 16'hcc0f;
        #(p)
        PSR_FLCNZ <= 5'b00000;
        #(p)
        INSTRUCTION <= 16'h0000;
        PSR_FLCNZ <= 5'b00000;
end

	decoder
	decoder_uut
	(
        //input
        .instruction(INSTRUCTION),
        .flcnz		(PSR_FLCNZ	),
        //output
        .tri_sel	(TRI_SEL	),
        .alu_sel	(ALU_SEL	),
        .register_we(WR		),
        .jmp		(JMP		),
        .br			(BR		),
        .mux_sel0	(MUX_SEL0	),
        .mux_sel1	(MUX_SEL1	),
        .shift_imm	(SHIFT_IMM),
        .lui		(LUI		),
        .memory_we	(WE		),
		.imm_ex_sel	(IMM_EX_SEL	)
	);
endmodule
