`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:54:42 10/17/2015 
// Design Name: 
// Module Name:    EnDflipFlop 
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
module EnDflipFlop
#(parameter BITWIDTH=1, PATH_DELAY=3)		// By default 1 bit flip-flop
(

	q,
	qbar,
	d,
	clk,
	reset,
	en

);


output reg [BITWIDTH-1:0] q;
output reg [BITWIDTH-1:0] qbar;
input	 [BITWIDTH-1:0] d;
input	 clk;
input  reset;
input	 en;

always@(posedge clk)		// Asynchronous reset
begin

	if( reset == 1'b1 )
	begin
		q <= #(PATH_DELAY) {BITWIDTH{1'b0}};
		qbar <= #(PATH_DELAY) {BITWIDTH{1'b1}};
	end
	else
	begin
		if( en == 1'b1 )
		begin
			q <= #(PATH_DELAY) d;
			qbar <= #(PATH_DELAY) ~d;
		end
	end
end

endmodule
