`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:30:43 11/16/2015
// Design Name:   BankSelectDecoder
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchBankSelectDecoder.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BankSelectDecoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchBankSelectDecoder;

	// Inputs
	reg [1:0] BSIn;
	reg CS;

	// Outputs
	wire [3:0] BSOut;

	// Instantiate the Unit Under Test (UUT)
	BankSelectDecoder uut (
		.BSOut(BSOut), 
		.BSIn(BSIn),
		.CS(CS)
	);
	
	integer myfile;
	integer TRANSACTION_ID;
	integer i;

	initial begin
		myfile = $fopen("./TestingResults/TestBenchBankSelectDecoder","w");
		$fdisplay(myfile, "CS, BSIn, BSOut");
		i = 0;
		
		TRANSACTION_ID = 0;
		
		// Initialize Inputs
		TRANSACTION_ID = TRANSACTION_ID + 1;
		for(i = 0; i < 4; i = i + 1)
		begin
			#10
			CS = 0;
			BSIn = i;
			$fdisplay(myfile, "%1d, 2'b%b, 4'b%b", CS, BSIn, BSOut);
		end
		
		TRANSACTION_ID = TRANSACTION_ID + 1;
		for(i = 0; i < 4; i = i + 1)
		begin
			#10
			CS = 1;
			BSIn = i;
			$fdisplay(myfile, "%1d, 2'b%b, 4'b%b", CS, BSIn, BSOut);
		end
		
		#10
		$fclose(myfile);
		$finish;
		
	end
      
endmodule

