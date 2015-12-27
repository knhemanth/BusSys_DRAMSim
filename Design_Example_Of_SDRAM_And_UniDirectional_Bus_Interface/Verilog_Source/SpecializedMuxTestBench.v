`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:17:24 10/19/2015
// Design Name:   SpecializedMux
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project2/SpecializedMuxTestBench.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SpecializedMux
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SpecializedMuxTestBench;

	// Inputs
	reg [31:0] in1;
	reg [31:0] in2;
	reg [1:0] ack;

	// Outputs
	wire [31:0] out;
	
	//wire [(4 * 32) - 1 : 0] bus;
	//assign bus = uut.muxInstance.connect_bus;

	// Instantiate the Unit Under Test (UUT)
	SpecializedMux uut (
		.out(out), 
		.in1(in1), 
		.in2(in2), 
		.ack(ack)
	);

	initial begin
		// Initialize Inputs
		in1 = 0;
		in2 = 0;
		ack = 2'b10;

		// Wait 100 ns for global reset to finish		
		in1 = 32'hFFAABBCC;
		in2 = 32'h11111111;
		
		#100 ack = 2'b01;
		#100 ack = 2'b00;
		
        
		// Add stimulus here

	end
      
endmodule

