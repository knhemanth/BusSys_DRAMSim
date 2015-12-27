`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		SJSU, CMPE 240
// Engineer: 		
// 
// Create Date:    23:19:28 09/23/2015 
// Design Name: 
// Module Name:    NBitAddSub 
// Project Name: 	 Assignment Project
// Target Devices: Simulation
// Tool versions: 
// Description: 	 Generic adder and subtractor
//
// Dependencies: 	 None
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NBitGenericAdderSubtractorWithCin
#(parameter BITWIDTH=8)	// By default use 8 bits
(
    sum,
    cout,
    a,
    b,
	 sub,
	 cin
);

output	[BITWIDTH-1:0]	sum;
output	cout;
input		[BITWIDTH-1:0]	a;
input		[BITWIDTH-1:0]	b;
input		sub;								// Enable/Disable subtraction
input 	[BITWIDTH-1:0] cin;			// Carry Ins

wire		[BITWIDTH-1:0] bbar;			// Invert for One's complement to subtract

/* 
 * Wires to connect Cins and Couts of each
 * FullAdder in the Ripple adder. Mux wires
 * to select between b and bbar when subtracting [to take 2's complement] 
 */

wire		[BITWIDTH:0]			carry;
wire		[BITWIDTH-1:0]			carryin; 	// Carry In of Each Stage that allows additional Cins
wire		[BITWIDTH-1:0]			MuxOut;		// Output of Mux
wire		[(BITWIDTH*2)-1:0]	MuxIn;		// Input of Mux

assign bbar = ~(b);				// bbar will be 1's complement of b
assign carry[0] = sub;			// if sub is high - this cin will get added with ~b forming 2's complement
assign MuxIn[(2*BITWIDTH)-1:BITWIDTH] = b;	// First half of the mux input is b
assign MuxIn[BITWIDTH-1:0] = bbar;				// Second half of the mux input is bbar

// Instantiate a 2:1 Mux to select between add and subtract function
GenericMux	#(.SEL_WIDTH(1),.DATA_WIDTH(BITWIDTH)) 
SubMux (.Out(MuxOut), .In(MuxIn), .Sel(sub));

genvar 	n;						// generate n instances of FullAdder
generate for( n=0; n<BITWIDTH; n=n+1 )
	begin	: generate_block_adder
			and(carryin[n], cin[n], carry[n]);
			FullAdder FA(.sum(sum[n]), .a(a[n]), .b(MuxOut[n]), .cin(carryin[n]), .cout(carry[n+1]));
	end
endgenerate

// Last carry is still left. We will give it out through Cout
assign cout = carry[BITWIDTH];

endmodule
