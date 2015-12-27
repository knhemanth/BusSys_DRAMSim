`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:32:33 11/09/2015
// Design Name:   MemCore
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchMemCore.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MemCore
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchMemCore;

	// Inputs
	reg Precharge;
	reg Activate;
	reg [255:0] RowAddress;
	reg [2047:0] RowBufferIn;
	reg reset;

	// Outputs
	wire [2047:0] Out;
	
	// Custom Wires	
	
	// Instantiate the Unit Under Test (UUT)
	MemCore uut (
		.Out(Out), 
		.Precharge(Precharge), 
		.Activate(Activate), 
		.RowAddress(RowAddress), 
		.RowBufferIn(RowBufferIn),
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		Precharge = 0;
		Activate = 0;
		RowAddress = 0;
		RowBufferIn = 0;

		// Wait 100 ns for global reset to finish
		#10 reset = 1'b1;
		#10 reset = 1'b0;
		
		#10 RowAddress = 2; RowBufferIn = {(64){32'hF0F0F0F0}};
      #10 Precharge = 1;
		#10 Precharge = 0;
		#10 Activate = 1;
		// Add stimulus here

	end
      
endmodule

