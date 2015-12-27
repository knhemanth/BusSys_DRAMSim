`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:48:41 11/11/2015 
// Design Name: 
// Module Name:    SDRAMBankWrite 
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
`define HIGH 1'b1
`define LOW 1'b0
module SDRAMBankWrite(
	RowBuffer,
	Datain,
	ColAddress,
	WE
    );
	 
	parameter ROW_BUFFER_SIZE = 2048;
	parameter DATA_SIZE = 32;
	
	inout [ROW_BUFFER_SIZE - 1 : 0] RowBuffer; // Inout port connected to a row buffer
	input [DATA_SIZE - 1  : 0] Datain; // Data in port 
	input [COL_ADDR_SIZE - 1 : 0] ColAddress; // Column Address 
	input WE; // Write Enable Signal
	
	reg [ROW_BUFFER_SIZE - 1 : 0] TempRowBuffer; // Temporary Buffer for Writing Data
		
	initial
	begin
		
	end
	
	always@(*)
	begin
		if(WE == `LOW)
		begin
			RowBuffer = 'bZ; // Do not drive the port
		end
		else if(WE == `HIGH)
		begin
			TempRowBuffer = (TempRowBuffer >> ColAddress[COL_ADDR_SIZE - 1 : 2]);
			TempRowBuffer[32 : 0] = Datain;
		end
	end


endmodule
