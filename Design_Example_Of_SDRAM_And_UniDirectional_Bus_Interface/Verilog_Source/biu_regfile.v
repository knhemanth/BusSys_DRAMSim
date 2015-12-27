`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:25:10 11/16/2015 
// Design Name: 
// Module Name:    biu_regfile 
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
module biu_regfile
(
	tburst,
	addr_mode,
	tlat,
	tpre,
	twait,
	tcas,
	prog_mode,
	Clk,
	Rst,
	MasterBusy,
	AddrIn,
	DataIn,
	En
);

/* Output ports */
output [2:0] tburst;			// Burst length
output addr_mode;				// Addressing mode - sequential or linear
output [3:0] tlat;			// Read latency
output [7:0] tpre;			// Wait period after a precharge
output [7:0] twait;			// Precharge wait period after a transaction
output [7:0] tcas;			// Cas period
output prog_mode;				// A high indicates that the register file has entered programming mode

/* Input ports */
input Clk;						// Clock input
input Rst;						// Reset input
input MasterBusy;				// Signal indicating that master is busy
input En;						// Enable this bus interface unit
input [31:0] AddrIn;			// Input address from master
input [31:0] DataIn;			// Data Input from master

/* Register file

tras = tcas + tburst + twait

 All these periods come in through the address bus when control lines are pulled low.
*/

wire data_stat_en;			// 1-bit counter decoder enable
wire data_stat_rst;			// 1-bit counter decoder reset
wire data_stat_dis;			// 1-bit disable programming mode
wire prog_reg_en;				// Register enable for programmable registers
wire one_time_en;				// Enable tRas, tCas and tPre to be programmed only once per boot
wire ote_ff_en;
wire ote_ff_out;

/* Enter programming mode when address on the bus is 0x3FFFFFF (first 2-bits are CS) and this unit is enabled */
and(
data_stat_en, 
AddrIn[29], AddrIn[28],
AddrIn[27], AddrIn[26], AddrIn[25], AddrIn[24],
AddrIn[23], AddrIn[22], AddrIn[21], AddrIn[20],
AddrIn[19], AddrIn[18], AddrIn[17], AddrIn[16],
AddrIn[15], AddrIn[14], AddrIn[13], AddrIn[12],
AddrIn[11], AddrIn[10], AddrIn[9], AddrIn[8],
AddrIn[7], AddrIn[6], AddrIn[5], AddrIn[4],
AddrIn[3], AddrIn[2], AddrIn[1], AddrIn[0],
En
);

/* 
 * Once we enter programming mode, the data will arrive only in the next clock-cycle as per 
 * the bus protocol. We should also be monitoring the bus master status so that it is not busy.
 * Toggle a flip-flop [acts like a 1-bit counter decoder], when we receive command and when counter
 * is '1' and master is not busy, accept the data signals
 */
 
EnDflipFlop #( .BITWIDTH(1) ) reg_data_stat
(
	.q(prog_mode),
	.qbar(),
	.d(1'b1),
	.clk(Clk),
	.reset(data_stat_rst),
	.en(data_stat_en)
);

/* Raise a reset signal whenever the prog_reg_en goes to 1 */
and(data_stat_dis, prog_reg_en, ~(data_stat_en));
or( data_stat_rst, Rst, data_stat_dis);

/* Enable register file when prog_mode is true and master is not busy */
and(prog_reg_en, prog_mode, ~(MasterBusy));

/* Use D-flip flops for register files */
EnDflipFlop #( .BITWIDTH(3) ) reg_burst
(
	.q(tburst),
	.qbar(),
	.d(DataIn[2:0]),
	.clk(Clk),
	.reset(Rst),
	.en(prog_reg_en)
);

EnDflipFlop #( .BITWIDTH(1) ) reg_addr_mode
(
	.q(addr_mode),
	.qbar(),
	.d(DataIn[3]),
	.clk(Clk),
	.reset(Rst),
	.en(prog_reg_en)
);

EnDflipFlop #( .BITWIDTH(4) ) reg_lat
(
	.q(tlat),
	.qbar(),
	.d(DataIn[7:4]),
	.clk(Clk),
	.reset(Rst),
	.en(one_time_en)
);

EnDflipFlop #( .BITWIDTH(8) ) reg_pre
(
	.q(tpre),
	.qbar(),
	.d(DataIn[15:8]),
	.clk(Clk),
	.reset(Rst),
	.en(one_time_en)
);

EnDflipFlop #( .BITWIDTH(8) ) reg_wait
(
	.q(twait),
	.qbar(),
	.d(DataIn[23:16]),
	.clk(Clk),
	.reset(Rst),
	.en(one_time_en)
);

EnDflipFlop #( .BITWIDTH(8) ) reg_cas
(
	.q(tcas),
	.qbar(),
	.d(DataIn[31:24]),
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
