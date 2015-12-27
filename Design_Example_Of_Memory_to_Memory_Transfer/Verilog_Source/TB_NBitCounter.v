`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:35:22 09/25/2015
// Design Name:   NBitCounter
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_NBitCounter.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: NBitCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CLK_TOGGLE_PERIOD	(25)							// 50ns clock period
`define CLK_CYCLE				(2*`CLK_TOGGLE_PERIOD)	// One clock cycle

module TB_NBitCounter;

	// Inputs
	reg clk;
	reg ld;
	reg en;
	reg rst;
	reg [7:0] start_seq;

	// Outputs
	wire [7:0] count;

	// Instantiate the Unit Under Test (UUT)
	NBitCounter uut (
		.count(count), 
		.clk(clk), 
		.ld(ld), 
		.en(en), 
		.rst(rst), 
		.start_seq(start_seq)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		ld = 0;
		en = 0;
		rst = 1;
		start_seq = 0;

		// Wait 100 ns for global reset to finish
		#(5*`CLK_CYCLE + 10) rst = 0;
		#`CLK_CYCLE en = 1;

	end

	always
	begin
		#`CLK_TOGGLE_PERIOD clk = ~(clk);
	end
      
endmodule
