`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:20:46 11/17/2015 
// Design Name: 
// Module Name:    CarryMask 
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

module CarryMask(
	CarryMaskOut,
	AddrMode,
	BurstLength
	);

	output [7 : 0] CarryMaskOut;	// Output Carry Masks Signals
	input AddrMode;					// Addressing Mode - Sequential or Linear
	input [2 : 0] BurstLength;		// Configured Burst Length	
	
	wire [7 : 0] CarryMaskOutWire;
	
	/* Current Masking ignores the 8th bit as the register would roll over anyway. 
	 * The 1st bit is always masked open to allow the initial Add/Sub Selection 
	 * for the NBitGenericAdderSubtractorWithCin.
	 */
	
	assign CarryMaskOutWire[0] = `HIGH;
	
	and(CarryMaskOutWire[1], ~BurstLength[2], ~BurstLength[1], ~BurstLength[0], ~AddrMode);
	and(CarryMaskOutWire[2], ~BurstLength[2], ~BurstLength[1], BurstLength[0], ~AddrMode);
	and(CarryMaskOutWire[3], ~BurstLength[2], BurstLength[1], ~BurstLength[0], ~AddrMode);
	and(CarryMaskOutWire[4], ~BurstLength[2], BurstLength[1], BurstLength[0], ~AddrMode);
	and(CarryMaskOutWire[5], BurstLength[2], ~BurstLength[1], ~BurstLength[0], ~AddrMode);
	and(CarryMaskOutWire[6], BurstLength[2], ~BurstLength[1], BurstLength[0], ~AddrMode);
	and(CarryMaskOutWire[7], BurstLength[2], BurstLength[1], ~BurstLength[0], ~AddrMode);
	
	assign CarryMaskOut[0] = CarryMaskOutWire[0];
	assign CarryMaskOut[1] = ~CarryMaskOutWire[2];
	assign CarryMaskOut[2] = ~CarryMaskOutWire[3];
	assign CarryMaskOut[3] = ~CarryMaskOutWire[4];
	assign CarryMaskOut[4] = ~CarryMaskOutWire[5];
	assign CarryMaskOut[5] = ~CarryMaskOutWire[6];
	assign CarryMaskOut[6] = ~CarryMaskOutWire[7];
	assign CarryMaskOut[7] = 1'b1;

endmodule
