`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:05:59 11/14/2015
// Design Name:   SDRAMBank
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchSDRAMBank.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SDRAMBank
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define BURST1 3'b000
`define BURST2 3'b001
`define BURST4 3'b010
`define BURST8 3'b011
`define BURST16 3'b100
`define BURST32 3'b101
`define BURST64 3'b110
`define BURSTPAGE 3'b111

`define SIZE_B 2'b00
`define SIZE_HW 2'b01
`define SIZE_W 2'b10
`define SIZE_DW 2'b11

`define ADDR_MODE_SEQ 1'b0
`define ADDR_MODE_LIN 1'b1

module TestBenchSDRAMBank;

	// Inputs
	reg CS;
	reg RAS;
	reg CAS;
	reg WE;
	reg [31:0] AddrIn;
	reg [31:0] DataIn;
	reg [1:0] Size;
	reg clk;
	reg reset;
	
	reg [7:0] tburst;			// Burst length
	reg [2:0] tburst_config;
	reg [3:0] tlat;				// Read latency
	reg [7:0] tpre;				// Wait period after a precharge
	reg [7:0] twait;				// Precharge wait period after a transaction
	reg [7:0] tcas;
	reg addr_mode;

	integer TRANSACTION_ID;

	integer i;

	task write_to_sdram;
		input [7:0] mtburst;
		input [2:0] mtburst_config;
		input maddr_mode;
		input [2:0] mSize;
		input [31:0] mRowAddrIn;
		input [31:0] mColAddrIn;
		input [31:0] mDataIn;

		begin
			#(CLOCK_CYCLE)
			TRANSACTION_ID = TRANSACTION_ID + 1;
			CS = 1'b0;
			RAS = 1'b0;
			CAS = 1'b1;
			WE = 1'b0;
			tburst = mtburst;		// Burst length
			tburst_config = mtburst_config;
			Size = mSize;
			addr_mode = maddr_mode;
		
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
			RAS = 1'b1;
			CAS = 1'b0;
			WE = 1'b0;
			AddrIn = mColAddrIn;
			DataIn = mDataIn;
			
			if(mtburst_config != `BURST1)
			begin
				for(i = 0; i < (mtburst - 1); i = i + 1)
				begin
					#(CLOCK_CYCLE)
					CS = 1'b1;
					RAS = 1'b1;
					CAS = 1'b1;
					WE = 1'b1;
					DataIn = DataIn + mSize;
				end
			end
		
			// TWait
			#(CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataIn = 32'hz;
			
			#((twait - 1) * CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataIn = 32'hz;
			
		end
	endtask

	task read_from_sdram;
		input [7:0] mtburst;
		input [2:0] mtburst_config;
		input maddr_mode;
		input [2:0] mSize;
		input [31:0] mRowAddrIn;
		input [31:0] mColAddrIn;

		begin
			#(CLOCK_CYCLE)
			TRANSACTION_ID = TRANSACTION_ID + 1;

			CS = 1'b0;
			RAS = 1'b0;
			CAS = 1'b1;
			WE = 1'b0;
			tburst = mtburst;		// Burst length
			tburst_config = mtburst_config;
			Size = mSize;
			addr_mode = maddr_mode;
		
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

			// Read
			#(CLOCK_CYCLE)
			CS = 1'b0;
			RAS = 1'b1;
			CAS = 1'b0;
			WE = 1'b1;
			AddrIn = mColAddrIn;
			
			#(CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			
			#((tlat - 1) * CLOCK_CYCLE)
			
			if(mtburst_config != `BURST1)
			begin
				for(i = 0; i < (mtburst - 1); i = i + 1)
				begin
					#(CLOCK_CYCLE)
					CS = 1'b1;
					RAS = 1'b1;
					CAS = 1'b1;
					WE = 1'b1;
				end
			end
		
			// TWait
			#(CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataIn = 32'hz;
			
			#((twait - 1) * CLOCK_CYCLE)
			CS = 1'b1;
			RAS = 1'b1;
			CAS = 1'b1;
			WE = 1'b1;
			DataIn = 32'hz;
			
		end
	endtask

	// Outputs
	wire [31:0] DataOut;
		
	// Internal nodes

//	wire [7:0] timegen_out;
//	wire [2:0] cntl_state;
//	wire state_cnt_rst;
//	wire AddrGenEn;
//	
//	
//	wire bank_controller_re_out;
//	wire bank_controller_we_out;
//	wire [7 : 0 ] bank_controller_row_addr;
//	wire [7 : 0 ] bank_controller_col_addr;
//	
//	wire [7 : 0]col_adder_out;
	
	parameter CLOCK_CYCLE = 30;
	

	
	// Instantiate the Unit Under Test (UUT)
	SDRAMBank uut (
		.DataOut(DataOut), 
		.CS(CS), 
		.RAS(RAS), 
		.CAS(CAS), 
		.WE(WE), 
		.AddrIn(AddrIn), 
		.DataIn(DataIn), 
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

//	wire [7:0] timegen_out;
//	wire [2:0] cntl_state;
//	wire state_cnt_rst;
//	wire AddrGenEn;
//	
//	
//	wire bank_controller_re_out;
//	wire bank_controller_we_out;
//	wire [7 : 0 ] bank_controller_row_addr;
//	wire [7 : 0 ] bank_controller_col_addr;
//	
//	wire [7 : 0]col_adder_out;
//
//	assign timegen_out = uut.BankController.timegen.timegen_out;
//	assign cntl_state = uut.BankController.cntl_state;
//	assign state_cnt_rst = uut.BankController.timegen.state_cnt_rst;
//	assign AddrGenEn = uut.BankController.AddrGenEn;
//	
//	assign col_adder_out = uut.BankController.AddrGenUnit.col_adder_out;
//	
//	assign bank_controller_re_out = uut.bank_controller_re_out;
//	assign bank_controller_we_out = uut.bank_controller_we_out;
//	assign bank_controller_row_addr = uut.BankController.RowAddr;
//	assign bank_controller_col_addr = uut.BankController.ColAddr;
// 
//	assign size = uut.BankController.AddrGenUnit.intermediate_size_out;s

	integer myfile;
	integer clock_period;

	initial 
	begin
		clock_period = 0;
		TRANSACTION_ID = 0;
	
		myfile = $fopen("./TestingResults/TestBenchSDRAMBank.txt", "w");
		$fwrite(myfile, "ClkPeriod, Reset, Tburst, TBurst Config, Address Mode, TLat, TPre, TWait, TCas, CS, RAS, CAS, WE, AddrIn, SizeIn, DataIn, DataOut\n");
	
		// Initialize Inputs
		CS = 1;
		RAS = 1;
		CAS = 1;
		WE = 1;
		AddrIn = 0;
		DataIn = 0;
		Size = `SIZE_B;
		clk = 0;
		reset = 0;
		
		tburst = 0;		// Burst length
		tburst_config = 0;

		addr_mode = 1;			// Address Mode
		tlat = 4;				// Read latency
		tpre = 3;				// Wait period after a precharge
		twait = 3;				// Precharge wait period after a transaction
		tcas = 3;
		
		reset = 1;
		#20 reset = 0;
			
		/* Transaction List :
		Transaction 1 : Write, Bytes, Burst 1 - 32'h00
		Transaction 2 : Write, Half Words, Burst 2, - 32'h02 32'h04
		Transaction 3 : Write, Words, Burst 4,
		Transaction 4 : Write, Bytes, Burst 8,
		Transaction 5 : Write, Half Words, Burst 16,
		Transaction 6 : Write, Words, Burst 32,
		Transaction 7 : Write, Words, Burst 64,
		Transaction 8 : Read, Bytes, Burst 1
		Transaction 9 : Read, Half Words, Burst 2;
		Transaction 10 : Read, Words, Burst 4;
		Transaction 11 : Read, Words, Burst 8,
		Transaction 12 : Read, Words, Burst 16,
		Transaction 13 : Read, Words, Burst 32,
		Transaction 14 : Read, Words, Burst 64,
		*/

//		// Transaction - Page Write
//		write_to_sdram(255, `BURSTPAGE, `ADDR_MODE_LIN, `SIZE_B, 32'h00, 32'h00, 32'hAABBCCDD);
//		
//		// Transaction - Page Read
//		read_from_sdram(255, `BURSTPAGE, `ADDR_MODE_SEQ, `SIZE_B, 32'h00, 32'h00);
	
		// Transaction 1
		write_to_sdram(1, `BURST1, `ADDR_MODE_LIN, `SIZE_B, 32'h00, 32'h00, 32'h110011FF);
		
		// Transaction 2
		write_to_sdram(2, `BURST2, `ADDR_MODE_LIN, `SIZE_HW, 32'h02, 32'h02, 32'h00000001);
		
		// Transaction 3
		write_to_sdram(4, `BURST4, `ADDR_MODE_LIN, `SIZE_W, 32'h00, 32'h09, 32'h000000A0);
			
		// Transaction 4
		write_to_sdram(8, `BURST8, `ADDR_MODE_SEQ, `SIZE_B, 32'h00, 32'hD5, 32'h000000B0);
		
		// Transaction 5
		write_to_sdram(16, `BURST16, `ADDR_MODE_SEQ, `SIZE_HW, 32'hDA, 32'hB6, 32'h000000B0);
		
		// Transaction 6
		write_to_sdram(32, `BURST32, `ADDR_MODE_SEQ, `SIZE_W, 32'h00, 32'h74, 32'h00000070);

		// Transaction 7
		write_to_sdram(64, `BURST64, `ADDR_MODE_SEQ, `SIZE_B, 32'h00, 32'h30, 32'h0000000);
		
		// Transaction 8
		read_from_sdram(1, `BURST1, `ADDR_MODE_LIN, `SIZE_B, 32'h00, 32'h00);
		
		// Transaction 9
		read_from_sdram(2, `BURST2, `ADDR_MODE_LIN, `SIZE_HW, 32'h02, 32'h02);
		
		// Transaction 10
		read_from_sdram(4, `BURST4, `ADDR_MODE_LIN, `SIZE_W, 32'h00, 32'h09);
		
		// Transaction 11
		read_from_sdram(8, `BURST8, `ADDR_MODE_LIN, `SIZE_B, 32'h0, 32'hD0);
		
		// Transaction 12
		read_from_sdram(16, `BURST16, `ADDR_MODE_SEQ, `SIZE_HW, 32'hDA, 32'hB6);

		// Transaction 13
		read_from_sdram(32, `BURST32, `ADDR_MODE_SEQ, `SIZE_W, 32'h00, 32'h74);

		// Transaction 14
		read_from_sdram(64, `BURST64, `ADDR_MODE_SEQ, `SIZE_B, 32'h00, 32'h30);
		
		$fclose(myfile);
		$finish;
	end
	
	always
	begin 
		
		#(CLOCK_CYCLE / 2) clk = ~clk;
		
		if(clk == 1'b1)
		begin

			$fdisplay(myfile, "%d, %3d, %1d, %3d, %3d, %1d, %3d, %3d, %3d, %3d, %1d, %1d, %1d, %1d, 0x%x, 0x%x, 0x%x, 0x%x\n", 
						TRANSACTION_ID, clock_period, reset, 
						tburst, tburst_config, addr_mode,tlat, tpre, twait, tcas, 
						CS, RAS, CAS, WE, AddrIn, Size, DataIn, DataOut);

			clock_period = clock_period + 1;

		end
	end
      
endmodule

