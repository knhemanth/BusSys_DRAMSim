`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:38:50 09/24/2015
// Design Name:   NBitFullAdder
// Module Name:   /media/hemanthkn/Linux_HDD1/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_NBitFullAdder.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: NBitFullAdder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_NBitFullAdder;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;

	// Outputs
	wire [7:0] sum;
	wire cout;
	
	integer i;
	integer j;

	// Instantiate the Unit Under Test (UUT)
	NBitFullAdder uut(
		.sum(sum), 
		.cout(cout), 
		.a(a), 
		.b(b)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here		
		for( i=0; i<256; i=i+1 )
		begin
		
		#10 a= i;
		
			for( j=0; j<256; j=j+1 )
			begin
				#10 b = j;
			end
		end
		
		#10 $finish;
		
	end
      
endmodule

