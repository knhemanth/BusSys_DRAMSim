`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:25:22 11/16/2015 
// Design Name: 
// Module Name:    BankSelectDecoder 
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
module BankSelectDecoder(
	BSOut,
	BSIn,
	CS
    );

	output [3 : 0] BSOut;	// Bank Select Output
	input [1 : 0] BSIn; 		// Bank Select Input
	input CS;					// Active Low Chip Select
	
	or(BSOut_node0, BSIn[1], BSIn[0]);
	or(BSOut_node1, BSIn[1], ~BSIn[0]);
	or(BSOut_node2, ~BSIn[1], BSIn[0]);
	or(BSOut_node3, ~BSIn[1], ~BSIn[0]);
	
	or(BSOut[0], CS, BSOut_node0);
	or(BSOut[1], CS, BSOut_node1);
	or(BSOut[2], CS, BSOut_node2);
	or(BSOut[3], CS, BSOut_node3);

endmodule
