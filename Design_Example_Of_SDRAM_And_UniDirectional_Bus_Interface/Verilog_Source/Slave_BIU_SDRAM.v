`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:30:47 11/21/2015 
// Design Name: 
// Module Name:    Slave_BIU_SDRAM 
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
module Slave_BIU_SDRAM(
	DataOut,
	Ready,
	DataIn,
	Address,
	Control,
	clk,
	reset,
	en
    );

	output [31 : 0] DataOut;		// Data Output Port to Master
	output Ready;						// Ready Signal to Master
	
	input [31 : 0] DataIn;			// Data Input from Master
	input [31 : 0] Address;			// Address from Master
	input [8 : 0] Control;			// Control Signals from Master
	input clk;							// Clock Signal
	input reset;						// Reset Signal
	input en;							// Slave Enable Signal
	
	// Wires used to Connect BIU with SDRAM 
	wire biu_CS;
	wire biu_RAS;
	wire biu_CAS;
	wire biu_WE;
	wire biu_EnWdata;
	wire biu_EnRdata;
	wire [1:0] biu_BS;
	wire [31:0] biu_AddrOut;
	wire [1:0] biu_SizeOut;
	wire [31:0] SDRAM_Data;
	wire [31:0] RDataBufferOut;
	
	// Instance of BIU
	biu BusInsterfaceUnitInstance
	(
		.CS(biu_CS),
		.RAS(biu_RAS),
		.CAS(biu_CAS),
		.WE(biu_WE),
		.Ready(Ready),
		.EnWdata(biu_EnWdata),
		.EnRdata(biu_EnRdata),
		.BS(biu_BS),
		.AddrOut(biu_AddrOut),
		.SizeOut(biu_SizeOut),
		.DataIn(DataIn),
		.AddrIn(Address),
		.Control(Control),
		.Clk(clk),
		.Rst(reset),
		.En(en)
	);
	
	
	// Instance of SDRAM
	SDRAM SDRAMInstance
	(
		.Data(SDRAM_Data),	
		.AddrIn(biu_AddrOut),
		.CS(biu_CS),
		.BS(biu_BS),
		.RAS(biu_RAS),
		.CAS(biu_CAS),
		.WE(biu_WE),
		.Size(biu_SizeOut),
		.clk(clk), 
		.reset(reset)
	);
	
	and(busySignal, Control[8], Control[7]);
	
	or(busyAndEnRData, busySignal, biu_EnRdata);
	or(busyAndEnWData, busySignal, biu_EnWdata);
	
	
	
	EnDflipFlop #( .BITWIDTH(32) ) RDataBuffer
	(
		.q(RDataBufferOut),
		.qbar(),
		.d(SDRAM_Data),
		.clk(clk),
		.reset(reset),
		.en(biu_EnRdata)
	);
	
	// Tristate Buffer Behaviour - implemented using 2 : 1 - 31-bit Mux
	Mux2to1 #( .BITWIDTH(32)) DataOutMux
	(
		.DataOut(DataOut),
		.In1(RDataBufferOut),
		.In2(SDRAM_Data),
		.Sel(biu_EnRdata)
	);

	Mux2to1 #( .BITWIDTH(32)) DataInMux
	(
		.DataOut(SDRAM_Data),
		.In1(32'bZ),
		.In2(DataIn),
		.Sel(biu_EnWdata)
	);
endmodule
