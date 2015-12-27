`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:31 11/11/2015 
// Design Name: 
// Module Name:    Mux8to1 
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
module Mux8to1
#( parameter BITWIDTH=8 )
(
	DataOut,
	In1,
	In2,
	In3,
	In4,
	In5,
	In6,
	In7,
	In8,
	Sel
);

output [BITWIDTH-1:0] DataOut;
input [BITWIDTH-1:0] In1;
input [BITWIDTH-1:0] In2;
input [BITWIDTH-1:0] In3;
input [BITWIDTH-1:0] In4;
input [BITWIDTH-1:0] In5;
input [BITWIDTH-1:0] In6;
input [BITWIDTH-1:0] In7;
input [BITWIDTH-1:0] In8;
input [2:0] Sel;

wire [(BITWIDTH*8)-1:0] muxIn;

assign muxIn[(BITWIDTH*8)-1:(BITWIDTH*7)] = In1;
assign muxIn[(BITWIDTH*7)-1:(BITWIDTH*6)] = In2;
assign muxIn[(BITWIDTH*6)-1:(BITWIDTH*5)] = In3;
assign muxIn[(BITWIDTH*5)-1:(BITWIDTH*4)] = In4;
assign muxIn[(BITWIDTH*4)-1:(BITWIDTH*3)] = In5;
assign muxIn[(BITWIDTH*3)-1:(BITWIDTH*2)] = In6;
assign muxIn[(BITWIDTH*2)-1:(BITWIDTH)] = In7;
assign muxIn[BITWIDTH-1:0] = In8;


GenericMux #( .SEL_WIDTH(3), .DATA_WIDTH(BITWIDTH) ) mux8to1
(
	.Out(DataOut),
	.In(muxIn),
	.Sel(Sel)
);

endmodule
