`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:00:41 09/25/2015
// Design Name:   MemTransfer
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_MemTransfer.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MemTransfer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CLK_TOGGLE_PERIOD	(15)							// 30ns clock period
`define CLK_CYCLE				(2*`CLK_TOGGLE_PERIOD)	// One clock cycle
module TB_MemTransfer;

	// Inputs
	reg Clk;
	reg Reset;
	reg [7:0] DataInA;

	// Outputs
	wire [7:0] DataOutB;
	
	// Internal signal taps
	wire [2:0] AddrA;
	wire [7:0] Dout1;
	wire [7:0] Dout2;
	wire [7:0] AddOut;
	wire [7:0] SubOut;
	wire [1:0] AddrB;
	wire WEA;
	wire IncA;
	wire WEB;
	wire IncB;

	// Instantiate the Unit Under Test (UUT)
	MemTransfer uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.DataInA(DataInA), 
		.DataOutB(DataOutB)
	);
	
	assign AddrA = uut.AddrA;
	assign Dout1 = uut.Dout1;
	assign Dout2 = uut.Dout2;
	assign AddOut = uut.AddOut;
	assign SubOut = uut.SubOut;
	assign AddrB = uut.AddrB;
	assign WEA = uut.WEA;
	assign IncA = uut.IncA;
	assign WEB = uut.WEB;
	assign IncB = uut.IncB;

	initial begin
		// Initialize Inputs
		Clk = 1;
		Reset = 1;
		DataInA = 8'bx;
		
		// Wait for the reset to complete and bring down the signal
		#((2*`CLK_CYCLE)+3) Reset = 0;
		
		#`CLK_CYCLE DataInA = 37;
		#`CLK_CYCLE DataInA = 20;
		#`CLK_CYCLE DataInA = 57;
		#`CLK_CYCLE DataInA = 142;
		#`CLK_CYCLE DataInA = 119;
		#`CLK_CYCLE DataInA = 84;
		#`CLK_CYCLE DataInA = 231;
		#`CLK_CYCLE DataInA = 7;
		
		#(12*`CLK_CYCLE)	$finish;
		
	end
	
	always
	begin
		#`CLK_TOGGLE_PERIOD Clk = ~(Clk);
	end
      
endmodule

