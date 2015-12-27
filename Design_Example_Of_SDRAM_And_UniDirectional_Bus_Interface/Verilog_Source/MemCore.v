`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:51:48 11/09/2015 
// Design Name: 
// Module Name:    MemCore 
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


module MemCore(
	Out,
	Precharge,
	Activate,
	RowAddress,
	RowBufferIn,
	reset
    );
	 
	parameter ROW_ADDR_DEPTH = 8; // Number of bits required to generate Row Addresses
	parameter COL_ADDR_DEPTH = 6; // Number of bits required to generate Col Addresses
	parameter MEM_ELEM_DEPTH = 32; // Size of each memory element
	 
	output reg [(MEM_ELEM_DEPTH * (2 ** COL_ADDR_DEPTH)) - 1 : 0] Out; // Output of the MemCore. This will be connected to a row Buffer
	input Precharge; // Signal to trigger a Precharge
	input Activate; // Signal to trigger an Activate
	input [(2 ** ROW_ADDR_DEPTH) - 1 : 0] RowAddress; // Row Address 
	input [(MEM_ELEM_DEPTH * (2 ** COL_ADDR_DEPTH) - 1) : 0] RowBufferIn; // Input into the MemCore. This will be connected to a row Buffer
	input reset; // Reset Signal

	reg [(MEM_ELEM_DEPTH * (2 ** COL_ADDR_DEPTH)) - 1 : 0] Mem [(2**ROW_ADDR_DEPTH) - 1 : 0]; // This is the actual Memory

	integer index;

	initial
	begin
	// Initialize Memory to all logic 1s
		for(index = 0; index < (2 ** ROW_ADDR_DEPTH); index = index + 1)
		begin
			Mem[index] = {(2 ** COL_ADDR_DEPTH) {32'hFFFFFFFF}};
		end
	end

	always@(posedge reset)
	begin
		for(index = 0; index < (2 ** ROW_ADDR_DEPTH); index = index + 1)
		begin
			Mem[index] = {(2 ** COL_ADDR_DEPTH) {32'hFFFFFFFF}};
		end
	end

	always@(posedge Precharge or posedge Activate)
	begin
		if(Precharge == `HIGH)
		begin
			// Read data from Input port and place it into the Memory at the address specified by RowAddress
			Mem[RowAddress] <= RowBufferIn;
		end
		
		if(Activate == `HIGH)
		begin
			// Place data at address specified by RowAddress from Memory to output port
			Out <= Mem[RowAddress];
		end
	end
	

endmodule
