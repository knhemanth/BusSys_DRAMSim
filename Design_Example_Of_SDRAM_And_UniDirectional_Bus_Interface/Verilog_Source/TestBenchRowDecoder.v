`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:45:49 11/12/2015
// Design Name:   RowDecoder
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchRowDecoder.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RowDecoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchRowDecoder;

	// Inputs
	reg [7:0] RowAddrIn;
	reg RAS;
	reg clk;
	reg reset;

	// Outputs
	wire [255:0] RowAddrEn;

	// Instantiate the Unit Under Test (UUT)
	RowDecoder uut (
		.RowAddrEn(RowAddrEn), 
		.RowAddrIn(RowAddrIn), 
		.RAS(RAS), 
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		RowAddrIn = 0;
		RAS = 1;
		clk = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
		
		#10 RAS = 0; RowAddrIn = 4;
		#10 RAS = 1;
        
		// Add stimulus here

	end
	
	always 
	begin
		#5 clk <= ~clk;
	end
      
endmodule

