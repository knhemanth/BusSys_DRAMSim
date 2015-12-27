`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:01:48 10/19/2015 
// Design Name: 
// Module Name:    ADL 
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
module ADL(
	address,
	slave_en,
	slave_output_sel
    );
	 
	 input  [31: 0] address;
	 output [3 : 0] slave_en;
	 output [1 : 0] slave_output_sel;

	and(slave_en[0], ~address[31], ~address[30]);
	and(slave_en[1], ~address[31], address[30]);
	and(slave_en[2], address[31], ~address[30]);
	and(slave_en[3], address[31], address[30]);
	
	assign slave_output_sel = address[31 : 30];

endmodule
