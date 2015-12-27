`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:40:49 11/16/2015
// Design Name:   SDRAM
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchSDRAM.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SDRAM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define SIZE_B 2'b00
`define SIZE_HW 2'b01 
`define SIZE_W 2'b10

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

`define SDRAM_BANK0 2'b00
`define SDRAM_BANK1 2'b01
`define SDRAM_BANK2 2'b10
`define SDRAM_BANK3 2'b11

`define HIGH 1'b1
`define LOW 1'b0

`define BUSY 1'b1
`define BUSY_NO 1'b0

module TestBenchSDRAM;

	parameter CLOCK_CYCLE = 30;

	// Inputs
	reg [31:0] AddrIn;
	reg CS;
	reg [1:0] BS;
	reg RAS;
	reg CAS;
	reg WE;
	reg [1:0] Size;
	reg clk;
	reg reset;

	// Bidirs
	wire [31:0] Data;
	


	// Instantiate the Unit Under Test (UUT)
	SDRAM uut (
		.Data(Data), 
		.AddrIn(AddrIn), 
		.CS(CS), 
		.BS(BS), 
		.RAS(RAS), 
		.CAS(CAS), 
		.WE(WE), 
		.Size(Size), 
		.clk(clk), 
		.reset(reset)
	);
	
//	// Internal nodes
//	wire [7:0] tburst;			// Burst length
//	wire [2:0] tburst_config;
// 	wire [3:0] tlat;				// Read latency
//	wire [7:0] tpre;				// Wait period after a precharge
//	wire [7:0] twait;				// Precharge wait period after a transaction
//	wire [7:0] tcas;
//	wire [7:0] timegen_out;
//	wire [2:0] cntl_state;
//	wire state_cnt_rst;
//	wire AddrGenEn;
//		
//	wire bank_controller_re_out;
//	wire bank_controller_we_out;
//	wire [7 : 0 ] bank_controller_row_addr;
//	wire [7 : 0 ] bank_controller_col_addr;
//	
//	assign tburst = uut.tburst;
//	assign tburst_config = uut.tburst_config;
//	assign tlat = uut.tlat;
//	assign tpre = uut.tpre;
//	assign twait = uut.twait;
//	assign tcas = uut.tcas;
//	assign timegen_out = uut.SDRAM_Bank_0.BankController.timegen.timegen_out;
//	assign cntl_state = uut.SDRAM_Bank_0.BankController.cntl_state;
//	assign state_cnt_rst = uut.SDRAM_Bank_0.BankController.timegen.state_cnt_rst;
//	assign AddrGenEn = uut.SDRAM_Bank_0.BankController.AddrGenEn;
//		
//	assign bank_controller_re_out = uut.SDRAM_Bank_0.bank_controller_re_out;
//	assign bank_controller_we_out = uut.SDRAM_Bank_0.bank_controller_we_out;
//	assign bank_controller_row_addr = uut.SDRAM_Bank_0.BankController.RowAddr;
//	assign bank_controller_col_addr = uut.SDRAM_Bank_0.BankController.ColAddr;
// 
//	assign size = uut.SDRAM_Bank_0.BankController.AddrGenUnit.intermediate_size_out;
// 
	reg [31 : 0] DataInReg; // Register Used to Send Data to SDRAM
	
	// Internal Signals used for Test Benching
	reg [3:0] tlat;
	reg [7:0] tpre;
	reg [7:0] twait;
	reg [7:0] tcas;
	reg busyNotDone;
	
	assign Data = DataInReg;

	integer myfile;
	integer TRANSACTION_ID;
	integer CLOCK_PERIOD;
	integer i;

	function [7:0] getBurstLength;
	input [2:0] mBurstLength;
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
	
	function [2:0] getSizeIncrement;
	input [1:0] mSize;
	begin
		case(mSize)
			`SIZE_B : getSizeIncrement = 1;
			`SIZE_HW : getSizeIncrement = 2;
			`SIZE_W : getSizeIncrement = 4;
		endcase
	end
	endfunction

	task program_sdram;
		input [7:0] mtcas;
		input [7:0] mtwait;
		input [7:0] mtpre;
		input [3:0] mtlat;
		input maddr_mode;
		input [2:0] mtburst;
		begin
			
			#(CLOCK_CYCLE)
			TRANSACTION_ID = TRANSACTION_ID + 1;
			CS = 0; 
			RAS = 0;
			CAS = 0;
			WE = 0;
			AddrIn = {{mtcas},{mtwait},{mtpre},{mtlat},{maddr_mode},{mtburst}}; // Burst Configuration - 010 = 4 Bursts
			tcas = mtcas;
			tpre = mtpre;
			tlat = mtlat;
			twait = mtwait;

			#(CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
		
		end
	endtask
	
	task write_to_sdram;
		input [2:0] mtburst_config;
		input [1:0] mSize;
		input [1:0] mBS;
		input [31:0] mRowAddrIn;
		input [31:0] mColAddrIn;
		input [31:0] mDataIn;
		input mBusy;
		begin
			#(CLOCK_CYCLE)
			TRANSACTION_ID = TRANSACTION_ID + 1;
			CS = 1'b0;
			BS = mBS;
			RAS = 1'b0;
			CAS = 1'b1;
			WE = 1'b0;
			Size = mSize;
			if(mBusy)
			begin
				busyNotDone = `HIGH;
			end
		
			// TPre - Deselect SDRAM
			#(CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			
			#((tpre - 1) * CLOCK_CYCLE)
			
			// Activate SDRAM
			#(CLOCK_CYCLE)
			CS = 1'b0;
			BS = mBS;
			RAS = 1'b0;
			CAS = 1'b1;
			WE = 1'b1;
			AddrIn = mRowAddrIn; // Row Address 
		
			// TCas - Deselect SDRAM
			#(CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
		
			#((tcas - 1) * CLOCK_CYCLE)
				
			// Write
			#(CLOCK_CYCLE)
			CS = 1'b0;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b0;
			WE = 1'b0;
			AddrIn = mColAddrIn;
			DataInReg = mDataIn;

			if(mtburst_config != `BURST1)
			begin
				if(mBusy)
				begin
					for(i = 0; i < (getBurstLength(mtburst_config) - 1); i = i + 1)
					begin
						if(i == 2)
						begin
							#(CLOCK_CYCLE)
							if(busyNotDone)
							begin
								i = i - 1;
								CS = 1'b1;
								RAS = 1'b1;
								CAS = 1'b0;
								WE = 1'b0;
								busyNotDone = `LOW;
							end
							else
							begin
								#(CLOCK_CYCLE)
								CS = 1'b1;
								RAS = 1'b1;
								CAS = 1'b1;
								WE = 1'b1;
								DataInReg = DataInReg + getSizeIncrement(mSize);
							end
						end
						else
						begin
							#(CLOCK_CYCLE)
							CS = 1'b1;
							RAS = 1'b1;
							CAS = 1'b1;
							WE = 1'b1;
							DataInReg = DataInReg + getSizeIncrement(mSize);
						end
					end
				end
				else
				begin
					for(i = 0; i < (getBurstLength(mtburst_config) - 1); i = i + 1)
					begin
						#(CLOCK_CYCLE)
						CS = 1'b1;
						RAS = 1'b1;
						CAS = 1'b1;
						WE = 1'b1;
						DataInReg = DataInReg + getSizeIncrement(mSize);
					end
				end
			end
		
			// TWait
			#(CLOCK_CYCLE)
			CS = 1'b1;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataInReg = 32'hz;
			
			#((twait - 1) * CLOCK_CYCLE)
			CS = 1'b1;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataInReg = 32'hz;
			
		end
	endtask
	
	task read_from_sdram;
		input [2:0] mtburst_config;
		input [2:0] mSize;
		input [1:0] mBS;
		input [31:0] mRowAddrIn;
		input [31:0] mColAddrIn;
		input mBusy;
		begin
			#(CLOCK_CYCLE)
			TRANSACTION_ID = TRANSACTION_ID + 1;

			CS = 1'b0;
			BS = mBS;
			RAS = 1'b0;
			CAS = 1'b1;
			WE = 1'b0;
			Size = mSize;
			if(mBusy)
			begin
				busyNotDone = `HIGH;
			end
		
			// TPre - Deselect SDRAM
			#(CLOCK_CYCLE)
			CS = 1'b1;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			
			#((tpre - 1) * CLOCK_CYCLE)
			
			// Activate SDRAM
			#(CLOCK_CYCLE)
			CS = 1'b0;
			BS = mBS;
			RAS = 1'b0;
			CAS = 1'b1;
			WE = 1'b1;
			AddrIn = mRowAddrIn; // Row Address 
		
			// TCas - Deselect SDRAM
			#(CLOCK_CYCLE)
			CS = 1'b1;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
		
			#((tcas - 1) * CLOCK_CYCLE)

			// Read
			#(CLOCK_CYCLE)
			CS = 1'b0;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b0;
			WE = 1'b1;
			AddrIn = mColAddrIn;
			
			#(CLOCK_CYCLE)
			CS = 1'b1;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			
			#((tlat - 1) * CLOCK_CYCLE)
			
			if(mtburst_config != `BURST1)
			begin
			if(mBusy)
				begin
					for(i = 0; i < (getBurstLength(mtburst_config) - 1); i = i + 1)
					begin
						if(i == 2)
						begin
							#(CLOCK_CYCLE)
							if(busyNotDone)
							begin
								i = i - 1;
								CS = 1'b1;
								RAS = 1'b1;
								CAS = 1'b0;
								WE = 1'b0;
								busyNotDone = `LOW;
							end
							else
							begin
								#(CLOCK_CYCLE)
								CS = 1'b1;
								RAS = 1'b1;
								CAS = 1'b1;
								WE = 1'b1;
							end
						end
						else
						begin
							#(CLOCK_CYCLE)
							CS = 1'b1;
							RAS = 1'b1;
							CAS = 1'b1;
							WE = 1'b1;
						end
					end
				end
				else
				begin
					for(i = 0; i < (getBurstLength(mtburst_config) - 1); i = i + 1)
					begin
						#(CLOCK_CYCLE)
						CS = 1'b1;
						RAS = 1'b1;
						CAS = 1'b1;
						WE = 1'b1;
					end
				end
//				for(i = 0; i < (getBurstLength(mtburst_config) - 1); i = i + 1)
//				begin
//					#(CLOCK_CYCLE)
//					CS = 1'b1;
//					BS = mBS;
//					RAS = 1'b1;
//					CAS = 1'b1;
//					WE = 1'b1;
//				end
			end
		
			// TWait
			#(CLOCK_CYCLE)
			CS = 1'b1;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataInReg = 32'hz;
			
			#((twait - 1) * CLOCK_CYCLE)
			CS = 1'b1;
			BS = mBS;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataInReg = 32'hz;
			
		end
	endtask
	
	initial begin
		// File Handling Operations
		TRANSACTION_ID = 0;
		CLOCK_PERIOD = 0;
		
		myfile = $fopen("./TestingResults/TestBench_SDRAM.txt", "w");
		$fdisplay(myfile, "TransactionID, Clock Period, ");
	
		CS = 1;
		RAS = 1;
		CAS = 1;
		WE = 1;
		BS = `SDRAM_BANK0; // SDRAM Bank 0
		AddrIn = 32'bZ;
		DataInReg = 32'bZ; // Do Not Drive if not required
		Size = `SIZE_B;
		clk = 0;
		
		reset = 1;
		#20 reset = 0;
		
		// Transaction 1
		program_sdram(8'h3, 8'h3, 8'h3, 4'h4, `ADDR_MODE_SEQ, `BURST4);
		
		// Transaction 2
		write_to_sdram(`BURST4, `SIZE_B, `SDRAM_BANK0, 32'hAA, 32'h05,  32'hAABBCCDD, `BUSY_NO);
		
		// Transaction 3
		read_from_sdram(`BURST4, `SIZE_B, `SDRAM_BANK0, 32'hAA, 32'h05, `BUSY_NO);
		
		// Transaction 4
		program_sdram(8'h3, 8'h3, 8'h3, 4'h4, `ADDR_MODE_LIN, `BURST8);
		
		// Transaction 5
		write_to_sdram(`BURST8, `SIZE_HW, `SDRAM_BANK1, 32'h2D, 32'h06,  32'hAABBCCDD, `BUSY);
		
		// Transaction 6
		read_from_sdram(`BURST8, `SIZE_HW, `SDRAM_BANK1, 32'h2D, 32'h06, `BUSY);
		
		// Transaction 7
		program_sdram(8'h3, 8'h3, 8'h3, 4'h4, `ADDR_MODE_LIN, `BURST16);
		
		// Transaction 8
		write_to_sdram(`BURST16, `SIZE_W, `SDRAM_BANK2, 32'h2D, 32'h06,  32'hAABBCCDD, `BUSY_NO);
		
		// Transaction 9
		read_from_sdram(`BURST16, `SIZE_W, `SDRAM_BANK2, 32'h2D, 32'h06, `BUSY_NO);
		
		// Transaction 10
		program_sdram(8'h3, 8'h3, 8'h3, 4'h4, `ADDR_MODE_LIN, `BURST32);
		
		// Transaction 11
		write_to_sdram(`BURST32, `SIZE_W, `SDRAM_BANK3, 32'h2D, 32'h06,  32'hAABBCCDD, `BUSY_NO);
		
		// Transaction 12
		read_from_sdram(`BURST32, `SIZE_W, `SDRAM_BANK3, 32'h2D, 32'h06, `BUSY_NO);
		
		$fclose(myfile);
		$finish;
	end
	
	always
	begin
		#(CLOCK_CYCLE / 2) clk = ~clk;
		
		if(clk == `HIGH)
		begin
			$fdisplay(myfile, "%3d, %3d, %1d, %1d, 3'b%b, %1d, %1d, %1d, %2d, 0x%x, 0x%x", TRANSACTION_ID, CLOCK_PERIOD, reset, CS, BS, RAS, CAS, WE, Size, AddrIn, Data);
			
			CLOCK_PERIOD = CLOCK_PERIOD + 1;
			
		end
	end
	
      
endmodule

