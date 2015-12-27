`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:35:51 11/17/2015
// Design Name:   OverFlowIndicator
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchOverFlowIndicator.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: OverFlowIndicator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchOverFlowIndicator;

	// Inputs
	reg [7:0] in;

	// Outputs
	wire [7:0] out;
	wire overflowSignal;

	// Instantiate the Unit Under Test (UUT)
	OverFlowIndicator uut (	
		.overflowSignal(overflowSignal),
		.out(out), 
		.in(in)
	);

	integer i;
	
	initial begin
		// Initialize Inputs
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
      for( i = 0; i < (2 ** 8); i = i + 1)
		begin
			#10 in = in + 1;
		end
		// Add stimulus here

	end
      
endmodule

