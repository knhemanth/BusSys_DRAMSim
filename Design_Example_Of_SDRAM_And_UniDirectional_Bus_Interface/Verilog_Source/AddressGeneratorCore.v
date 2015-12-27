`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:05:07 11/17/2015 
// Design Name: 
// Module Name:    AddressGeneratorCore 
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
`define LOW  1'b0

module AddressGeneratorCore(
	AddrOut,
	AddrIn,
	SizeIn,
	AddrMode,
	BurstLengthConfig
    );
	 
	output [7 : 0] AddrOut;				// Address Output Port
	input [7 : 0] AddrIn;				// Address Input Port
	input [2 : 0] SizeIn;				// Increment Size
	input	AddrMode;						// Address Mode - (0) - Sequential and (1) - Linear
	input [2 : 0] BurstLengthConfig;	// Burst Length Configuration - From Register File
	
	wire [7 : 0] carry_mask_signal;	// Masking Signal for the Carry In's into each stage of the Adder
		
	wire [7 : 0] sizein;
	
	
	/* All Following Modules are specific to current design choices 
	 * Burst Length Configuration Followed:
	 * 000 - 1 Burst
	 * 001 - 2 Bursts
	 * 010 - 4 Bursts
	 * 011 - 8 Bursts
	 * 100 - 16 Bursts
	 * 101 - 32 Bursts
	 * 110 - 64 Bursts
	 * 111 - Page (255 Bursts for Words)
	 */
	
	CarryMask CarryMaskUnit
	(
		.CarryMaskOut(carry_mask_signal),
		.AddrMode(AddrMode),
		.BurstLength(BurstLengthConfig)
	);
		
	assign sizein[2 : 0] = SizeIn;
	assign sizein[7 : 3] = 5'b00000;

	NBitGenericAdderSubtractorWithCin Adder
	(
		 .sum(AddrOut),
		 .cout(),
		 .a(AddrIn),
		 .b(sizein),
		 .sub(`LOW),
		 .cin(carry_mask_signal)
	);


endmodule
