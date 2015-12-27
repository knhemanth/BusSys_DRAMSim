`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:11 11/16/2015 
// Design Name: 
// Module Name:    SDRAM 
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
module SDRAM(
	Data,	
	AddrIn,
	CS,
	BS,
	RAS,
	CAS,
	WE,
	Size,
	clk, 
	reset
    );

	inout [31 : 0] Data;			// Bi-Directional Input/Output Data Port
	input [31 : 0] AddrIn;		// Input Address Port
	input	CS;						// Active Low Chip Select
	input [1 : 0] BS;				// Active Low Bank Select 
	input RAS;						// Active Low Row Address Strobe
	input CAS; 						// Active Low Column Address Strobe
	input WE;						// Active Low Write Enable
	input [1 : 0] Size;			// Size of Data Packet
	input clk;						// Clock Signal
	input reset;					// Reset Signal
	
	wire [3 : 0] bank_select_signal; // Internal Bank Select Signal
	 
	 /* Register file outputs */
	wire [7:0] tburst;			// Burst length
	wire [2:0] tburst_config;  // Burst length Config
	wire addr_mode;				// Addressing mode - sequential or linear
	wire [3:0] tlat;				// Read latency
	wire [7:0] tpre;				// Wait period after a precharge
	wire [7:0] twait;				// Precharge wait period after a transaction
	wire [7:0] tcas;				// Cas period
	 
	 /* Instance of register file */
	sdram_regfile RegisterFile
	(
		.tburst(tburst),
		.tburst_config(tburst_config),
		.addr_mode(addr_mode),
		.tlat(tlat),
		.tpre(tpre),
		.twait(twait),
		.tcas(tcas),
		.CS(CS),
		.RAS(RAS),
		.CAS(CAS),
		.WeIn(WE),
		.Clk(clk),
		.Rst(reset),
		.AddrIn(AddrIn)
	);
	
	/* Bank Select Logic - Produces an active low bank enable signal. 
	 * Also takes the Chip Enable Signal into consideration
 	 */
	 
	BankSelectDecoder BankSelect
				(
					.BSOut(bank_select_signal),
					.BSIn(BS),
					.CS(CS)
				);
	
	SDRAMBank SDRAM_Bank_0
				(
					.DataOut(Data),
					.CS(bank_select_signal[0]),
					.RAS(RAS),
					.CAS(CAS),
					.WE(WE),
					.AddrIn(AddrIn),
					.DataIn(Data),
					.Size(Size),
					.tburst(tburst),
					.tburst_config(tburst_config),
					.addr_mode(addr_mode),
					.tlat(tlat),
					.tpre(tpre),
					.twait(twait),
					.tcas(tcas),
					.clk(clk),
					.reset(reset)
				);
				
	SDRAMBank SDRAM_Bank_1
				(
					.DataOut(Data),
					.CS(bank_select_signal[1]),
					.RAS(RAS),
					.CAS(CAS),
					.WE(WE),
					.AddrIn(AddrIn),
					.DataIn(Data),
					.Size(Size),
					.tburst(tburst),
					.tburst_config(tburst_config),
					.addr_mode(addr_mode),
					.tlat(tlat),
					.tpre(tpre),
					.twait(twait),
					.tcas(tcas),
					.clk(clk),
					.reset(reset)
				);
				
	SDRAMBank SDRAM_Bank_2
				(
					.DataOut(Data),
					.CS(bank_select_signal[2]),
					.RAS(RAS),
					.CAS(CAS),
					.WE(WE),
					.AddrIn(AddrIn),
					.DataIn(Data),
					.Size(Size),
					.tburst(tburst),
					.tburst_config(tburst_config),
					.addr_mode(addr_mode),
					.tlat(tlat),
					.tpre(tpre),
					.twait(twait),
					.tcas(tcas),
					.clk(clk),
					.reset(reset)
				);

	SDRAMBank SDRAM_Bank_3
				(
					.DataOut(Data),
					.CS(bank_select_signal[3]),
					.RAS(RAS),
					.CAS(CAS),
					.WE(WE),
					.AddrIn(AddrIn),
					.DataIn(Data),
					.Size(Size),
					.tburst(tburst),
					.tburst_config(tburst_config),
					.addr_mode(addr_mode),
					.tlat(tlat),
					.tpre(tpre),
					.twait(twait),
					.tcas(tcas),
					.clk(clk),
					.reset(reset)
				);

endmodule
