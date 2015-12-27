`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:46:24 11/09/2015
// Design Name:   ColDecoder
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchColDecoder.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ColDecoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchColDecoder;

	// Inputs
	reg reset;
	reg CAS;
	reg [7:0] ColAddrIn;
	reg clk;

	// Outputs
	wire [7:0] ColAddrOut;

	// Instantiate the Unit Under Test (UUT)
	ColDecoder uut (
		.ColAddrOut(ColAddrOut), 
		.CAS(CAS), 
		.ColAddrIn(ColAddrIn),
		.clk(clk),
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		clk  = 0;
		reset = 0;
		CAS = 1;
		ColAddrIn = 8'hAB;

		#100 reset = 1;
		#30 reset = 0;
		
		#10 CAS = 0;
		#15 CAS = 1;
		
		#100 reset = 1; CAS = 0;
		#10 CAS = 1;
		#20 reset = 0;
        
		// Add stimulus here

	end
      
	always
	begin
		clk <= ~clk;
	end
	
endmodule

