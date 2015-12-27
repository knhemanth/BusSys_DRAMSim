`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:01:00 09/25/2015
// Design Name:   DflipFlop
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_DFlipFlop.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DflipFlop
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_DFlipFlop;

	// Inputs
	reg [0:0] d;
	reg clk;
	reg reset;

	// Outputs
	wire [0:0] q;
	wire [0:0] qbar;

	// Instantiate the Unit Under Test (UUT)
	DflipFlop uut (
		.q(q), 
		.qbar(qbar), 
		.d(d), 
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		d = 1;
		clk = 0;
		reset = 1;

		// Wait 2ns for global reset to finish
		#2 reset = 0;
        
		// Add stimulus here
		
		#1  d = 0;
		#5	 d = 1;
		#2  d = 0;
		#7	 d = 0;
		#13 d = 1;
		
		#2 $finish;
		
	end


	always
	begin
		#0.5 clk = ~clk;
	end
      
endmodule

