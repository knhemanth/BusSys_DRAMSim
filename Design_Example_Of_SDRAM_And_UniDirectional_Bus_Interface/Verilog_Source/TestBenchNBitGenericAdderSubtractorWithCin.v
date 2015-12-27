`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:29:15 11/17/2015
// Design Name:   SpecialAdderSubtractor
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchSpecialAdderSubtractor.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SpecialAdderSubtractor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchNBitGenericAdderSubtractorWithCin;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;
	reg sub;
	reg [7:0] cin;

	// Outputs
	wire [7:0] sum;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	NBitGenericAdderSubtractorWithCin uut (
		.sum(sum), 
		.cout(cout), 
		.a(a), 
		.b(b), 
		.sub(sub), 
		.cin(cin)
	);

	integer myfile;
	integer i;

	initial begin
		// Initialize Inputs
		a = 8'b10101100;
		b = 8'b1;
		cin = 8'b11110111;
		sub = 0;
		myfile = $fopen("./TestingResults/TestBench_NBitGenericAdderSubtractorWithCin.txt","w");
		$fdisplay(myfile, "A, B, Cin, Output");
		
		for(i = 0 ; i < 10; i = i + 1)
		begin
			#10
			$fdisplay(myfile, "%x, %x, 8'b%b, %x", a, b, cin, sum);
			a = sum;
		end

		$fclose(myfile);
		$finish;
	end
      
endmodule

