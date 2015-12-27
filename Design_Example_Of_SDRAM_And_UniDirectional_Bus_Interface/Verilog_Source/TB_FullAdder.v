`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:17:26 09/24/2015
// Design Name:   FullAdder
// Module Name:   /media/hemanthkn/Linux_HDD1/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_FullAdder.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FullAdder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_FullAdder;

	// Inputs
	reg a;
	reg b;
	reg cin;

	// Outputs
	wire sum;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	FullAdder uut (
		.sum(sum), 
		.cout(cout), 
		.a(a), 
		.b(b), 
		.cin(cin)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		cin = 0;

		// Wait 10 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 a = 0; b = 0; cin = 0;
		#10 a = 0; b = 0; cin = 1;
		#10 a = 0; b = 1; cin = 0;
		#10 a = 0; b = 1; cin = 1;
		#10 a = 1; b = 0; cin = 0;
		#10 a = 1; b = 0; cin = 1;
		#10 a = 1; b = 1; cin = 0;
		#10 a = 1; b = 1; cin = 1;
		#10 $finish;

	end
      
endmodule

