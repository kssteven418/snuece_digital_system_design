`timescale 1ns / 100ps
module shifter_tb ();

   wire [15:0] OUT;
   reg [15:0] INPUT;
   reg [4:0] RLamount;
   reg LUI;

    ///////////////////////// modify this part  ////////////////////////////

    shifter shifter1 (	.in(INPUT), 
						.RLamount(RLamount),
						.lui(LUI),
						.out(OUT)
					);

    //////////////////////////////////////////////////////////////////////


    parameter p=10;

   initial
   begin:stimuli
	   INPUT = 16'b1000_0000_0000_0001;
	   LUI = 1'b0;
	   RLamount = 5'b00011;
	#p RLamount = 5'b00011;
	#p RLamount = 5'b00110;
	#p RLamount = 5'b01101;
	#p RLamount = 5'b10010;
	#p RLamount = 5'b10111;
	#p RLamount = 5'b11001;
	#p LUI = 1'b1;
	#p RLamount = 5'b00111;
	#p RLamount = 5'b01001;
 	#p RLamount = 5'b10101;
	end
  
    
    
endmodule
