`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:06:41 11/21/2015
// Design Name:   Slave_BIU_SDRAM
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchSlaveBIUSDRAM.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Slave_BIU_SDRAM
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

`define BURST1 4'b0000
`define BURST2 4'b0001
`define BURST4 4'b0010
`define BURST8 4'b0011
`define BURST16 4'b0100
`define BURST32 4'b0101
`define BURST64 4'b0110
`define BURSTPAGE	4'b0111

`define READ 1'b0
`define WRITE 1'b1

`define S_START 2'b00
`define S_CONT 2'b01
`define S_IDLE 2'b10
`define S_BUSY 2'b11

`define PROGRAM_ADDRESS_SEQUENCE 32'h3FFFFFFF
module TestBenchSlaveBIUSDRAM;
	
	parameter CLOCK_CYCLE = 30;

	// Inputs
	reg [31:0] DataIn;
	reg [31:0] Address;
	reg [8:0] Control;
	reg clk;
	reg reset;
	reg en;
	
	reg readyClk;

	// Outputs
	wire [31:0] DataOut;
	wire Ready;
	
	// Taps for Intermediate Signals
	wire [31:0] AddrInToSDRAM;
	wire EnWdata;
	wire EnRdata;
	wire [31:0] SDRAMData;
	wire [1:0] Size;
	
	assign AddrInToSDRAM = uut.biu_AddrOut;
	assign EnWdata = uut.biu_EnWdata;
	assign EnRdata = uut.biu_EnRdata;
	assign SDRAMData = uut.SDRAM_Data;
	assign Size = uut.biu_SizeOut;
	
	integer i;
	integer TRANSACTION_ID;
	integer CLOCK_PERIOD;
	integer myfile;

	// Instantiate the Unit Under Test (UUT)
	Slave_BIU_SDRAM uut (
		.DataOut(DataOut), 
		.Ready(Ready), 
		.DataIn(DataIn), 
		.Address(Address), 
		.Control(Control), 
		.clk(clk), 
		.reset(reset), 
		.en(en)
	);

	function [2:0] getSizeCount;
	input [1:0]mSize;
	begin
		case(mSize)
			`SIZE_B : getSizeCount = 1;
			`SIZE_HW : getSizeCount = 2;
			`SIZE_W : getSizeCount = 4;
			`SIZE_DW : getSizeCount = 4;
		endcase
	end
	endfunction
	
	function [7:0] getBurstLength;
	input [3:0] mBurstLength;
	begin
		case(mBurstLength)
			`BURST1 : getBurstLength = 1;
			`BURST2 : getBurstLength = 2;
			`BURST4 : getBurstLength = 4;
			`BURST8 : getBurstLength = 8;
			`BURST16 : getBurstLength = 16;
			`BURST32 : getBurstLength = 32;
			`BURST64 : getBurstLength = 64;
			`BURSTPAGE : getBurstLength = 64;
		endcase
	end
	endfunction
	
	always@(posedge clk)
	begin
		if(Ready == `HIGH)
		begin
			readyClk = `HIGH;
		end
		else
		begin
			readyClk = `LOW;
		end
	end

		
	task master_write;
		input [31:0] mAddress;
		input [1:0] mSize;
		input [3:0] mBurst;
		input [31:0] mDataIn;
		begin
			TRANSACTION_ID = TRANSACTION_ID + 1;
			Address = mAddress;
			Control = {{`S_START},{mBurst},{mSize},{`WRITE}};
			
			#(CLOCK_CYCLE)
			while(readyClk != `HIGH)
			begin
				#(CLOCK_CYCLE)
				Address = mAddress;
				Control = {{`S_START},{mBurst},{mSize},{`WRITE}};
			end
			
			DataIn = mDataIn;
				
			if(mBurst != `BURST1)
			begin
				for(i = 1; i < (getBurstLength(mBurst)); i = i + 1)
				begin
					Address = Address + getSizeCount(mSize);
					Control = {{`S_CONT},{mBurst},{mSize},{`WRITE}};
					
					#(CLOCK_CYCLE)
					while(readyClk != `HIGH)
					begin
						#(CLOCK_CYCLE)
						Address = Address + getSizeCount(mSize);
						Control = {{`S_CONT},{mBurst},{mSize},{`WRITE}};
					end
					
					DataIn = DataIn + getSizeCount(mSize);
				end
			end
		end
	endtask

	task master_read;
		input [31:0] mAddress;
		input [1:0] mSize;
		input [3:0] mBurst;
		begin
			TRANSACTION_ID = TRANSACTION_ID + 1;
			Address = mAddress;
			Control = {{`S_START},{mBurst},{mSize},{`READ}};
			
			#(CLOCK_CYCLE)
			while(readyClk != `HIGH)
			begin
				#(CLOCK_CYCLE)
				Address = mAddress;
				Control = {{`S_START},{mBurst},{mSize},{`READ}};
			end
							
			if(mBurst != `BURST1)
			begin
				for(i = 1; i < (getBurstLength(mBurst)); i = i + 1)
				begin
					Address = Address + getSizeCount(mSize);
					Control = {{`S_CONT},{mBurst},{mSize},{`READ}};
					
					#(CLOCK_CYCLE)
					while(readyClk != `HIGH)
					begin
						#(CLOCK_CYCLE)
						Address = Address;
						Control = {{`S_CONT},{mBurst},{mSize},{`READ}};
					end
				end
			end
		end
	endtask


	initial begin
		// File Handling
		TRANSACTION_ID = 0;
		CLOCK_PERIOD = 0;
		
		myfile = $fopen("./TestingResults/TestBench_SlaveBIUSDRAM.txt", "w");
		$fdisplay(myfile, "Transaction ID, Clock Period, reset, en, Address, Control, DataIn, DataOut, Ready\n");
	
		// Initialize Inputs
		DataIn = 32'bX;
		Address = 0;
		Control = 0;
		clk = 0;
		reset = 0;
		en = 0;

		// Initialize Inputs
		/* Control Signals */
		// Control[8 : 7] - Status
		// Control[6 : 3] - Burst
		// Control[2 : 1] - Size
		// Control[0]     - WE
		
		#10 reset = `HIGH;
		#(CLOCK_CYCLE / 2) reset = `LOW; en = `HIGH;
		
//		// Program SDRAM
//		Address = `PROGRAM_ADDRESS_SEQUENCE;
//		Control = {{`S_START},{4'b0},{`SIZE_W},{`WRITE}};
//		
//		// tCAS = 5
//		// tWait = 4
//		// tPre = 3
//		// TLat - 3
//		// Addr Mode - 1 (Linear)
//		// Burst = 3'b010 (Burst 4)
//		
//		#(CLOCK_CYCLE)
//		DataIn = 32'h0504053A;
		
		// Transaction 1 and 2 - Programming to Burst 4
		master_write(`PROGRAM_ADDRESS_SEQUENCE, `SIZE_W, `BURST1, 32'h0303034A);
		master_write(`PROGRAM_ADDRESS_SEQUENCE, `SIZE_W, `BURST1, 32'h0303034A);
	
		// Transaction 3
		master_write(32'h00004AD0, `SIZE_W, `BURST4, 32'h11112222);

		// Transaction 4
		master_read(32'h00004AD0, `SIZE_W, `BURST4);
		
		// Transaction 5 and 6 - Reprogramming To Burst 2
		master_write(`PROGRAM_ADDRESS_SEQUENCE, `SIZE_W, `BURST1, 32'h03030349);
		master_write(`PROGRAM_ADDRESS_SEQUENCE, `SIZE_W, `BURST1, 32'h03030349);
		
		// Transaction 7
		master_write(32'h00014AD0, `SIZE_B, `BURST2, 32'hAABBCCDD);
		
		// Transaction 8
		master_read(32'h00014AD0, `SIZE_B, `BURST2);
		
		// Transaction 9 and 10 - Reprogramming To Burst 8
		master_write(`PROGRAM_ADDRESS_SEQUENCE, `SIZE_W, `BURST1, 32'h03030343);
		master_write(`PROGRAM_ADDRESS_SEQUENCE, `SIZE_W, `BURST1, 32'h03030343);
		
		// Transaction 11
		master_write(32'h00024AD0, `SIZE_HW, `BURST8, 32'hAABBCCDD);
		
		// Transaction 12
		master_read(32'h00024AD0, `SIZE_HW, `BURST8);
		
		#(CLOCK_CYCLE)
		$fclose(myfile);
		$finish;		
		
	end
	
   always   
	begin
		#(CLOCK_CYCLE / 2) clk = ~clk;
		
		if(clk == `HIGH)
		begin
			$fdisplay(myfile, "%3d, %4d, %1d, %1d, 0x%x, 9'b%b, 0x%x, 0x%x, %1d", TRANSACTION_ID, CLOCK_PERIOD, reset, en, Address, Control, DataIn, DataOut, Ready);
			CLOCK_PERIOD = CLOCK_PERIOD + 1;
		end
	end
	
endmodule

