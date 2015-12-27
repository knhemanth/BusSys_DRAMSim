`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	San Jose State University - CMPE240
// Engineer: 	Hemanth Konanur Nagendra
// 
// Create Date:    03:20:49 09/12/2015 
// Design Name: 	 Full Adder
// Module Name:    FullAdder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	 A 1-bit Full adder
//
// Dependencies: 	 None
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FullAdder
#(parameter PATH_DELAY=3)		// By default use datapath delay of 3 units
(
    output sum,
    output cout,
    input a,
    input b,
    input cin
);
	 
	 xor(node1,a,b);
	 xor #PATH_DELAY (sum,node1,cin);	// Delay only output
	 and(node2,a,b);
	 or(node3,a,b);
	 and(node4,cin,node3);
	 or #PATH_DELAY (cout,node2,node4);	// Delay only output


endmodule
