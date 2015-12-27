`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:40 11/18/2015 
// Design Name: 
// Module Name:    biu 
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
module biu
(
	CS,
	RAS,
	CAS,
	WE,
	Ready,
	EnWdata,
	EnRdata,
	BS,
	AddrOut,
	SizeOut,
	DataIn,
	AddrIn,
	Control,
	Clk,
	Rst,
	En
);

output CS;
output RAS;
output CAS;
output WE;
output Ready;
output EnWdata;
output EnRdata;
output [1:0] BS;
output [31:0] AddrOut;
output [1:0] SizeOut;

input [31:0] DataIn;
input [31:0] AddrIn;
input [8:0] Control;
input Clk;
input Rst;
input En;

// BIU controller ports
wire StoreReg;
wire [1:0] AddrSel;

// Address register
wire [31:0] current_addr;

// Size register
wire [1:0] current_size;

// Glue logic mux inputs
wire [31:0] mux_row_addr;
wire [31:0] mux_col_addr;
 
//assign SizeOut = Control[2:1]; 
 
// Instance of the BIU controller
biu_controls bus_interface_controller
(
	.CS(CS),
	.RAS(RAS),
	.CAS(CAS),
	.WE(WE),
	.Ready(Ready),
	.StoreReg(StoreReg),
	.EnRdata(EnRdata),
	.EnWdata(EnWdata),
	.AddrSel(AddrSel),
	.Control(Control),
	.AddrIn(AddrIn),
	.DataIn(DataIn),
	.Clk(Clk),
	.Rst(Rst),
	.En(En)
);

// Store address when StoreReg is triggered
EnDflipFlop #(.BITWIDTH(32)) addr_ff
(
	.q(current_addr),
	.qbar(),
	.d(AddrIn),
	.clk(Clk),
	.reset(Rst),
	.en(StoreReg)
);

// Glue logic using mux to select row or coloumn address
Mux4to1 #( .BITWIDTH(32) ) addr_mux
(
	.DataOut(AddrOut),
	.In1(DataIn),								// In all other states send the data line itself which may have program data
	.In2(mux_col_addr),						// Coloumn address
	.In3(mux_row_addr),						// Row address
	.In4(DataIn),
	.Sel(AddrSel)
);

assign mux_col_addr[31:8] = 1'b0;
assign mux_col_addr[7:0] = current_addr[7:0];

assign mux_row_addr[31:8] = 1'b0;
assign mux_row_addr[7:0] = current_addr[15:8];

// During precharge phase send out the BS signal from the input address line.
// Current address will latch only in the next cycle
Mux2to1 #(.BITWIDTH(2)) bs_mux
(
	.DataOut(BS),
	.In1(current_addr[17:16]),
	.In2(AddrIn[17:16]),
	.Sel(StoreReg)
);

Mux2to1 #(.BITWIDTH(2)) size_mux
(
	.DataOut(SizeOut),
	.In1(current_size),
	.In2(Control[2:1]),
	.Sel(StoreReg)
);

EnDflipFlop #(.BITWIDTH(2)) size_ff
(
	.q(current_size),
	.qbar(),
	.d(Control[2:1]),
	.clk(Clk),
	.reset(Rst),
	.en(StoreReg)
);

//assign BS = current_addr[17:16];

endmodule
