`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:29:31 11/14/2015 
// Design Name: 
// Module Name:    SDRAMBank 
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
module SDRAMBank(
	DataOut,
	CS,
	RAS,
	CAS,
	WE,
	AddrIn,
	DataIn,
	Size,
	tburst,
	tburst_config,
	addr_mode,
	tlat,
	tpre,
	twait,
	twait,
	tcas,
	clk,
	reset
    );
	 
	output [31 : 0] DataOut;	// Data Output port for the SDRAM Bank
	
	input [31 : 0] DataIn;		// Data Input Port for the SDRAM Bank
	input [31 : 0] AddrIn;		// Address Input
	input CS;						// Active Low Chip Select Signal
	input RAS; 						// Active Low Row Address Strobe
	input CAS; 						// Active LowColumn Address Strobe
	input WE; 						// Active Low Write Enable
	input [1 : 0] Size; 			// Size of each Data packet
	input clk;						// Clock Signal
	input reset;					// Reset Signal

	/* Register file inputs */
	input [7:0] tburst;			// Burst length
	input [2:0] tburst_config; // Burst length config
	input addr_mode;				// Addressing mode - sequential or linear
	input [3:0] tlat;				// Read latency
	input [7:0] tpre;				// Wait period after a precharge
	input [7:0] twait;				// Precharge wait period after a transaction
	input [7:0] tcas;				// Cas period

	/* Wires Originating from Bank Controller */
	wire bank_controller_we_out;
	wire bank_controller_re_out;
	wire bank_controller_precharge_out;
	wire bank_controller_activate_out;
	wire bank_controller_busy_signal_out;

	wire [7 : 0] bank_controller_row_addr;
	wire [7 : 0] bank_controller_col_addr;
	wire [1 : 0] bank_controller_size_out;
	wire [31 : 0] bank_controller_data_out;
	wire bank_controller_re_out_buffered;
	wire select_line_buffer_out;
	
	/* Wires Originating from Bank Memory Core */
	 
	 
	 /* Instance of Bank Controller */
	sdram_controls BankController
	(
		.WeOut(bank_controller_we_out),
		.ReOut(bank_controller_re_out),
		.PrechargeOut(bank_controller_precharge_out),
		.ActivateOut(bank_controller_activate_out),
		.BusySignalOut(bank_controller_busy_signal_out),
		.RowAddr(bank_controller_row_addr),
		.ColAddr(bank_controller_col_addr),
		.SizeOut(bank_controller_size_out),
		.CS(CS),
		.RAS(RAS), 
		.CAS(CAS),
		.WeIn(WE),
		.AddrIn(AddrIn),
		.SizeIn(Size),
		.tburst(tburst),
		.tburst_config(tburst_config),
		.addr_mode(addr_mode),
		.tlat(tlat),
		.tpre(tpre),
		.twait(twait),
		.tcas(tcas),
		.Clk(clk),
		.Rst(reset) 
		
	);

	/* Instance of SDRAM Bank Memory Core */
	SDRAMMemoryCore BankMemoryCore(
		.DataOut(bank_controller_data_out),
		.DataIn(DataIn),
		.RowAddr(bank_controller_row_addr),
		.ColAddr(bank_controller_col_addr),	
		.Precharge(bank_controller_precharge_out),
		.Activate(bank_controller_activate_out),
		.Size(bank_controller_size_out),
		.RE(bank_controller_re_out),
		.WE(bank_controller_we_out),
		.BS(CS),
		.clk(clk),
		.reset(reset)
    );
	 
	 /* Mux used as a tristate Buffer - ensures that the SDRAMBank drives the bus only when in Read Mode */
	 Mux2to1 #(.BITWIDTH(32)) data_out_mux
	(
		.DataOut(DataOut),
		.In1(32'bZ),
		.In2(bank_controller_data_out),
		.Sel(bank_controller_re_out_buffered)
	);
	
	Mux2to1 #(.BITWIDTH(1)) select_line_buffer_mux
	(
		.DataOut(bank_controller_re_out_buffered),
		.In1(select_line_buffer_out),
		.In2(bank_controller_re_out),
		.Sel(bank_controller_re_out)
	);
	
	EnDflipFlop #( .BITWIDTH(1) ) select_line_ff
	(
		.q(select_line_buffer_out),
		.qbar(),
		.d(bank_controller_re_out),
		.clk(clk),
		.reset(reset),
		.en(1'b1)
	);
	

endmodule
