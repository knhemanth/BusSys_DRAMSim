`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		SJSU, CMPE 240
// Engineer: 		Hemanth Konanur Nagendra
// 
// Create Date:    16:21:08 09/24/2015 
// Design Name: 	 Controller block for homework assignment 1
// Module Name:    ControlBlock1 
// Project Name: 	 Assignments - CMPE 240
// Target Devices: Simulation only
// Tool versions: 
// Description: 	 Controller block based on counter decoder logic
//
// Dependencies: 	 NBitCounter and primitive gates
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define PATH_DELAY	3		// Data path response delay
module ControlBlock1
(
	WEA,
	IncA,
	IncB,
	WEB,
	Reset,
	Clk
	
);

	output WEA;		// Write Enable signal for Memory module A
	output IncA;	// Enable signal for Memory module A address counter
	output IncB;	// Enable signal for Memory module B address counter
	output WEB;		// Write Enable signal for Memory module B
	
	input Reset;	// Reset signal
	input Clk;		// Clock input
	
	wire [4:0]	Counter_out;		// 5-Bit counter output on this bus
	wire Counter_Reset;				// Reset signal to counter
	
	/* 
	 * Instantiate a 5-Bit counter:
	 * Assumptions:
	 * 1. This counter is always enabled
	 * 2. Load is not used to load a known sequence to the counter
	 * 3. So starting sequence is also always set to 0
	 */
	
	NBitCounter #(.COUNT_BITS(5), .PATH_DELAY(`PATH_DELAY)) Counter5Bit
	(.count(Counter_out), .clk(Clk), .ld(1'b0), .en(1'b1), .rst(Counter_Reset), .start_seq(5'b00000));
	
	// Decoder gates

	/* WEA */
	and(nodeWEA1, ~Counter_out[4], ~Counter_out[3], ~Counter_out[2], ~Counter_out[1], Counter_out[0]);
	and(nodeWEA2, ~Counter_out[4], ~Counter_out[3], ~Counter_out[2], Counter_out[1], ~Counter_out[0]);
	and(nodeWEA3, ~Counter_out[4], ~Counter_out[3], ~Counter_out[2], Counter_out[1], Counter_out[0]);
	and(nodeWEA4, ~Counter_out[4], ~Counter_out[3], Counter_out[2], ~Counter_out[1], ~Counter_out[0]);
	and(nodeWEA5, ~Counter_out[4], ~Counter_out[3], Counter_out[2], ~Counter_out[1], Counter_out[0]);
	and(nodeWEA6, ~Counter_out[4], ~Counter_out[3], Counter_out[2], Counter_out[1], ~Counter_out[0]);
	and(nodeWEA7, ~Counter_out[4], ~Counter_out[3], Counter_out[2], Counter_out[1], Counter_out[0]);
	and(nodeWEA8, ~Counter_out[4], Counter_out[3], ~Counter_out[2], ~Counter_out[1], ~Counter_out[0]);
	
	or #(`PATH_DELAY)( WEA, nodeWEA1, nodeWEA2, nodeWEA3, nodeWEA4, nodeWEA5, nodeWEA6, nodeWEA7, nodeWEA8 );
	
	/* IncA */
	and(nodeIncA1, ~Counter_out[4], ~Counter_out[3], ~Counter_out[2], ~Counter_out[1], ~Counter_out[0]);	// Reset
	and(nodeIncA2, Counter_out[4], ~Counter_out[3], ~Counter_out[2], ~Counter_out[1], Counter_out[0]);
	and(nodeIncA3, Counter_out[4], ~Counter_out[3], ~Counter_out[2], Counter_out[1], ~Counter_out[0]);
	and(nodeIncA4, Counter_out[4], ~Counter_out[3], ~Counter_out[2], Counter_out[1], Counter_out[0]);
	
	nor #(`PATH_DELAY)(IncA, nodeIncA1, nodeIncA2, nodeIncA3, nodeIncA4);
	
	/* IncB */
	and(nodeIncB1, ~Counter_out[4], Counter_out[3], Counter_out[2], ~Counter_out[1], ~Counter_out[0]);
	and(nodeIncB2, ~Counter_out[4], Counter_out[3], Counter_out[2], Counter_out[1], ~Counter_out[0]);
	and(nodeIncB3, Counter_out[4], ~Counter_out[3], ~Counter_out[2], ~Counter_out[1], ~Counter_out[0]);
	and(nodeIncB4, Counter_out[4], ~Counter_out[3], ~Counter_out[2], Counter_out[1], ~Counter_out[0]);
	
	or #(`PATH_DELAY)(IncB, nodeIncB1, nodeIncB2, nodeIncB3, nodeIncB4);
	
	/* WEB */
	and(nodeWEB1, ~Counter_out[4], Counter_out[3], ~Counter_out[2], Counter_out[1], Counter_out[0]);
	and(nodeWEB2, ~Counter_out[4], Counter_out[3], Counter_out[2], ~Counter_out[1], Counter_out[0]);
	and(nodeWEB3, ~Counter_out[4], Counter_out[3], Counter_out[2], Counter_out[1], Counter_out[0]);
	and(nodeWEB4, Counter_out[4], ~Counter_out[3], ~Counter_out[2], ~Counter_out[1], Counter_out[0]);
	
	or #(`PATH_DELAY)(WEB, nodeWEB1, nodeWEB2, nodeWEB3, nodeWEB4);
	
	/* Counter reset */
	and(nodeReset1, Counter_out[4], ~Counter_out[3], ~Counter_out[2], Counter_out[1], ~Counter_out[0]);
	
	or(Counter_Reset, nodeReset1, Reset);
	
	
endmodule
