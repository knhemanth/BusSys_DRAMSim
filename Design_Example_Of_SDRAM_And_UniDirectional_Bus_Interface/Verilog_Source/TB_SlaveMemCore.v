`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:53:14 10/15/2015
// Design Name:   SlaveMemCore
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_SlaveMemCore.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SlaveMemCore
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_SlaveMemCore;

	// Inputs
	reg [31:0] DataIn;
	reg [7:0] RdAddrIn;
	reg [7:0] WrAddrIn;
	reg Wen;
	reg Ren;

	// Outputs
	wire [31:0] DataOut;

	// Instantiate the Unit Under Test (UUT)
	SlaveMemCore uut (
		.DataOut(DataOut), 
		.DataIn(DataIn), 
		.RdAddrIn(RdAddrIn), 
		.WrAddrIn(WrAddrIn), 
		.Wen(Wen), 
		.Ren(Ren)
	);

	initial begin
		// Initialize Inputs
		DataIn = 0;
		RdAddrIn = 0;
		WrAddrIn = 0;
		Wen = 0;
		Ren = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		#20 DataIn = 100; 
		#25 WrAddrIn = 22; Wen = 1;
		#20 Wen = 0;
		#20 WrAddrIn = 15;
		#25 DataIn = 12; Wen = 1;
		RdAddrIn = 22;
		Ren = 1;
		#25 Wen = 0; Ren = 0;
		
		
		#50 $finish;
        
		// Add stimulus here

	end
      
endmodule

