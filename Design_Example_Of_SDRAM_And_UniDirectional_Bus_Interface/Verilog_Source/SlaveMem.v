`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:22:01 10/15/2015 
// Design Name: 
// Module Name:    SlaveMem 
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

/*
 *	NOTE: This module assumes that there is a controller giving the correct 
 *       control signals to avoid simultaneous read/write access to same location
 */
 
module SlaveMemCore
#(
	parameter DATAWIDTH = 32,		// 32 bit wide data
	parameter ADDRWIDTH = 8, 		// 10 bit address line ==> 1KB memory
	parameter PROPDELAY = 3			// Propogation delay
)
(
	DataOut,
	DataIn,
	RdAddrIn,
	WrAddrIn,
	Wen,
	Ren
);

/* PORTS */
output reg [DATAWIDTH-1:0] DataOut;	// Data Out port also a register

input		[DATAWIDTH-1:0] DataIn;		// Data in port
input		[ADDRWIDTH-1:0] RdAddrIn;	// Read address in port
input		[ADDRWIDTH-1:0] WrAddrIn;	// Write address in port
input		Wen;								// Write enable signal
input		Ren;								// Read enable signal

/* Memory */

reg 		[DATAWIDTH-1:0] Memory_Core [(2**ADDRWIDTH)-1:0];

/*
 *	This module is a very simple asynchronous word [32 bits] addressable
 * memory. Everytime the address or control changes, the corresponding data
 * is read-out or written into based on the read/write enables. This module
 * will need to be combined with an appropriate controller.
 */
 
 /* Write mechanism */
 always@(DataIn, WrAddrIn, Wen)	// If Wen goes high or if Data/Address changes, we need to write 
 begin
	
	if( Wen == 1'b1 )
		Memory_Core[WrAddrIn] <= DataIn;
	
 end
 
 /* Read mechanism */
 always@(Ren, RdAddrIn)			// For reading, Ren should go high oand address should be given
 begin
 
	if( Ren == 1'b1 )
		DataOut <= #(PROPDELAY) Memory_Core[RdAddrIn];
 
 end
 
 /* There is a problem above. If both Read and write addresses are the same
  * then one location will be accessed simultaneaously which is invalid. Controller
  * has to take care not to issue such controls.
  */

endmodule
