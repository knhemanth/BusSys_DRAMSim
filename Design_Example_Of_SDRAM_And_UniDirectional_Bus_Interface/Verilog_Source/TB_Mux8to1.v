`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:50:00 11/11/2015
// Design Name:   Mux8to1
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_Mux8to1.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mux8to1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_Mux8to1;

	// Inputs
	reg [7:0] In1;
	reg [7:0] In2;
	reg [7:0] In3;
	reg [7:0] In4;
	reg [7:0] In5;
	reg [7:0] In6;
	reg [7:0] In7;
	reg [7:0] In8;
	reg [2:0] Sel;

	// Outputs
	wire [7:0] DataOut;

	// Instantiate the Unit Under Test (UUT)
	Mux8to1 uut (
		.DataOut(DataOut), 
		.In1(In1), 
		.In2(In2), 
		.In3(In3), 
		.In4(In4), 
		.In5(In5), 
		.In6(In6), 
		.In7(In7), 
		.In8(In8), 
		.Sel(Sel)
	);

	initial begin
		// Initialize Inputs
		In1 = 8'hFF;
		In2 = 8'hEE;
		In3 = 8'hDD;
		In4 = 8'hCC;
		In5 = 8'hBB;
		In6 = 8'hAA;
		In7 = 8'h99;
		In8 = 8'h88;
		Sel = 3'h00;
        
		// Add stimulus here
		#20
		Sel = 3'h1;
		#20
		Sel = 3'h2;
		#20
		Sel = 3'h3;
		#20
		Sel = 3'h4;
		#20
		Sel = 3'h5;
		#20
		Sel = 3'h6;
		#20
		Sel = 3'h7;
		
		#20 $finish;

	end
      
endmodule

