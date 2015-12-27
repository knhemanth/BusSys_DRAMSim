`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:21:10 11/09/2015 
// Design Name: 
// Module Name:    RowDecoder 
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

module RowDecoder(
	RowAddrEn,
	RowAddrIn,
	RAS,
	clk,
	reset
    );
	 
	parameter ROW_ADDR_BITWIDTH = 8;
	
	output reg[(2 ** ROW_ADDR_BITWIDTH) - 1 : 0] RowAddrEn; // Row Address Enable Output
	input [ROW_ADDR_BITWIDTH - 1 : 0] RowAddrIn; // Row Address
	input RAS; // Active Low Row Address Strobe Signal
	input clk; // Clock Signal
	input reset; // Reset Signal
	
	reg [ROW_ADDR_BITWIDTH - 1 : 0] RowAddress;
	reg [(2 ** ROW_ADDR_BITWIDTH) - 1 : 0] RowAddressDecoder [(2 ** ROW_ADDR_BITWIDTH - 1) : 0];
	integer index;
	
	initial
	begin
		for(index = 0; index < (2 ** ROW_ADDR_BITWIDTH); index = index + 1)
		begin
				RowAddressDecoder[index] = (2 ** index);
		end
	end
	
	// Combinational Decoder Logic
	always@(RowAddress)
	begin
		RowAddrEn = RowAddressDecoder[RowAddress];
	end
	
	always@(posedge clk or reset)
	begin
		if(reset == `HIGH)
		begin
			// Do Reset related stuff here
		end
		else 
		begin
			if(RAS == `LOW)
			begin
				RowAddress <= RowAddrIn; // Assign Row Address 
			end
		end
	end
	 
	 
endmodule
