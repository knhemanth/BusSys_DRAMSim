`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:47:26 11/11/2015 
// Design Name: 
// Module Name:    Mux2to1 
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
module Mux2to1
#( parameter BITWIDTH=8 )
(
	DataOut,
	In1,
	In2,
	Sel
);

output [BITWIDTH-1:0] DataOut;
input [BITWIDTH-1:0] In1;
input [BITWIDTH-1:0] In2;
input Sel;

wire [(BITWIDTH*2)-1:0] muxIn;

assign muxIn[(BITWIDTH*2)-1:(BITWIDTH)] = In1;
assign muxIn[BITWIDTH-1:0] = In2;


GenericMux #( .SEL_WIDTH(1), .DATA_WIDTH(BITWIDTH) ) mux2to1
(
	.Out(DataOut),
	.In(muxIn),
	.Sel(Sel)
);

endmodule
