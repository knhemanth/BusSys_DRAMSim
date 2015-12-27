`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:08:19 11/13/2015
// Design Name:   RowToColConverter
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchRowToColConverter.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RowToColConverter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`define B 2'b00
`define HW 2'b01
`define W 2'b10
`define HIGH 1'b1
`define LOW 1'b0

module TestBenchSDRAMMemoryCore;

	parameter CLOCK_CYCLE = 30;

	// Inputs
	reg [31:0] DataIn;
	reg [7 : 0] ColAddr;
	reg [7 : 0] RowAddr;
	reg Precharge;
	reg Activate;
	reg [1:0] Size;
	reg RE;
	reg WE;
	reg BS;
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] DataOut;

	// Instantiate the Unit Under Test (UUT)
	SDRAMMemoryCore uut (
		.DataOut(DataOut), 
		.DataIn(DataIn), 
		.RowAddr(RowAddr), 
		.ColAddr(ColAddr), 
		.Precharge(Precharge), 
		.Activate(Activate), 
		.Size(Size), 
		.RE(RE), 
		.WE(WE), 
		.BS(BS),
		.clk(clk),
		.reset(reset)
	);

	integer myfile;
	integer clkPeriod;

	initial begin
		// Writing to File
		myfile = $fopen("../TestBenchLogs/TestBenchSDRAMMemoryCore.txt", "w");
		$fmonitor(myfile, "clk, reset, Precharge, Activate, RE, WE, BS, Size, RowAddr, ColAddr, DataIn, DataOut\n");
		clkPeriod = 0;
	
		// Initialize Inputs
		DataIn = 32'b0;
		ColAddr = 8'bz;
		RowAddr = 8'bz;
		Precharge = 1'bz;
		Activate = 1'bz;
		Size = 2'bz;
		RE = 1'bZ;
		WE = 1'bZ;
		BS = `HIGH; // Default State - De-select Chip
		clk = 0;
		reset = `HIGH;
		
		#20
		reset = `LOW;
		
	/*
		Summary of Test Bench:
			All transactions assumes the following 
			TPre = 3
			TCas = 3
			TLat = 3
			TWait = 4
				
			Transaction 1 : Write, Bytes, Burst 2 into Row Address 8'b00 
			and Column Address 8'b00 and 8'b01.
			
			Transaction 2 : Write, Half Words, Burst 1 into Row Address 8'b00 
			and Column Address 8'b02.
			
			Transaction 3 : Write, Words, Burst 4 into Row Address 8'b00 
			and Column Address 8'b08, 8'b0C, 8'b10, 8'b14.
			
			Transaction 4 : Read, Bytes, Burst 2 from Row Address 8'b00 
			and Column Address 8'b00, 8'b01.
			
			Transaction 5 : Read, Half Words, Burst 4 from Row Address 8'b00 
			and Column Address 8'b00, 8'b02.
			
			Transaction 6 : Read, Word, Burst 1 from Row Address 8'b00 
			and Column Address 8'b08 onwards.
	 */

// Transaction 1 - Write
		// Precharge
		#(CLOCK_CYCLE) Precharge = `HIGH; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `LOW;
		//TPre = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Activate
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `HIGH; RE = `LOW; WE = `LOW; RowAddr = 0; BS = `LOW;
		// TCAS = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Write
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `HIGH; ColAddr = 8'h00; DataIn = 32'h11223344; Size = `B;
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `HIGH; ColAddr = 8'h01; DataIn = 32'hABABABAB; Size = `B;
		// TWait = 4 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; DataIn = 32'hZ;
		#(3 * CLOCK_CYCLE)
		
// Transaction 2 - Write
		// Precharge
		#(CLOCK_CYCLE) Precharge = `HIGH; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `LOW;
		//TPre = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Activate
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `HIGH; RE = `LOW; WE = `LOW; RowAddr = 0; BS = `LOW;
		// TCAS = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Write
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `HIGH; ColAddr = 8'h02; DataIn = 32'hDEADBEEF; Size = `HW;
		// TWait = 4 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; DataIn = 32'hZ;
		#(3 * CLOCK_CYCLE)
		
// Transaction 3 - Write
		// Precharge
		#(CLOCK_CYCLE) Precharge = `HIGH; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `LOW;
		//TPre = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Activate
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `HIGH; RE = `LOW; WE = `LOW; RowAddr = 0; BS = `LOW;
		// TCAS = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Write
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `HIGH; ColAddr = 8'h08; DataIn = 32'hEEFFEEFF; Size = `W;
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `HIGH; ColAddr = 8'h0C; DataIn = 32'hAABBAABB; Size = `W;
		// TWait = 4 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; DataIn = 32'hZ;
		#(3 * CLOCK_CYCLE)
		
// Transaction 4 - Read
		// Precharge
		#(CLOCK_CYCLE) Precharge = `HIGH; Activate = `LOW; RE = `LOW; WE = `LOW; 
		// TPre = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Activate
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `HIGH; RE = `LOW; WE = `LOW; RowAddr = 8'h00;
		// TCAS = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW;
		#(2 * CLOCK_CYCLE)
		
		// TLatency = 3 Cycles
		#(3 * CLOCK_CYCLE)
		
		// Read
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `HIGH; WE = `LOW; ColAddr = 8'h00; Size = `B; 
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `HIGH; WE = `LOW; ColAddr = 8'h01; Size = `B; 
		
		// TWait = 4 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; DataIn = 32'hZ;
		#(3 * CLOCK_CYCLE)
		
// Transaction 5 - Read
		// Precharge
		#(CLOCK_CYCLE) Precharge = `HIGH; Activate = `LOW; RE = `LOW; WE = `LOW; 
		// TPre = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Activate
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `HIGH; RE = `LOW; WE = `LOW; RowAddr = 8'h00;
		// TCAS = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW;
		#(2 * CLOCK_CYCLE)
		
		// TLatency = 3 Cycles
		#(3 * CLOCK_CYCLE)
		
		// Read
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `HIGH; WE = `LOW; ColAddr = 8'h00; Size = `HW; 
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `HIGH; WE = `LOW; ColAddr = 8'h02; Size = `HW; 
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `HIGH; WE = `LOW; ColAddr = 8'h04; Size = `HW; 
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `HIGH; WE = `LOW; ColAddr = 8'h06; Size = `HW; 
		
		// TWait = 4 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; DataIn = 32'hZ;
		#(3 * CLOCK_CYCLE)
		
// Transaction 6 - Read
		// Precharge
		#(CLOCK_CYCLE) Precharge = `HIGH; Activate = `LOW; RE = `LOW; WE = `LOW; 
		// TPre = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; Size = 2'bZ; BS = `HIGH;
		#(2 * CLOCK_CYCLE)
		
		// Activate
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `HIGH; RE = `LOW; WE = `LOW; RowAddr = 8'h00;
		// TCAS = 3 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW;
		#(2 * CLOCK_CYCLE)
		
		// TLatency = 3 Cycles
		#(3 * CLOCK_CYCLE)
		
		// Read
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `HIGH; WE = `LOW; ColAddr = 8'h08; Size = `W; 
		
		// TWait = 4 Cycles
		#(CLOCK_CYCLE) Precharge = `LOW; Activate = `LOW; RE = `LOW; WE = `LOW; DataIn = 32'hZ;
		#(3 * CLOCK_CYCLE)
		
		$fclose(myfile);
		$finish;
		
	end
	
	always
	begin
		#(CLOCK_CYCLE / 2) clk = ~clk;
		
		if(clk == `HIGH)
		begin
			$fdisplay(myfile, "%d, %x, %x, %x, %x, %x, %x, %x, %x, %x, %x, %x\n", clkPeriod, reset, Precharge, Activate, RE, WE, BS, Size, RowAddr, ColAddr, DataIn, DataOut);
			clkPeriod = clkPeriod + 1;
		end
	end
endmodule

