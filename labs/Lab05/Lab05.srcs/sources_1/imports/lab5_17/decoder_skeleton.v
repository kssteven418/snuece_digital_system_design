`timescale 1ns / 100ps
module decoder(

    input [15:0] instruction,
    input [4:0] flcnz,
	
	//register control signal
    output reg [4:0] tri_sel,	// select din : alu, shifter, mem, reg, etc...
	output reg register_we,		// write_enable to register  

	//alu control signal
	output reg [5:0] alu_sel,	// select alu ops
	output reg mux_sel0,		// select alu input : immediate or register file?	
    
	
	//signal to shifter
	output reg shift_imm,		// select shift amount : immediate or register?
	output reg mux_sel1,		// select shiftee : immediate or register file?
	output reg lui,				// lui op?

	//control flow signal
	output reg jmp,
	output reg br,

	//memory signal
	output reg memory_we,		//write_enable to memory
	
	//immediate extenstion signal
	output reg imm_ex_sel		// immediate extension : signed or unsigned?
	);
	
	wire f, l, c, n, z;
	assign f = flcnz[4];
	assign l = flcnz[3];
	assign c = flcnz[2];
	assign n = flcnz[1];
	assign z = flcnz[0];
	
	//====================================
	//									//
	//	decoder is combinational logic  //
	//    	   do not make latch		//
	//									//
	//====================================
	
	
	initial begin
		tri_sel = 5'b00000;
		alu_sel = 6'b000000;
		register_we = 0;
		jmp = 0;
		br = 0;
		mux_sel0 = 0;
		mux_sel1 = 0;
		shift_imm = 0;
		lui = 0;
		memory_we = 0;
		imm_ex_sel = 0;
	end
	
	always@( instruction, flcnz) begin
		//write code below
		//code needed here?

		//
		if( instruction[15:12]== 4'b0000 && instruction[7:4] == 4'b0101) begin  //add
       		tri_sel = 5'b00010;
       		alu_sel = 6'b100000;
       		register_we = 1;
       		jmp = 0;
       		br = 0;
       		mux_sel0 = 0;
       		memory_we = 0;
       		
       		mux_sel1 = 0;
       		shift_imm = 0;
       		lui = 0;
       		imm_ex_sel = 0;
		end
		else if( instruction[15:12]== 4'b0101) begin//addi
			tri_sel = 5'b00010;
			alu_sel = 6'b100000;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 1;
			memory_we = 0;
			imm_ex_sel = 1;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
       
		end
		else if( instruction[15:12]== 4'b0000 && instruction[7:4] == 4'b1001) begin //sub
    		tri_sel = 5'b00010;
			alu_sel = 6'b010000;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 0;
			memory_we = 0;

       		mux_sel1 = 0;
       		shift_imm = 0;
       		lui = 0;
       		imm_ex_sel = 0;
   		end
		else if( instruction[15:12]== 4'b1001) begin  //subi
			tri_sel = 5'b00010;
			alu_sel = 6'b010000;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 1;
			memory_we = 0;
			imm_ex_sel = 1;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
		end
		else if( instruction[15:12]== 4'b0000 && instruction[7:4] == 4'b1011) begin//cmp
 			tri_sel = 5'b00010;
			alu_sel = 6'b001000;
			register_we = 0;
			jmp = 0;
			br = 0;
			mux_sel0 = 0;
			memory_we = 0;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
    	end        
		else if( instruction[15:12]== 4'b1011) begin      //cmpi
      		tri_sel = 5'b00010;
			alu_sel = 6'b001000;
			register_we = 0;
			jmp = 0;
			br = 0;
			mux_sel0 = 1;
			memory_we = 0;
			imm_ex_sel = 1;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
   		end
		else if( instruction[15:12]== 4'b0000 && instruction[7:4] == 4'b0001) begin //and
  			tri_sel = 5'b00010;
			alu_sel = 6'b000100;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 0;
			memory_we = 0;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
		end
		else if( instruction[15:12]== 4'b0001) begin // andi 
      		tri_sel = 5'b00010;
			alu_sel = 6'b000100;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 1;
			memory_we = 0;
			imm_ex_sel = 0;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
		end
		else if( instruction[15:12]== 4'b0000 && instruction[7:4] == 4'b0010) begin //or
			tri_sel = 5'b00010;
			alu_sel = 6'b000010;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 0;
			memory_we = 0; 
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;     
		end
		else if( instruction[15:12]== 4'b0010) begin  //ori    
			tri_sel = 5'b00010;
			alu_sel = 6'b100010;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 1;
			memory_we = 0;
			imm_ex_sel = 0;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
		end
		else if( instruction[15:12]== 4'b0000 && instruction[7:4] == 4'b0011) begin      //xor
			tri_sel = 5'b00010;
			alu_sel = 6'b000001;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 0;
			memory_we = 0;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
		end
		else if( instruction[15:12]== 4'b0011) begin        //xori
			tri_sel = 5'b00010;
			alu_sel = 6'b000001;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 1;
			memory_we = 0;
			imm_ex_sel = 0;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
		end
		else if( instruction[15:12]== 4'b0000 && instruction[7:4] == 4'b1101) begin      //mov 
        	tri_sel = 5'b00100;
        	register_we = 1;
        	jmp = 0;
        	br = 0;
        	mux_sel0 = 0;
        	memory_we = 0;
        	
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
		end
		else if( instruction[15:12]== 4'b1101) begin     //movi
        	tri_sel = 5'b00100;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel0 = 1;
			memory_we = 0;
			imm_ex_sel = 0;
			
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
		end
		else if( instruction[15:12]== 4'b1000 && instruction[7:4] == 4'b0100) begin      //lsh 
			tri_sel = 5'b00001;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			memory_we = 0;
			
			mux_sel0 = 0;
			imm_ex_sel = 0;
		end
		else if( instruction[15:12]== 4'b1000 && instruction[7:5] == 4'b000) begin      //lshi 
        	tri_sel = 5'b00001;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel1 = 0;
			shift_imm = 1;
			lui = 0;
			memory_we = 0;
			
			mux_sel0 = 0;
			imm_ex_sel = 0;
		end
		else if( instruction[15:12]== 4'b1111) begin      //lui
        	tri_sel = 5'b00001;
			register_we = 1;
			jmp = 0;
			br = 0;
			mux_sel1 = 1;
			lui = 1;
			memory_we = 0;
			
			mux_sel0 = 0;
			shift_imm = 0;
			imm_ex_sel = 0;
		end 
		else if( instruction[15:12]== 4'b0100 && instruction[7:4] == 4'b0000) begin     //load
			tri_sel = 5'b10000;
			register_we = 1;
			jmp = 0;
			br = 0;
			memory_we = 0;
				
			mux_sel0 = 0;
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
		end
		else if( instruction[15:12]== 4'b0100 && instruction[7:4] == 4'b0100) begin      //store
			tri_sel = 5'b00000;
			register_we = 0;
			jmp = 0;
			br = 0;
			memory_we = 1;
			
			mux_sel0 = 0;
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
		end        
		else if( instruction[15:12]== 4'b0100 && instruction[7:4] == 4'b1000) begin      //jal
			tri_sel = 5'b01000;
			register_we = 1;
			jmp = 1;
			br = 0;
			memory_we = 0;
			
			mux_sel0 = 0;
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
		end 
		else if( instruction[15:12]== 4'b1100) begin      //Bcond 

       		if      ( instruction[11:8] == 4'b0000 && z==1) br = 1;
       		else if ( instruction[11:8] == 4'b0001 && z==0) br = 1;
       		else if ( instruction[11:8] == 4'b1101 && (n==1 || z==1)) br = 1;
       		else if ( instruction[11:8] == 4'b0010 && c==1) br = 1;
       		else if ( instruction[11:8] == 4'b0011 && c==0) br = 1;
       		else if ( instruction[11:8] == 4'b0100 && l==1) br = 1;
       		else if ( instruction[11:8] == 4'b0101 && l==0) br = 1;
       		else if ( instruction[11:8] == 4'b1010 && (l==0 && z==0)) br = 1;
       		else if ( instruction[11:8] == 4'b1011 && (l==1 || z==1)) br = 1;
       		else if ( instruction[11:8] == 4'b0110 && n==1) br = 1;
       		else if ( instruction[11:8] == 4'b0111 && n==0) br = 1;
       		else if ( instruction[11:8] == 4'b1000 && f==1) br = 1;
       		else if ( instruction[11:8] == 4'b1001 && f==0) br = 1;
       		else if ( instruction[11:8] == 4'b1100 && (n==0 && z==0)) br = 1;
       		else if ( instruction[11:8] == 4'b1110) br = 1;
       		else if ( instruction[11:8] == 4'b1111) br = 0;
       		else br = 0;
       		
       		tri_sel = 5'b00000;
       		register_we = 0;
       		jmp = 0;
       		memory_we = 0;
       
			mux_sel0 = 0;
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
   	end 
		else if( instruction[15:12]== 4'b0100 && instruction[7:4] == 4'b1100) begin     //Jcond
			
			if      ( instruction[11:8] == 4'b0000 && z==1) jmp = 1;
			else if ( instruction[11:8] == 4'b0001 && z==0) jmp = 1;
			else if ( instruction[11:8] == 4'b1101 && (n==1 || z==1)) jmp = 1;
			else if ( instruction[11:8] == 4'b0010 && c==1) jmp = 1;
			else if ( instruction[11:8] == 4'b0011 && c==0) jmp = 1;
			else if ( instruction[11:8] == 4'b0100 && l==1) jmp = 1;
			else if ( instruction[11:8] == 4'b0101 && l==0) jmp = 1;
			else if ( instruction[11:8] == 4'b1010 && (l==0 && z==0)) jmp = 1;
			else if ( instruction[11:8] == 4'b1011 && (l==1 || z==1)) jmp = 1;
			else if ( instruction[11:8] == 4'b0110 && n==1) jmp = 1;
			else if ( instruction[11:8] == 4'b0111 && n==0) jmp = 1;
			else if ( instruction[11:8] == 4'b1000 && f==1) jmp = 1;
			else if ( instruction[11:8] == 4'b1001 && f==0) jmp = 1;
			else if ( instruction[11:8] == 4'b1100 && (n==0 && z==0)) jmp = 1;
			else if ( instruction[11:8] == 4'b1110) jmp = 1;
			else if ( instruction[11:8] == 4'b1111) jmp = 0;
			else jmp = 0;
       		
			tri_sel = 5'b00000;
			register_we = 0;
			br = 0;
			memory_we = 0;
			
			mux_sel0 = 0;
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			imm_ex_sel = 0;
   	end
		
		else begin
			tri_sel = 5'b00000;
			alu_sel = 6'b000001;
			register_we = 0;
			jmp = 0;
			br = 0;
			mux_sel0 = 0;
			mux_sel1 = 0;
			shift_imm = 0;
			lui = 0;
			memory_we = 0;
			imm_ex_sel = 0;	
		end 
	end
endmodule

