`timescale 1ns / 1ps
module ALU (
input [15:0] A,
input [15:0] B,
input [5:0] alu_sel,
output reg [15:0] out,
output reg [4:0] flcnz
) ;

reg carry_in;
wire Cflag,Fflag,Zflag,Nflag,Lflag;
wire [15:0] sum;
wire [15:0] cmp,and1,or1,xor1;


////////////////////////////////////////
//	insert right value
CLA_16Bit cla16(
    .A(A),
    .B(B),
    .C_in(carry_in),
    .S(sum),
    .C_out(Cflag),
    .OF(Fflag)
);
/////////////////////////////////////////

              
always@* begin
	case (alu_sel)
/////////////////////////////////////////
// 	insert value to carry_in
		6'b010000 : carry_in = 1; // SUB
		6'b001000 : carry_in = 1; // CMP
		default : carry_in = 0;

/////////////////////////////////////////
	endcase
end
    

//////////////////////////////////////////
// 	insert flag values 

assign and1 = A & B;
assign or1 = A | B;
assign xor1 = A ^ B;

assign Zflag = ~|sum;
assign Lflag = Cflag;
assign Nflag = Cflag ^ A[15] ^ B[15];
//////////////////////////////////////////

always@* begin
	case (alu_sel) 
        6'b100000 : begin // ADD
        ///// flags from fc, out = some value
        flcnz[4] = Fflag;
        flcnz[2] = Cflag;
        out = sum;
        end
        
        6'b010000 : begin // SUB
        ///// flags from fc, out = some value
        flcnz[4] = Fflag;
        flcnz[2] = Cflag;
        out = sum;
        end
        
        6'b001000 : begin // CMP
            if (Zflag) begin
			///// flags from lnz
			flcnz[3] = 0;
			flcnz[1] = 0;
			flcnz[0] = Zflag;
           	end
           	
            else begin
            ///// flags from lnz
            flcnz[3] = Lflag;
            flcnz[1] = Nflag;
            flcnz[0] = Zflag;
            end
        end 
              
        6'b000100 : begin // AND
		///// out = some value
			out = and1;
		end
		
        6'b000010 : begin // OR
		///// out = some value
			out = or1;
		end
		
        6'b000001 : begin // XOR
		///// out = some value
			out = xor1;
		end
		
        default : begin
			flcnz = 5'b0;
			out = 16'b0;
		end
	endcase
end
endmodule

module PSR (
input [4:0] flag_in,
input [5:0] alu_sel,
input RESETn,
input CLK,
output [4:0] flag_out
);

reg [4:0] flag_reg;    

always@* begin
	if (~RESETn) flag_reg <= 0;
end

always@(posedge CLK) begin
        case (alu_sel) 
        6'b100000 : begin
   		///// flag update
   			flag_reg[4] <= flag_in[4];
   			flag_reg[2] <= flag_in[2];
        end
        6'b010000 : begin
        ///// flag update
			flag_reg[4] <= flag_in[4];
        	flag_reg[2] <= flag_in[2];
        end
        6'b001000 : begin
        ///// flag update
            flag_reg[3] <= flag_in[3];
            flag_reg[1] <= flag_in[1];
            flag_reg[0] <= flag_in[0];
        end
        default : ;
endcase
end

assign flag_out = flag_reg;

endmodule
