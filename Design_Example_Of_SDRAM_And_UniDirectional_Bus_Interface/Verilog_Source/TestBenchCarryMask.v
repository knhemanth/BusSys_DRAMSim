`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:00:16 11/17/2015
// Design Name:   CarryMask
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchCarryMask.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CarryMask
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchCarryMask;

	// Inputs
	reg AddrMode;
	reg [2:0] BurstLength;

	// Outputs
	wire [7:0] CarryMaskOut;

	// Instantiate the Unit Under Test (UUT)
	CarryMask uut (
		.CarryMaskOut(CarryMaskOut), 
		.AddrMode(AddrMode), 
		.BurstLength(BurstLength)
	);
	
	integer i;
	integer myfile;
	integer TRANSACTION_ID;

	initial begin
		// Initialize Inputs
		AddrMode = 0;
		BurstLength = 0;
		TRANSACTION_ID = 0;
		
		myfile = $fopen("./TestingResults/TestBench_CarryMask.txt","w");
		$fdisplay(myfile, "Transaction ID, BurstConfigLength, AddrMode, CarryMaskOutput\n");
		
		TRANSACTION_ID = TRANSACTION_ID + 1;
		for(i = 0; i <= (2 ** 3); i = i + 1)
		begin
			#10 
			$fdisplay(myfile, "%2d, %x, %1d, 8'b%b", TRANSACTION_ID, BurstLength, AddrMode, CarryMaskOut);
			BurstLength = i;
		end
		
		#10
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrMode = 1;
		i = 0;
		
		for(i = 0; i <= (2 ** 3); i = i + 1)
		begin
			#10 
			$fdisplay(myfile, "%2d, %x, %1d, 8'b%b", TRANSACTION_ID, BurstLength, AddrMode, CarryMaskOut);
			BurstLength = i;
		end
		
		$fclose(myfile);
		$finish;
	end
      
endmodule

