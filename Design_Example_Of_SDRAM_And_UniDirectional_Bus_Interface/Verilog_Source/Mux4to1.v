`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:16:35 11/09/2015 
// Design Name: 
// Module Name:    Mux4to1 
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
module Mux4to1
#( parameter BITWIDTH=8 )
(
	DataOut,
	In1,
	In2,
	In3,
	In4,
	Sel
);

output [BITWIDTH-1:0] DataOut;
input [BITWIDTH-1:0] In1;
input [BITWIDTH-1:0] In2;
input [BITWIDTH-1:0] In3;
input [BITWIDTH-1:0] In4;
input [1:0] Sel;

wire [(BITWIDTH*4)-1:0] muxIn;
wire [1:0] muxSel;

assign muxIn[(BITWIDTH*4)-1:(BITWIDTH*3)] = In1;
assign muxIn[(BITWIDTH*3)-1:(BITWIDTH*2)] = In2;
assign muxIn[(BITWIDTH*2)-1:(BITWIDTH)] = In3;
assign muxIn[BITWIDTH-1:0] = In4;


GenericMux #( .SEL_WIDTH(2), .DATA_WIDTH(BITWIDTH) ) mux4to1
(
	.Out(DataOut),
	.In(muxIn),
	.Sel(Sel)
);

endmodule
