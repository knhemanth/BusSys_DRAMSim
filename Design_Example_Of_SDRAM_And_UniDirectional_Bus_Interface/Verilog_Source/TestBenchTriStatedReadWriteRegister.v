`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:29:20 11/12/2015
// Design Name:   TriStatedReadWriteRegister
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchTriStatedReadWriteRegister.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TriStatedReadWriteRegister
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchTriStatedReadWriteRegister;

	// Inputs
	reg RE;
	reg WE;
	reg [31 : 0] DataIn;

	wire [31:0] DataOut;
	

	// Instantiate the Unit Under Test (UUT)
	TriStatedReadWriteRegister uut (
		.DataOut(DataOut), 
		.DataIn(DataIn),
		.RE(RE), 
		.WE(WE)
	);
	
	
	initial begin
		// Initialize Inputs
		RE = 0;
		WE = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		WE = 1 ; DataIn = 32'h00112233;
		#10 WE = 0; 
		#10 RE = 1;
	end
      
endmodule

