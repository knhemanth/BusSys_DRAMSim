`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:52:40 10/16/2015
// Design Name:   Arbiter
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project2/ArbiterTestBench.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Arbiter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ArbiterTestBench;

	// Inputs
	reg [1: 0] Req;
	reg clk;
	reg reset;

	// Outputs
	wire [1 : 0] Ack;
	
	//wire [1:0] PState;
	//wire [1:0] NState;
	
	//assign PState = uut.PState;
	//assign NState = uut.NState;

	// Instantiate the Unit Under Test (UUT)
	Arbiter #(.DELAY(2)) uut (
		.Ack(Ack), 
		.Req(Req), 
		.clk(clk),
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		Req = 0;
		clk = 0;
		reset = 0;
		#10 reset = 1;
		#10 reset = 0;
		
		// Wait 100 ns for global reset to finish
			
		#20 Req = 2'b01;
		#50 Req = 2'b11;
		#150 Req = 2'b10;
		#50 Req = 2'b00;
        
		// Add stimulus here

	end
	
	always
	begin
	#5 clk = ~clk;
   end
endmodule

