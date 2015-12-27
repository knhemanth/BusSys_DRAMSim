`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:04 11/13/2015 
// Design Name: 
// Module Name:    sdram_addr_gen 
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

`define BYTE_SIZE			(3'b001)
`define HALFWORD_SIZE	(3'b010)
`define FULLWORD_SIZE	(3'b100)

module sdram_addr_gen
(
	RowAddr,
	ColAddr,
	SizeOut,
	AddrIn,
	RowAddrLd,
	ColAddrLd,
	ColCounterEn,
	SizeIn,
	AddrMode,
	BurstLengthConfig,
	We,
	Clk,
	Rst
);

output [7:0] RowAddr;
output [7:0] ColAddr;
output [1:0] SizeOut;

input [31:0] AddrIn;
input [1:0] SizeIn;
input AddrMode;
input [2:0] BurstLengthConfig;
input RowAddrLd;
input ColAddrLd;
input ColCounterEn;
input We;
input Clk;
input Rst;

wire [2:0] mux_size_out;
wire [2:0] ff_size_out;
wire [7:0] mux_addr_out;
wire [7:0] col_adder_out;
wire [7:0] adder_size_in;
wire [7:0] mux_row_addr_out;
wire [7:0] ff_row_addr;
wire [7:0] ff_col_addr;
wire [7:0] sel_col_addr;
wire mux_row_addr_sel;
wire mux_col_addr_sel;

/* Register to hold Size */

// Multiplexer to select address increments
Mux4to1 #(.BITWIDTH(3)) size_mux
(
	.DataOut(mux_size_out),
	.In1(`BYTE_SIZE),
	.In2(`HALFWORD_SIZE),
	.In3(`FULLWORD_SIZE),
	.In4(`FULLWORD_SIZE),
	.Sel(SizeIn)
);

wire [1 : 0] intermediate_size_out;

// Flip-flop to hold size signal value
EnDflipFlop #(.BITWIDTH(2)) size_ff
(
	.q(intermediate_size_out),
	.qbar(),
	.d(SizeIn),
	.clk(Clk),
	.reset(Rst),
	.en(ColAddrLd)
);

Mux2to1 #(.BITWIDTH(2)) intermediate_size_mux
(
	.DataOut(SizeOut),
	.In1(intermediate_size_out),
	.In2(SizeIn),
	.Sel(ColAddrLd)
);

// Flip-flop to hold translated size value
EnDflipFlop #(.BITWIDTH(3)) translated_size_ff
(
	.q(ff_size_out),
	.qbar(),
	.d(mux_size_out), 
	.clk(Clk),
	.reset(Rst),
	.en(ColAddrLd)
);

/* Adder-register to generate addresses for different sizes */
//NBitAddSub col_addr_adder
//(
//    .sum(col_adder_out),
//    .cout(),
//    .a(ff_col_addr),
//    .b(adder_size_in),
//	 .sub(1'b0)
//);

AddressGeneratorCore AddressGenCore
(
	.AddrOut(col_adder_out),
	.AddrIn(ff_col_addr),
	.SizeIn(ff_size_out),
	.AddrMode(AddrMode),
	.BurstLengthConfig(BurstLengthConfig)
);

assign adder_size_in[2:0] = ff_size_out;
assign adder_size_in[7:3] = 5'b00000;
 
// 2:1 Mux to select address generation and loading
Mux2to1	col_addr_mux
(
	.DataOut(mux_addr_out),
	.In1(col_adder_out),
	.In2(AddrIn[7:0]),
	.Sel(ColAddrLd)
);

// Flip-flop to hold column address
EnDflipFlop #(.BITWIDTH(8)) col_addr_ff
(
	.q(ff_col_addr),
	.qbar(),
	.d(mux_addr_out),
	.clk(Clk),
	.reset(Rst),
	.en(ColCounterEn)
);

// Flip-flop to hold Row address
EnDflipFlop #(.BITWIDTH(8)) row_addr_ff
(
	.q(ff_row_addr),
	.qbar(),
	.d(AddrIn[7:0]),
	.clk(Clk),
	.reset(Rst),
	.en(RowAddrLd)
);


// During activation send out the row address on the bus for activation,
// For precharging send out the latched address
Mux2to1 row_addr_mux
(
	.DataOut(RowAddr),
	.In1(ff_row_addr),
	.In2(AddrIn[7:0]),
	.Sel(mux_row_addr_sel)
);

and(mux_row_addr_sel, RowAddrLd, 1'b1);

Mux2to1 col_addr_sel_mux
(
	.DataOut(sel_col_addr),
	.In1(ff_col_addr),
	.In2(col_adder_out),
	.Sel(We)


);

Mux2to1 col_addr_out_mux
(
	.DataOut(ColAddr),
	.In1(sel_col_addr),
	.In2(AddrIn[7:0]),
	.Sel(mux_col_addr_sel)
);

and(mux_col_addr_sel, ColAddrLd, 1'b1);

endmodule
