`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		SJSU, CMPE 240
// Engineer: 		Hemanth Konanur Nagendra
// 
// Create Date:    19:55:21 09/24/2015 
// Design Name: 	 
// Module Name:    MemTransfer 
// Project Name: 	 Assignment Project 1
// Target Devices: Simulation only
// Tool versions: 
// Description: 	 A memory transfer module between 2 simple memory blocks
//
// Dependencies: 	 Big List
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MemTransfer
(

	Clk,
	Reset,
	DataInA,
	DataOutB
);

output [7:0] DataOutB;	// Just for synthesis
input Clk;					// Clock input
input Reset;				// Reset input
input [7:0] DataInA;		// Input data to the first Memory block

/* Internal nodes */
wire [2:0] AddrA;			// Address input to memory module A
wire [1:0] AddrB;			// Address input to memory module B
wire [7:0] DataInB;		// Data input to memory module B
wire [7:0] Dout1;			// Data out from memory module A
wire [7:0] Dout2;			// Data out from memory module A delayed by 1 clock cycle
wire [7:0] AddOut;		// Output of Adder block
wire [7:0] SubOut;		// Output of Subtractor block
wire [15:0] MuxIn;		// Input to add/sub Mux

/* Control signals */
wire IncA;
wire IncB;
wire WEA;
wire WEB;

wire CompOut;			// Comparator out
wire [8:0] CompInA;	// 9-bit comparator input a
wire [8:0] CompInB;	// 9-bit comparator input b

reg  [7:0] DelayData;	// Register to latch delayed data


/* Instantiate all the required modules */

/* Memory module A - 8x8 memory => datawidth is 8, addr width is 3 */
NBitMemoryBlock #(.MEM_WIDTH(8), .ADDR_WIDTH(3)) memoryA
(.Dout(Dout1), .DataIn(DataInA), .Addr(AddrA), .WE(WEA), .Clk(Clk));

/* 3-bit Address Counter for memoryA */
NBitCounter #(.COUNT_BITS(3)) AddrACounter
(
	.count(AddrA),			// Counter output 
	.clk(Clk),				// Clock input to counter 
	.ld(1'b0),				// Load signal - we will not be explicitly loading the counter 
	.en(IncA),				// Enable signal  
	.rst(Reset),			// Counter reset 
	.start_seq(3'b000)	// Nothing to load the counter with
);

/* Memory module B - 8x4 memory => datawidth is 8, addr width is 2 */
NBitMemoryBlock #(.MEM_WIDTH(8), .ADDR_WIDTH(2)) memoryB
(.Dout(DataOutB), .DataIn(DataInB), .Addr(AddrB), .WE(WEB), .Clk(Clk));

/* 2-bit Address Counter for memoryB */
NBitCounter #(.COUNT_BITS(2)) AddrBCounter
(
	.count(AddrB),			// Counter output 
	.clk(Clk),				// Clock input to counter 
	.ld(1'b0),				// Load signal - we will not be explicitly loading the counter 
	.en(IncB),				// Enable signal  
	.rst(Reset),			// Counter reset 
	.start_seq(2'b00)	// Nothing to load the counter with
);

/* Controller block */
ControlBlock1 Controller(.WEA(WEA), .IncA(IncA), .IncB(IncB), .WEB(WEB), .Reset(Reset), .Clk(Clk));

/* 8-bit Flip-Flop */
DflipFlop #(.BITWIDTH(8), .PATH_DELAY(3)) DelayFF(.q(Dout2), .qbar(), .d(Dout1), .clk(Clk), .reset(Reset));

/* 8-bit Adder and subtractor */
NBitAddSub #(.BITWIDTH(8)) Adder
(
	.sum(AddOut),		// Output of adder
	.cout(),				// cout not used
	.a(Dout2),			// Input 'a' of adder
	.b(Dout1),			// Input 'b' of adder
	.sub(1'b0)			// Subtraction disabled - this is an adder instance
);

NBitAddSub #(.BITWIDTH(8)) Subtractor
(
	.sum(SubOut),		// Output of subtractor
	.cout(),				// cout not used
	.a(Dout2),			// Input 'a' of subtractor
	.b(Dout1),			// Input 'b' of subtractor - subtrahend
	.sub(1'b1)			// Subtraction enabled
);

/* 9-bit Comparator - 
 * Since 1 bit turns into a signed bit
 * we need a 9-bit comparator to compare
 * two 8-bit unsigned numbers. Otherwise we can't cover
 * the range. 
 */

// 9th input bit always 0 - used internally by comparator as sign bit
assign CompInA[8] = 1'b0;
assign CompInB[8] = 1'b0;

assign CompInA[7:0] = Dout2;
assign CompInB[7:0] = Dout1; 

NBitComparator #(.BITWIDTH(9)) Comparator
(
	.out(CompOut),		// Comparator Output
	.a(CompInA),
	.b(CompInB)
);

/* 8-bit 2:1 Mux for selecting between adder and subtractor output */
GenericMux AddSubMux(.Out(DataInB), .In(MuxIn), .Sel(CompOut));

assign MuxIn[15:8] = SubOut;		// When Sel = 0 select subtraction
assign MuxIn[7:0] = AddOut;		// When Sel = 1 select addition


/* Behavior of Delay register */
/*
always@(posedge Clk)
begin

	DelayData <= Dout1;

end

assign #3 Dout2 = DelayData;
*/

endmodule
