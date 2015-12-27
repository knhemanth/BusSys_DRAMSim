`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:03:15 11/29/2015
// Design Name:   sdram_addr_gen
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Final/TestBenchAddrGenUnit.v
// Project Name:  Final
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sdram_addr_gen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define HIGH 1'b1
`define LOW 1'b0	

`define SIZE_B 2'b00
`define SIZE_HW 2'b01
`define SIZE_W 2'b10
`define SIZE_DW 2'b11

`define BURST1 3'b000
`define BURST2 3'b001
`define BURST4 3'b010
`define BURST8 3'b011
`define BURST16 3'b100
`define BURST32 3'b101
`define BURST64 3'b110
`define BURSTPAGE 3'b111

`define ADDR_MODE_SEQ 1'b0
`define ADDR_MODE_LIN 1'b1

module TestBenchAddrGenUnit;

	parameter CLOCK_CYCLE = 30;

	// Inputs
	reg [31:0] AddrIn;
	reg RowAddrLd;
	reg ColAddrLd;
	reg ColCounterEn;
	reg [1:0] SizeIn;
	reg AddrMode;
	reg [2:0] BurstLengthConfig;
	reg We;
	reg Clk;
	reg Rst;

	// Outputs
	wire [7:0] RowAddr;
	wire [7:0] ColAddr;
	wire [1:0] SizeOut;
	
	integer clock_period;
	integer myfile;
	integer TRANSACTION_ID;

	// Instantiate the Unit Under Test (UUT)
	sdram_addr_gen uut (
		.RowAddr(RowAddr), 
		.ColAddr(ColAddr), 
		.SizeOut(SizeOut), 
		.AddrIn(AddrIn), 
		.RowAddrLd(RowAddrLd), 
		.ColAddrLd(ColAddrLd), 
		.ColCounterEn(ColCounterEn), 
		.SizeIn(SizeIn), 
		.AddrMode(AddrMode), 
		.BurstLengthConfig(BurstLengthConfig), 
		.We(We), 
		.Clk(Clk), 
		.Rst(Rst)
	);

	initial begin
		clock_period = 0;
		TRANSACTION_ID = 0;
		myfile = $fopen("./TestingResults/TestBenchAddrGenUnit.txt","w");
		$fdisplay(myfile, "Clock_Period, Transaction, Rst, RowAddrLd, RowAddr, ColAddrLd, ColAddr, SizeIn, AddrMode, BurstLengthConfig, We\n");

	
		// Initialize Inputs
		AddrIn = 0;
		RowAddrLd = 0;
		ColAddrLd = 0;
		ColCounterEn = 0;
		SizeIn = 0;
		AddrMode = 0;
		BurstLengthConfig = 0;
		We = 0;
		Clk = 0;
		Rst = 1;
		
		#(20) Rst = 0;
		
		/* Transaction List : 
			1. Provide Row Address and No RowAddrLd
			2. Provide Row Address and RowAddrLd
			3. Provide Col Address, SizeIn, AddrMode, BurstLengthConfig, We and No ColAddrLd
			4. Provide Col Address, SizeIn, AddrMode, BurstLengthConfig, We and ColAddrLd
		*/
		
// 1. Provide Row Address and No RowAddrLd
		#(CLOCK_CYCLE)
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrIn = 32'h000000AD;
		RowAddrLd = `LOW;
		
// 2. Provide Row Address and RowAddrLd
		#(CLOCK_CYCLE)
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrIn = 32'h000000AD;
		RowAddrLd = `HIGH;

// 2. Only the 8 LSB from AddrIn have been considered		
		#(CLOCK_CYCLE)
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrIn = 32'hABCDABDD;
		RowAddrLd = `HIGH;

// 3. Col Address has been provided. Nothing gets latched in until ColAddrLd and ColCounterEn are high
		#(CLOCK_CYCLE)
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrIn = 32'h00000002;
		RowAddrLd = `LOW;
		ColAddrLd = `LOW;
		ColCounterEn = `LOW;

//	3. Provide Col Address, SizeIn, AddrMode, BurstLengthConfig, We and No ColAddrLd
// Simulates a Write Transaction of Burst 8
		#(CLOCK_CYCLE)
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrIn = 32'h000000A0;
		ColAddrLd = `HIGH;
		ColCounterEn = `HIGH;
		SizeIn = `SIZE_W;
		BurstLengthConfig = `BURST8;
		AddrMode = `ADDR_MODE_LIN;
		We = `HIGH;
		
		// Burst 4
		#(CLOCK_CYCLE)
		ColAddrLd = `LOW;
		
		#(7 * CLOCK_CYCLE)
		ColCounterEn = `LOW;
		We = `LOW;

// During Read Transactions: Col Address is provided along with the Read command from the BIU
// The Value gets latched into the ColAddrRegister at that instance itself. But the addr increment 
// 	happens later during the burst phase. 

// 4. Simulating a Read Transaction of Burst 8 with Sequential Addressing Mode and Size Bytes
// In case of Read Transactions, there is a latency period
		#(CLOCK_CYCLE)
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrIn = 32'h000000A5;
		ColAddrLd = `HIGH;		
		ColCounterEn = `HIGH;
		SizeIn = `SIZE_HW;
		BurstLengthConfig = `BURST8;
		AddrMode = `ADDR_MODE_SEQ;
		We = `LOW;
	
		// Burst 8
		#(CLOCK_CYCLE)
		ColAddrLd = `LOW;
		ColCounterEn = `LOW;	
		
		#(2 * CLOCK_CYCLE)
		ColCounterEn = `HIGH;
		
		#(7 * CLOCK_CYCLE)
		ColCounterEn = `LOW;
		We = `LOW;
		
// 5. Simulating a Read Transaction of Burst 8 with Sequential Addressing Mode and Size Half Words
		#(CLOCK_CYCLE)
		TRANSACTION_ID = TRANSACTION_ID + 1;
		AddrIn = 32'h000000A5;
		ColAddrLd = `HIGH;
		ColCounterEn = `HIGH;
		SizeIn = `SIZE_B;
		BurstLengthConfig = `BURST8;
		AddrMode = `ADDR_MODE_SEQ;
		We = `LOW;
		
		// Burst 8
		#(CLOCK_CYCLE)
		ColAddrLd = `LOW;
		ColCounterEn = `LOW;
		
		// Enavle after Latency Period
		#(2 * CLOCK_CYCLE)
		ColCounterEn = `HIGH;
		
		#(4 * CLOCK_CYCLE)
		ColCounterEn = `LOW;
		
		// When Master goes busy, the controller will stall the addgenunit by pulling its Counter's Enable low.
		#(4 * CLOCK_CYCLE)
		ColCounterEn = `HIGH;

		#(3 * CLOCK_CYCLE)
		ColCounterEn = `LOW;

		#(2 * CLOCK_CYCLE)

		$fclose(myfile);
		$finish;
		// Add stimulus here

	end
	
	always
	begin
		#(CLOCK_CYCLE / 2) Clk = ~Clk;
		
		if(Clk == `HIGH)
		begin
			$fdisplay(myfile, "%1d, %2d, %1d, %1d, %x, %1d, %x, %x, %1d, %x, %1d, %x\n", TRANSACTION_ID, clock_period, Rst, RowAddrLd, RowAddr, ColAddrLd, ColAddr, SizeIn, AddrMode, BurstLengthConfig, We, SizeOut);
			clock_period = clock_period + 1;
		end
	end
      
endmodule

