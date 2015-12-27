`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 San Jose State University, CMPE240
// Engineer: 		 Hemanth Konanur Nagendra
// 
// Create Date:    20:37:08 09/23/2015 
// Design Name: 	 
// Module Name:    NBitMemoryBlock 
// Project Name: 	 CMPE240 Assignments
// Target Devices: Simulation only
// Tool versions: 
// Description: 	 Generic MxN memory block with minimal ports
//
// Dependencies: 	 None
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NBitMemoryBlock
#(
	parameter MEM_WIDTH  = 8,		// Default memory width is 8 bits
	parameter ADDR_WIDTH = 8,		// Default address width is 8 bits [ so memory depth will be 2^ADDR_WIDTH ]
	parameter PATH_DELAY = 3		// Default data path delay for the output
)
(

	Dout,
	DataIn,
	Addr,
	WE,
	Clk

);

output	[ MEM_WIDTH-1:0 ]		Dout;		// Data out port
input		[ MEM_WIDTH-1:0 ]		DataIn;	// Data in port
input		[ ADDR_WIDTH-1:0 ]	Addr;		// Address input
input		WE;									// Write Enable signal
input		Clk;									// Clock input

reg		[ MEM_WIDTH-1:0 ]		Out_reg;	// Register holding the last output data

/* 
 * The memory block will be a MxN register
 * where M = DATA_WIDTH and N = 2^ADDR_WIDTH
 */
 
 reg	[ MEM_WIDTH-1:0 ] memory_block [ (2**ADDR_WIDTH)-1:0 ];
 
 always@(posedge Clk)
 begin
 
	if( WE )
	begin
	
		memory_block[ Addr ] <= DataIn;			// Write Enable is high, latch in the data
		
	end
	
	else
	begin
	
		Out_reg <= memory_block[ Addr ];			// Write Enable is low, so read out the value
			
	end
 
 end
 
 assign	#PATH_DELAY Dout = Out_reg;

endmodule
