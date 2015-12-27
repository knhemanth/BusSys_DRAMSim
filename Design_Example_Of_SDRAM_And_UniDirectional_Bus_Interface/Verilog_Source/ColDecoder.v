`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:44:52 11/09/2015 
// Design Name: 
// Module Name:    ColDecoder 
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
module ColDecoder(
	ColAddrOut,
	CAS,
	ColAddrIn,
	clk,
	reset
    );
	 
	parameter COL_ADDR_DEPTH = 8; // Number of Bits required to generate the RowAddress
	
	output [COL_ADDR_DEPTH - 1 : 0] ColAddrOut; // Output Row Address
	input reset; // Reset Signal
	input clk; // Clock Signal
	input CAS; // Row Address Strobe Signal
	input [COL_ADDR_DEPTH - 1: 0] ColAddrIn; // Input Row Address 
	
	/*
	EnDflipFlop #(.BITWIDTH(COL_ADDR_DEPTH), .PATH_DELAY(0)) ColDecRegister(
				.q(ColAddrOut),
				.qbar(),
				.d(ColAddrIn),
				.clk(clk),
				.reset(reset),
				.en(1'b1)
				);
	*/
	

	
endmodule
