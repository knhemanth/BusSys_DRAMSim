`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:32:19 11/08/2015 
// Design Name: 
// Module Name:    sdram_regfile 
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
module sdram_regfile
(
	tburst,
	tburst_config,
	addr_mode,
	tlat,
	tpre,
	twait,
	tcas,
	CS,
	RAS,
	CAS,
	WeIn,
	Clk,
	Rst,
	AddrIn
	
);

/* Output ports */
output [7:0] tburst;			// Burst length
output [2:0] tburst_config; // Burst length config
output addr_mode;				// Addressing mode - sequential or linear
output [3:0] tlat;				// Read latency
output [7:0] tpre;				// Wait period after a precharge
output [7:0] twait;				// Precharge wait period after a transaction
output [7:0] tcas;				// Cas period

/* Input ports */
input CS;						// Chip-select input	- active low
input RAS;						// Row Address Strobe - active low
input CAS;						// Coloum Address Strobe - active low
input WeIn;						// Write/Read enable from master
input Clk;						// Clock input
input Rst;						// Reset input
input [31:0] AddrIn;			// Input address from master

/* Register file

tras = tcas + tburst + twait

 All these periods come in through the address bus when control lines are pulled low.
*/

wire prog_reg_en;				// Register enable for programmable registers
wire one_time_en;				// Enable tRas, tCas and tPre to be programmed only once per boot
wire ote_ff_en;
wire ote_ff_out;

wire [7 : 0] BurstLenWire;

/*
 * The Address In Line is used to program the address mode register and latency values
 * Addr[ 2 : 0 ] - Burst Length Configuration
 * Addr[ 3     ] - Address Mode 
 * Addr[ 7 : 4 ] - Latency Time Period
 * Addr[15 : 8 ] - Precharge Time Period
 * Addr[23 : 16] - Wait Time Period
 * Addr[31 : 24] - CAS Time Period
 */
 
and(prog_reg_en, ~(CS), ~(RAS), ~(CAS), ~(WeIn));

Mux8to1 #(.BITWIDTH(8)) BurstLengthMux 
(
	.DataOut(BurstLenWire),
	.In1(8'd1),
	.In2(8'd2),
	.In3(8'd4),
	.In4(8'd8),
	.In5(8'd16),
	.In6(8'd32),
	.In7(8'd64),
	.In8(8'd255), // Size of Page
	.Sel(AddrIn[2:0])
);

/* Use D-flip flops for register files */
EnDflipFlop #( .BITWIDTH(8) ) reg_burst
(
	.q(tburst),
	.qbar(),
	.d(BurstLenWire),
	.clk(Clk),
	.reset(Rst),
	.en(prog_reg_en)
);

/* Use D-flip flops for register files */
EnDflipFlop #( .BITWIDTH(3) ) reg_burst_config
(
	.q(tburst_config),
	.qbar(),
	.d(AddrIn[2:0]),
	.clk(Clk),
	.reset(Rst),
	.en(prog_reg_en)
);

EnDflipFlop #( .BITWIDTH(1) ) reg_addr_mode
(
	.q(addr_mode),
	.qbar(),
	.d(AddrIn[3]),
	.clk(Clk),
	.reset(Rst),
	.en(prog_reg_en)
);

EnDflipFlop #( .BITWIDTH(4) ) reg_lat
(
	.q(tlat),
	.qbar(),
	.d(AddrIn[7:4]),
	.clk(Clk),
	.reset(Rst),
	.en(one_time_en)
);

EnDflipFlop #( .BITWIDTH(8) ) reg_pre
(
	.q(tpre),
	.qbar(),
	.d(AddrIn[15:8]),
	.clk(Clk),
	.reset(Rst),
	.en(one_time_en)
);

EnDflipFlop #( .BITWIDTH(8) ) reg_wait
(
	.q(twait),
	.qbar(),
	.d(AddrIn[23:16]),
	.clk(Clk),
	.reset(Rst),
	.en(one_time_en)
);

EnDflipFlop #( .BITWIDTH(8) ) reg_cas
(
	.q(tcas),
	.qbar(),
	.d(AddrIn[31:24]),
	.clk(Clk),
	.reset(Rst),
	.en(one_time_en)
);

/* One-time-enable signal */
and(ote_ff_en, ~(ote_ff_out), prog_reg_en);
assign one_time_en = ~(ote_ff_out);

EnDflipFlop ote_ff
(
	.q(ote_ff_out),
	.qbar(),
	.d(1'b1),
	.clk(Clk),
	.reset(Rst),
	.en(ote_ff_en)
);

endmodule
