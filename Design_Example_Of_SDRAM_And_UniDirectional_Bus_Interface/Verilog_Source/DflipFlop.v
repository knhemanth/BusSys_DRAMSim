`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		SJSU, CMPE 240 Fall 2015
// Engineer: 		Hemanth Konanur Nagendra
// 
// Create Date:    19:53:34 09/25/2015 
// Design Name: 	 D Flip-flop
// Module Name:    DflipFlop 
// Project Name: 	 Assignment Projects
// Target Devices: Simulation only
// Tool versions: 
// Description: 	 An N-bit D flip-flop
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DflipFlop
#(parameter BITWIDTH=1, PATH_DELAY=3)		// By default 1 bit flip-flop
(

	q,
	qbar,
	d,
	clk,
	reset

);


output reg [BITWIDTH-1:0] q;
output reg [BITWIDTH-1:0] qbar;
input	 [BITWIDTH-1:0] d;
input	 clk;
input  reset;

always@(posedge clk or posedge reset)		// Asynchronous reset
begin

	if( reset == 1'b1 )
	begin
		q <= #(PATH_DELAY) {BITWIDTH{1'b0}};
		qbar <= #(PATH_DELAY) {BITWIDTH{1'b1}};
	end
	else
	begin
		q <= #(PATH_DELAY) d;
		qbar <= #(PATH_DELAY) ~d;
	end
end

endmodule
