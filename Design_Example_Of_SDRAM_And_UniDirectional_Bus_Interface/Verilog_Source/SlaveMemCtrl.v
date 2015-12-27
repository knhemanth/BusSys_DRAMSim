`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:43:37 10/15/2015 
// Design Name: 
// Module Name:    SlaveMemCtrl 
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

/* State definition of write FSM */
`define WS_Reset			2'b00
`define WS_Waddr			2'b01
`define WS_Waddr_Data	2'b10
`define WS_WData			2'b11

module SlaveMemCtrl
(
	RdAddr,
	WrAddr,
	Wen,
	Ren,
	MemDataIn,
	RDataOut,
	Ready,
	EN,
	Address,
	Control,
	WData,
	Clk,
	Rst
);

/* PORTS */
output reg [9:0] RdAddr;
output reg [9:0] WrAddr;
output reg Wen;
output reg Ren;
output reg [31:0] MemDataIn;
output reg [31:0] RDataOut;
output reg Ready;

input EN;
input [31:0] Address;
input [8:0] Control;
input [31:0] WData;
input Clk;
input Rst;

/* Internal state and control variables */

wire [1:0] status;
wire [3:0] burst;
wire [1:0] size;
wire write;

reg [31:0] MemRdData;

// 1. FSM for writing data
reg [1:0] write_ps;
reg [1:0] write_ns;

assign status 	= Control[8:7];
assign burst 	= Control[6:3];
assign size		= Control[2:1];
assign write	= Control[0];

// Instantiate the memory core here

SlaveMemCore #(.ADDRWIDTH(10)) Slave1(
	.DataOut(MemRdData), 
	.DataIn(MemDataIn),
	.RdAddrIn(RdAddr),
	.WrAddrIn(WrAddr),
	.Wen(Wen),
	.Ren(Ren)
);

always@(posedge Clk)
begin
	if( Rst == 1'b1 )
		write_ps <= `WS_Reset;
	else if(Rst == 1'b0)
	begin

		write_ps <= write_ns;
		
		/* Drive outputs */
		case(write_ns)
		
		`WS_Reset:
		begin
			Ren <= 1'b0;
			Wen <= 1'b0;
			Ready <= 1'b1;
		end
				
		`WS_Waddr:
		begin
			RdAddr <= Address;
			Ren <= 1'b1;
			Wen <= 1'b0;		// Only address and controls here, nothing to write
			WrAddr <= RdAddr;
		end
			
		`WS_Waddr_Data:
		begin
			MemDataIn <= MemRdData;		// The read data from memory is here
			/* Modify the content here */
			MemDataIn <= WData;			// For now just write whatever is there
			Wen <= 1'b1;
			RdAddr <= Address;
			Ren <= 1'b1;
			WrAddr <= RdAddr;
		end
			
		`WS_WData:
		begin
			/* Nothing to do with address or controls, just write data to memory */
			Ren = 1'b0;
			MemDataIn <= MemRdData;		// The read data from memory is here
			/* Modify the content here */
			MemDataIn <= WData;			// For now just write whatever is there
			Wen <= 1'b1;
		end
		
		endcase

	end
end

/* Drive the next state based on present state and inputs */
always@(write_ps or write or EN)
begin
	if(EN == 1'b1)
	begin
		case(write_ps)
		
			`WS_Reset:
			begin
				if(write == 1'b1)
					write_ns <= `WS_Waddr;
			end
					
			`WS_Waddr:
			begin
				if(write == 1'b1)
					write_ns <= `WS_Waddr_Data;
					
				else if(write == 1'b0)
					write_ns <= `WS_WData;
			end
				
			`WS_Waddr_Data:
			begin
				if(write == 1'b0)
					write_ns <= `WS_WData;
				
				else if(write == 1'b1)
					write_ns <= `WS_Waddr_Data;
			end
				
			`WS_WData:
			begin
				if(write == 1'b1)
					write_ns <= `WS_Waddr;
					
				else if(write == 1'b0)
					write_ns <= `WS_Reset;
			end
		endcase
	end
end

endmodule
