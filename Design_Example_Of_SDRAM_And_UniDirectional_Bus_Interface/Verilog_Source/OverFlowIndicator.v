`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:13:00 11/17/2015 
// Design Name: 
// Module Name:    OverFlowIndicator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define HIGH 1'b1
`define LOW 1'b0

module OverFlowIndicator(
	overflowSignal,
	out,
	in
    );
	
	parameter BITWIDTH = 8;

	output overflowSignal;
	output [BITWIDTH - 1 : 0] out;
	input	[BITWIDTH - 1 : 0] in;
	
	wire [BITWIDTH - 1 : 0] out_node;
	
	assign out_node[0] = `HIGH;	// This bit is always set to High; Initial Carry in Mask to Adder Subtractor Unit
	assign out_node[1] = in[0];
	and(out_node[2], in[0], in[1]);
	and(out_node[3], out[2], in[2]);
	and(out_node[4], out[3], in[3]);
	and(out_node[5], out[4], in[4]);
	and(out_node[6], out[5], in[5]);
	and(out_node[7], out[6], in[6]);

	assign out = out_node;
	
	or(overflowSignal, out_node[1], out_node[2], out_node[3], out_node[4], out_node[5], out_node[6], out_node[7]);
	
endmodule
