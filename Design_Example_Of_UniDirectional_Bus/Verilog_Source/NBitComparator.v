`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		SJSU, CMPE 240
// Engineer: 		Hemanth Konanur Nagendra
// 
// Create Date:    20:53:16 09/24/2015 
// Design Name: 
// Module Name:    NBitComparator 
// Project Name: 	 Assignment project
// Target Devices: Simulation only
// Tool versions: 
// Description: 	 A N bit comparator
//
// Dependencies: 	 NBitAddSub
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NBitComparator
#(parameter BITWIDTH=8)	// Default bitwidth is 8
(
	out,
	a,
	b
);

output out;
input [BITWIDTH-1:0] a;
input [BITWIDTH-1:0] b;

wire [BITWIDTH-1:0] sub;	// Subtraction output

/*
 *	If a < b comparator outputs a 1, otherwise a 0 
 */
 
 NBitAddSub #(.BITWIDTH(BITWIDTH)) Comparator
 (
	.sum(sub),		// Sign bit at the end
	.cout(),	// Not used
	.a(a),
	.b(b),
	.sub(1'b1)	// Enable subtraction
 );
 
 assign out = sub[BITWIDTH-1];

endmodule
