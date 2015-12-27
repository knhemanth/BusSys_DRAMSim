`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:06 11/07/2015 
// Design Name: 
// Module Name:    sdram_controls 
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

// All active-low enable signals

module sdram_controls
(
	WeOut,
	ReOut,
	PrechargeOut,
	ActivateOut,
	BusySignalOut,
	RowAddr,
	ColAddr,
	SizeOut,
	CS,
	RAS,
	CAS,
	WeIn,
	AddrIn,
	SizeIn,
	tburst,
	tburst_config,
	addr_mode,
	tlat,
	tpre,
	twait,
	tcas,
	Clk,
	Rst
	
);


/* Output ports */
output WeOut;					// Write enable signal for the memory core			
output ReOut;					// Read enable signal for the memory core				
output PrechargeOut;			// Precharge Signal for the memory core
output ActivateOut; 			// Activate Signal for the memory core
output [7:0] RowAddr;		// Row Address generated for the memory core
output [7:0] ColAddr;      // Column Address generated for the memory core
output [1:0] SizeOut;		// Size information for the memory core
output BusySignalOut;

/* Input ports */
input CS;						// Chip-select input	- active low
input RAS;						// Row Address Strobe - active low
input CAS;						// Coloum Address Strobe - active low
input WeIn;						// Write/Read enable from master
input Clk;						// Clock input
input Rst;						// Reset input
input [31:0] AddrIn;			// Input address from master
input [1:0] SizeIn;			// Input Size Information from master

/* Register file inputs */
input [7:0] tburst;			// Burst length
input [2:0] tburst_config;	// Burst length config
input addr_mode;				// Addressing mode - sequential or linear
input [3:0] tlat;				// Read latency
input [7:0] tpre;				// Wait period after a precharge
input [7:0] twait;				// Precharge wait period after a transaction
input [7:0] tcas;				// Cas period

/* Timing generator inputs and outputs */
wire [7:0] TimerCountOut;
wire [2:0] cntl_state;
wire tgen_en;

wire timer_ld;
wire RwState;

wire ReWeEnable; // Read Write Enable Signal
wire AddrGenEn;

assign BusySignalOut = tgen_en;

/* Instance of register file */
//sdram_regfile regfile
//(
//	.tburst(tburst),
//	.addr_mode(addr_mode),
//	.tlat(tlat),
//	.tpre(tpre),
//	.twait(twait),
//	.tcas(tcas),
//	.CS(CS),
//	.RAS(RAS),
//	.CAS(CAS),
//	.WeIn(WeIn),
//	.Clk(Clk),
//	.Rst(Rst),
//	.AddrIn(AddrIn)
//);

/* Instance of timing generator */
/* Command order is 
 *	1. CS
 * 2. RAS
 * 3. CAS
 * 4. WeIn
 */
 
/* 1. Stall the timing generator if master indicates a busy state - Command 1100 */
and(tgen_en, CS, RAS, ~(CAS), ~(WeIn));

sdram_timegen timegen
(
	.StateCountOut(cntl_state),
	.TimerCountOut(TimerCountOut),
	.RwState(RwState),
	.TimerLd(timer_ld),
	.tpre(tpre),
	.tcas(tcas),
	.tlat(tlat),
	.tburst(tburst),
	.twait(twait),
	.CS(CS),
	.RAS(RAS),
	.CAS(CAS),
	.WeIn(WeIn),
	.Clk(Clk),
	.Rst(Rst),
	.En(~tgen_en)
);

sdram_enable_gen EnableUnit
(
	.Precharge(PrechargeOut),
	.Activate(ActivateOut),
	.Re(ReOut),
	.We(WeOut),
	.AddrGenEn(AddrGenEn),
	.TimerLd(timer_ld),
	.RwState(RwState),
	.LdState(cntl_state),
	.TimerCount(TimerCountOut),
	.BusySignal(tgen_en),
	.Clk(Clk),
	.Reset(Rst)
);

or(ReWeEnable_node, ReOut, WeOut, AddrGenEn);
and(ReWeEnable, ReWeEnable_node, ~tgen_en); 

sdram_addr_gen AddrGenUnit
(
	.RowAddr(RowAddr),
	.ColAddr(ColAddr),
	.SizeOut(SizeOut),
	.AddrIn(AddrIn),
	.RowAddrLd(ActivateOut),
	.ColAddrLd(AddrGenEn),
	.ColCounterEn(ReWeEnable),
	.SizeIn(SizeIn),
	.AddrMode(addr_mode),
	.BurstLengthConfig(tburst_config),
	.We(WeOut),
	.Clk(Clk),
	.Rst(Rst)
);

endmodule
