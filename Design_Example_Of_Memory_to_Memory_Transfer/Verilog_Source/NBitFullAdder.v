`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 San Jose State University, CMPE 240
// Engineer: 		 Hemanth K N
// 
// Create Date:    13:28:28 09/16/2015 
// Design Name: 		
// Module Name:    NBitFullAdder 
// Project Name: 	 Class Work
// Target Devices: Simulation only
// Tool versions: 
// Description: 	 N-Bit generic Ripple carry adder
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NBitFullAdder
#(parameter BITWIDTH=8, parameter PATH_DELAY=3)	// By default use 8 bits and data path delay of 3 units
(
    sum,
    cout,
    a,
    b
);

output	[BITWIDTH-1:0]	sum;
output	cout;
input		[BITWIDTH-1:0]	a;
input		[BITWIDTH-1:0]	b;

/* 
 * A bunch of wires which connect Cins and Couts of each
 * FullAdder in the Ripple adder.
 */

wire		[BITWIDTH:0]	carry; 

// First instance of adder has a cin = 0

assign carry[0] = 1'b0;

genvar 	n;						// generate n instances of FullAdder
generate for( n=0; n<BITWIDTH; n=n+1 )
	begin	: generate_block_adder
			FullAdder #(PATH_DELAY) FA(.sum(sum[n]), .a(a[n]), .b(b[n]), .cin(carry[n]), .cout(carry[n+1]));
	end
endgenerate

// Last carry is still left. We will give it out through Cout
assign cout = carry[BITWIDTH];

endmodule
