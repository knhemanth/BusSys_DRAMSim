`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:55:38 10/19/2015 
// Design Name: 
// Module Name:    SpecializedMux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Module of a specialized Multiplexer using a Generic Mux, Tristate Buffers and a few basic gates.
//		This is used to satisfy the arbiter Ack output conditions in the UniDir Bus with 2 masters and 4 slaves.
// 	Truth Table:
//		Ack[1] Ack[0] BusSignal
//		 	0    0       Z
//			0    1       M1 [High Priority]
//			1    0       M2 [Low Priority]
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SpecializedMux(
	out, // Output Signal
	in1, // Z | Slave 0
	in2, // Input 1 from Master 1 | Slave 1
	in3, // Input 2 from Master 2 | Slave 2
	in4, // Z } Slave 3
	sel // Sel from Arbiter / ADL
    );
	
	parameter DATA_BITWIDTH = 32;

	output [DATA_BITWIDTH - 1 : 0] out;
	input  [DATA_BITWIDTH - 1 : 0] in1;
   input  [DATA_BITWIDTH - 1 : 0] in2;
	input  [DATA_BITWIDTH - 1 : 0] in3;
   input  [DATA_BITWIDTH - 1 : 0] in4;
	input  [1 : 0] sel;
	
	reg  [DATA_BITWIDTH - 1 : 0] regin1;
   reg  [DATA_BITWIDTH - 1 : 0] regin2;
	
	wire [DATA_BITWIDTH - 1 : 0] muxOutput;
	wire [(4 * DATA_BITWIDTH) - 1 : 0] muxInput;
	
	assign muxInput[(1 * DATA_BITWIDTH) - 1 : (          0        )] = in1;
	assign muxInput[(2 * DATA_BITWIDTH) - 1 : (1 * (DATA_BITWIDTH))] = in2;
	assign muxInput[(3 * DATA_BITWIDTH) - 1 : (2 * (DATA_BITWIDTH))] = in3;
	assign muxInput[(4 * DATA_BITWIDTH) - 1 : (3 * (DATA_BITWIDTH))] = in4;
 	
	GenericMux #(.SEL_WIDTH(2), .DATA_WIDTH(DATA_BITWIDTH)) muxInstance(out, muxInput, sel);
	
endmodule
