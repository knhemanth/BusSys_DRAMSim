`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:50:25 10/16/2015 
// Design Name: 
// Module Name:    SlaveMemBlock 
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
module SlaveMemBlock
#(
	parameter DATAWIDTH = 32,
	parameter ADDRWIDTH = 10,
	parameter DELAY = 3
)
(
	DataOut,
	DataIn,
	RdAddr,
	WrAddr,
	Ren,
	Wen,
	Clk
);

output [DATAWIDTH-1:0] DataOut;

input [DATAWIDTH-1:0] DataIn;
input [ADDRWIDTH-1:0] RdAddr;
input [ADDRWIDTH-1:0] WrAddr;

input Ren;
input Wen;
input Clk;

reg [DATAWIDTH-1:0] memory [(2**ADDRWIDTH)-1:0];
reg [DATAWIDTH-1:0] outreg;

integer k;

initial
begin
	for( k=0; k<((2**ADDRWIDTH)); k=k+1)
	begin
		memory[k] = k;
	end
end

/* Write */
always@(posedge Clk)
begin
	if( Wen == 1'b1 )
		memory[WrAddr] <= DataIn;
end

/* Read */
always@(posedge Clk)
begin
	if( Ren == 1'b1 )
		outreg <= #(DELAY) memory[RdAddr];
end

assign DataOut = outreg; 

endmodule
