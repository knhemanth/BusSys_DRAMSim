`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:06:41 10/19/2015
// Design Name:   ADL
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project2/ADLTestBench.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ADL
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ADLTestBench;

	// Inputs
	reg [31:0] address;

	// Outputs
	wire [3:0] slave_en;

	// Instantiate the Unit Under Test (UUT)
	ADL uut (
		.address(address), 
		.slave_en(slave_en)
	);

	initial begin
		// Initialize Inputs
		address = 0;

		// Wait 100 ns for global reset to finish
		#10 address = 32'h00000000;
		#10 address = 32'h40000000;
		#10 address = 32'h80000000;
		#10 address = 32'hC0000000;


		// Add stimulus here

	end
      
endmodule

