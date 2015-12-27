`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:10:00 11/17/2015
// Design Name:   AddressGeneratorCore
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchAddressGeneratorCore.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AddressGeneratorCore
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define SIZE_B 3'h01
`define SIZE_HW 3'h02
`define SIZE_W 3'h04

`define ADDR_MODE_LIN 1'b1
`define ADDR_MODE_SEQ 1'b0

`define BURST1 3'b000
`define BURST2 3'b001
`define BURST4 3'b010
`define BURST8 3'b011
`define BURST16 3'b100
`define BURST32 3'b101
`define BURST64 3'b110
`define BURSTPAGE	3'b111

module TestBenchAddressGeneratorCore;

	// Inputs
	reg [7:0] AddrIn;
	reg [2:0] SizeIn;
	reg AddrMode;
	reg [2:0] BurstLengthConfig;

	// Outputs
	wire [7:0] AddrOut;
	
	wire [7 : 0] CarryMask;
	wire [7 : 0] CarryMaskWire;
	wire overflow_signal;
	
	integer TRANSACTION_ID;
	

	// Instantiate the Unit Under Test (UUT)
	AddressGeneratorCore uut (
		.AddrOut(AddrOut), 
		.AddrIn(AddrIn), 
		.SizeIn(SizeIn), 
		.AddrMode(AddrMode), 
		.BurstLengthConfig(BurstLengthConfig)
	);

	assign CarryMask = uut.carry_mask_signal;
	assign CarryMaskWire = uut.CarryMaskUnit.CarryMaskOutWire;
	//assign overflow_signal = uut.overflow_signal;

	integer i;
	integer myfile;
	
	task generate_address;
		input [7:0] mBurstLength;
		input [2:0] mBurstLengthConfig;
		input mAddrMode;
		input [2:0] mSizeIn;
		input [7:0] mAddrIn;
		
		begin
			#10
			TRANSACTION_ID = TRANSACTION_ID + 1;
			AddrIn = mAddrIn;
			SizeIn = mSizeIn;
			BurstLengthConfig = mBurstLengthConfig;
			AddrMode = mAddrMode;
			
			for(i = 0; i < mBurstLength; i = i + 1)
			begin
				#10 
				$fdisplay(myfile, "%2d, %3d, %x, %1d, %x, %x, %x", TRANSACTION_ID, i, BurstLengthConfig, AddrMode, SizeIn, AddrIn, AddrOut);
				AddrIn = AddrOut;
			end
		end
	endtask

	initial begin
		myfile = $fopen("./TestingResults/TestBench_AddressGeneratorCore.txt", "w");
		$fdisplay(myfile, "TransactionID, AddressPeriod, Burst Mode, Addressing Mode, Size, AddressIn, AddressOut\n");
		
		TRANSACTION_ID = 0;
		
		generate_address(2, `BURST2, `ADDR_MODE_LIN, `SIZE_B, 8'hA4);
		generate_address(4, `BURST4, `ADDR_MODE_LIN, `SIZE_HW, 8'hA6);
		generate_address(8, `BURST8, `ADDR_MODE_LIN, `SIZE_W, 8'hA0);
		generate_address(8, `BURST8, `ADDR_MODE_SEQ, `SIZE_B, 8'hA4);
		generate_address(32, `BURST32, `ADDR_MODE_SEQ, `SIZE_HW, 8'hA6);
		//generate_address(64, `BURST64, `ADDR_MODE_SEQ, `SIZE_W, 8'hA0);
		//generate_address(255, `BURSTPAGE, `ADDR_MODE_SEQ, `SIZE_W, 8'hA0);


		
		$fclose(myfile);
		$finish;
	end
      
endmodule

