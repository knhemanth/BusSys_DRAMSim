			`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:00:49 11/13/2015 
// Design Name: 
// Module Name:    RowToColConverter 
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
`define SIZE_BYTE 2'b00
`define SIZE_HALF_WORD 2'b01
`define SIZE_WORD 2'b10

module SDRAMMemoryCore(
	DataOut,
	DataIn,
	RowAddr,
	ColAddr,
	Precharge,
	Activate,
	Size,
	RE,
	WE,
	BS,
	clk,
	reset
    );
	
	// Max is a 64 * 32 Bit Column Buffer/RowBuffer
	
	parameter COL_ADDR_BITWIDTH = 8;
	parameter ROW_ADDR_BITWIDTH = 8;
	parameter COL_ADDR_OFFSET = 2;
	parameter MEM_ELEM_SIZE = 32;
	parameter ROW_BUFFER_SIZE = (2 ** COL_ADDR_BITWIDTH) * MEM_ELEM_SIZE;
	parameter CLOCK_CYCLE = 0;
	parameter DELAY = 2;	

	output reg[MEM_ELEM_SIZE - 1 : 0] DataOut;	// Data Output
	input [MEM_ELEM_SIZE - 1 : 0] DataIn; 			// Data Input
	input [ROW_ADDR_BITWIDTH - 1  : 0] RowAddr;	// Row Buffer Input
	input [COL_ADDR_BITWIDTH - 1 : 0] ColAddr;	// Column Address
	input [1 : 0] Size;									// Size Of Data to be Read/Written
	input RE; 												// Active High Read Enable Signal
	input WE;												// Active High Write Enavle Signal
	input Precharge;										// Active High Precharge Signal
	input Activate;										// Active High Activate Signal
	input BS; 												// Active Low Bank Select Signal
	input clk;												// Clocl Signal
	input reset;											// Reset Signal
	
	reg [ROW_BUFFER_SIZE - 1 : 0] MemCore [(2 ** ROW_ADDR_BITWIDTH) - 1 : 0];
		
	reg [MEM_ELEM_SIZE - 1 : 0]ColumnRegister[(2 ** (COL_ADDR_BITWIDTH - COL_ADDR_OFFSET)) - 1 : 0];
	
	integer index;
	reg CopyToColBuffer;
	reg CopyToMemCore;
	reg [MEM_ELEM_SIZE - 1 : 0] ColBufferResetValue;
	reg [ROW_BUFFER_SIZE - 1 : 0] MemCoreResetValue;
	
	initial
	begin
		
		ColBufferResetValue = 32'h00000000;
		MemCoreResetValue = {(ROW_BUFFER_SIZE){1'b1}};

		for(index = 0; index < (2 ** ROW_ADDR_BITWIDTH); index = index + 1)
		begin
			MemCore[index] = MemCoreResetValue;
		end
				
		DataOut = 'bZ;
		CopyToColBuffer = `LOW;
		CopyToMemCore = `LOW;
		
	end
	
	always@(CopyToColBuffer)	
	begin
		// Hack to Copy Col Buffers to Row Buffer
		if(CopyToColBuffer == `HIGH)
		begin
			ColumnRegister[0] = MemCore[RowAddr][(1 * MEM_ELEM_SIZE) - 1 : (0 * MEM_ELEM_SIZE)];
			ColumnRegister[1] = MemCore[RowAddr][(2 * MEM_ELEM_SIZE) - 1 : (1 * MEM_ELEM_SIZE)];
			ColumnRegister[2] = MemCore[RowAddr][(3 * MEM_ELEM_SIZE) - 1 : (2 * MEM_ELEM_SIZE)];
			ColumnRegister[3] = MemCore[RowAddr][(4 * MEM_ELEM_SIZE) - 1 : (3 * MEM_ELEM_SIZE)];
			ColumnRegister[4] = MemCore[RowAddr][(5 * MEM_ELEM_SIZE) - 1 : (4 * MEM_ELEM_SIZE)];
			ColumnRegister[5] = MemCore[RowAddr][(6 * MEM_ELEM_SIZE) - 1 : (5 * MEM_ELEM_SIZE)];
			ColumnRegister[6] = MemCore[RowAddr][(7 * MEM_ELEM_SIZE) - 1 : (6 * MEM_ELEM_SIZE)];
			ColumnRegister[7] = MemCore[RowAddr][(8 * MEM_ELEM_SIZE) - 1 : (7 * MEM_ELEM_SIZE)];
			ColumnRegister[8] = MemCore[RowAddr][(9 * MEM_ELEM_SIZE) - 1 : (8 * MEM_ELEM_SIZE)];
			ColumnRegister[9] = MemCore[RowAddr][(10 * MEM_ELEM_SIZE) - 1 : (9 * MEM_ELEM_SIZE)];
			ColumnRegister[10] = MemCore[RowAddr][(11 * MEM_ELEM_SIZE) - 1 : (10 * MEM_ELEM_SIZE)];
			ColumnRegister[11] = MemCore[RowAddr][(12 * MEM_ELEM_SIZE) - 1 : (11 * MEM_ELEM_SIZE)];
			ColumnRegister[12] = MemCore[RowAddr][(13 * MEM_ELEM_SIZE) - 1 : (12 * MEM_ELEM_SIZE)];
			ColumnRegister[13] = MemCore[RowAddr][(14 * MEM_ELEM_SIZE) - 1 : (13 * MEM_ELEM_SIZE)];
			ColumnRegister[14] = MemCore[RowAddr][(15 * MEM_ELEM_SIZE) - 1 : (14 * MEM_ELEM_SIZE)];
			ColumnRegister[15] = MemCore[RowAddr][(16 * MEM_ELEM_SIZE) - 1 : (15 * MEM_ELEM_SIZE)];
			ColumnRegister[16] = MemCore[RowAddr][(17 * MEM_ELEM_SIZE) - 1 : (16 * MEM_ELEM_SIZE)];
			ColumnRegister[17] = MemCore[RowAddr][(18 * MEM_ELEM_SIZE) - 1 : (17 * MEM_ELEM_SIZE)];
			ColumnRegister[18] = MemCore[RowAddr][(19 * MEM_ELEM_SIZE) - 1 : (18 * MEM_ELEM_SIZE)];
			ColumnRegister[19] = MemCore[RowAddr][(20 * MEM_ELEM_SIZE) - 1 : (19 * MEM_ELEM_SIZE)];
			ColumnRegister[20] = MemCore[RowAddr][(21 * MEM_ELEM_SIZE) - 1 : (20 * MEM_ELEM_SIZE)];
			ColumnRegister[21] = MemCore[RowAddr][(22 * MEM_ELEM_SIZE) - 1 : (21 * MEM_ELEM_SIZE)];
			ColumnRegister[22] = MemCore[RowAddr][(23 * MEM_ELEM_SIZE) - 1 : (22 * MEM_ELEM_SIZE)];
			ColumnRegister[23] = MemCore[RowAddr][(24 * MEM_ELEM_SIZE) - 1 : (23 * MEM_ELEM_SIZE)];
			ColumnRegister[24] = MemCore[RowAddr][(25 * MEM_ELEM_SIZE) - 1 : (24 * MEM_ELEM_SIZE)];
			ColumnRegister[25] = MemCore[RowAddr][(26 * MEM_ELEM_SIZE) - 1 : (25 * MEM_ELEM_SIZE)];
			ColumnRegister[26] = MemCore[RowAddr][(27 * MEM_ELEM_SIZE) - 1 : (26 * MEM_ELEM_SIZE)];
			ColumnRegister[27] = MemCore[RowAddr][(28 * MEM_ELEM_SIZE) - 1 : (27 * MEM_ELEM_SIZE)];
			ColumnRegister[28] = MemCore[RowAddr][(29 * MEM_ELEM_SIZE) - 1 : (28 * MEM_ELEM_SIZE)];
			ColumnRegister[29] = MemCore[RowAddr][(30 * MEM_ELEM_SIZE) - 1 : (29 * MEM_ELEM_SIZE)];
			ColumnRegister[30] = MemCore[RowAddr][(31 * MEM_ELEM_SIZE) - 1 : (30 * MEM_ELEM_SIZE)];
			ColumnRegister[31] = MemCore[RowAddr][(32 * MEM_ELEM_SIZE) - 1 : (31 * MEM_ELEM_SIZE)];
			ColumnRegister[32] = MemCore[RowAddr][(33 * MEM_ELEM_SIZE) - 1 : (32 * MEM_ELEM_SIZE)];
			ColumnRegister[33] = MemCore[RowAddr][(34 * MEM_ELEM_SIZE) - 1 : (33 * MEM_ELEM_SIZE)];
			ColumnRegister[34] = MemCore[RowAddr][(35 * MEM_ELEM_SIZE) - 1 : (34 * MEM_ELEM_SIZE)];
			ColumnRegister[35] = MemCore[RowAddr][(36 * MEM_ELEM_SIZE) - 1 : (35 * MEM_ELEM_SIZE)];
			ColumnRegister[36] = MemCore[RowAddr][(37 * MEM_ELEM_SIZE) - 1 : (36 * MEM_ELEM_SIZE)];
			ColumnRegister[37] = MemCore[RowAddr][(38 * MEM_ELEM_SIZE) - 1 : (37 * MEM_ELEM_SIZE)];
			ColumnRegister[38] = MemCore[RowAddr][(39 * MEM_ELEM_SIZE) - 1 : (38 * MEM_ELEM_SIZE)];
			ColumnRegister[39] = MemCore[RowAddr][(40 * MEM_ELEM_SIZE) - 1 : (39 * MEM_ELEM_SIZE)];
			ColumnRegister[40] = MemCore[RowAddr][(41 * MEM_ELEM_SIZE) - 1 : (40 * MEM_ELEM_SIZE)];
			ColumnRegister[41] = MemCore[RowAddr][(42 * MEM_ELEM_SIZE) - 1 : (41 * MEM_ELEM_SIZE)];
			ColumnRegister[42] = MemCore[RowAddr][(43 * MEM_ELEM_SIZE) - 1 : (42 * MEM_ELEM_SIZE)];
			ColumnRegister[43] = MemCore[RowAddr][(44 * MEM_ELEM_SIZE) - 1 : (43 * MEM_ELEM_SIZE)];
			ColumnRegister[44] = MemCore[RowAddr][(45 * MEM_ELEM_SIZE) - 1 : (44 * MEM_ELEM_SIZE)];
			ColumnRegister[45] = MemCore[RowAddr][(46 * MEM_ELEM_SIZE) - 1 : (45 * MEM_ELEM_SIZE)];
			ColumnRegister[46] = MemCore[RowAddr][(47 * MEM_ELEM_SIZE) - 1 : (46 * MEM_ELEM_SIZE)];
			ColumnRegister[47] = MemCore[RowAddr][(48 * MEM_ELEM_SIZE) - 1 : (47 * MEM_ELEM_SIZE)];
			ColumnRegister[48] = MemCore[RowAddr][(49 * MEM_ELEM_SIZE) - 1 : (48 * MEM_ELEM_SIZE)];
			ColumnRegister[49] = MemCore[RowAddr][(50 * MEM_ELEM_SIZE) - 1 : (49 * MEM_ELEM_SIZE)];
			ColumnRegister[50] = MemCore[RowAddr][(51 * MEM_ELEM_SIZE) - 1 : (50 * MEM_ELEM_SIZE)];
			ColumnRegister[51] = MemCore[RowAddr][(52 * MEM_ELEM_SIZE) - 1 : (51 * MEM_ELEM_SIZE)];
			ColumnRegister[52] = MemCore[RowAddr][(53 * MEM_ELEM_SIZE) - 1 : (52 * MEM_ELEM_SIZE)];
			ColumnRegister[53] = MemCore[RowAddr][(54 * MEM_ELEM_SIZE) - 1 : (53 * MEM_ELEM_SIZE)];
			ColumnRegister[54] = MemCore[RowAddr][(55 * MEM_ELEM_SIZE) - 1 : (54 * MEM_ELEM_SIZE)];
			ColumnRegister[55] = MemCore[RowAddr][(56 * MEM_ELEM_SIZE) - 1 : (55 * MEM_ELEM_SIZE)];
			ColumnRegister[56] = MemCore[RowAddr][(57 * MEM_ELEM_SIZE) - 1 : (56 * MEM_ELEM_SIZE)];
			ColumnRegister[57] = MemCore[RowAddr][(58 * MEM_ELEM_SIZE) - 1 : (57 * MEM_ELEM_SIZE)];
			ColumnRegister[58] = MemCore[RowAddr][(59 * MEM_ELEM_SIZE) - 1 : (58 * MEM_ELEM_SIZE)];
			ColumnRegister[59] = MemCore[RowAddr][(60 * MEM_ELEM_SIZE) - 1 : (59 * MEM_ELEM_SIZE)];
			ColumnRegister[60] = MemCore[RowAddr][(61 * MEM_ELEM_SIZE) - 1 : (60 * MEM_ELEM_SIZE)];
			ColumnRegister[61] = MemCore[RowAddr][(62 * MEM_ELEM_SIZE) - 1 : (61 * MEM_ELEM_SIZE)];
			ColumnRegister[62] = MemCore[RowAddr][(63 * MEM_ELEM_SIZE) - 1 : (62 * MEM_ELEM_SIZE)];
			ColumnRegister[63] = MemCore[RowAddr][(64 * MEM_ELEM_SIZE) - 1 : (63 * MEM_ELEM_SIZE)];

			
			CopyToColBuffer = `LOW;
		end
	end
	
	always@(CopyToMemCore)
	begin
		if(CopyToMemCore == `HIGH)
		begin
			MemCore[RowAddr][(1 * MEM_ELEM_SIZE) - 1 : (0 * MEM_ELEM_SIZE)] = ColumnRegister[0];
			MemCore[RowAddr][(2 * MEM_ELEM_SIZE) - 1 : (1 * MEM_ELEM_SIZE)] = ColumnRegister[1];
			MemCore[RowAddr][(3 * MEM_ELEM_SIZE) - 1 : (2 * MEM_ELEM_SIZE)] = ColumnRegister[2];
			MemCore[RowAddr][(4 * MEM_ELEM_SIZE) - 1 : (3 * MEM_ELEM_SIZE)] = ColumnRegister[3];
			MemCore[RowAddr][(5 * MEM_ELEM_SIZE) - 1 : (4 * MEM_ELEM_SIZE)] = ColumnRegister[4];
			MemCore[RowAddr][(6 * MEM_ELEM_SIZE) - 1 : (5 * MEM_ELEM_SIZE)] = ColumnRegister[5];
			MemCore[RowAddr][(7 * MEM_ELEM_SIZE) - 1 : (6 * MEM_ELEM_SIZE)] = ColumnRegister[6];
			MemCore[RowAddr][(8 * MEM_ELEM_SIZE) - 1 : (7 * MEM_ELEM_SIZE)] = ColumnRegister[7];
			MemCore[RowAddr][(9 * MEM_ELEM_SIZE) - 1 : (8 * MEM_ELEM_SIZE)] = ColumnRegister[8];
			MemCore[RowAddr][(10 * MEM_ELEM_SIZE) - 1 : (9 * MEM_ELEM_SIZE)] = ColumnRegister[9];
			MemCore[RowAddr][(11 * MEM_ELEM_SIZE) - 1 : (10 * MEM_ELEM_SIZE)] = ColumnRegister[10];
			MemCore[RowAddr][(12 * MEM_ELEM_SIZE) - 1 : (11 * MEM_ELEM_SIZE)] = ColumnRegister[11];
			MemCore[RowAddr][(13 * MEM_ELEM_SIZE) - 1 : (12 * MEM_ELEM_SIZE)] = ColumnRegister[12];
			MemCore[RowAddr][(14 * MEM_ELEM_SIZE) - 1 : (13 * MEM_ELEM_SIZE)] = ColumnRegister[13];
			MemCore[RowAddr][(15 * MEM_ELEM_SIZE) - 1 : (14 * MEM_ELEM_SIZE)] = ColumnRegister[14];
			MemCore[RowAddr][(16 * MEM_ELEM_SIZE) - 1 : (15 * MEM_ELEM_SIZE)] = ColumnRegister[15];
			MemCore[RowAddr][(17 * MEM_ELEM_SIZE) - 1 : (16 * MEM_ELEM_SIZE)] = ColumnRegister[16];
			MemCore[RowAddr][(18 * MEM_ELEM_SIZE) - 1 : (17 * MEM_ELEM_SIZE)] = ColumnRegister[17];
			MemCore[RowAddr][(19 * MEM_ELEM_SIZE) - 1 : (18 * MEM_ELEM_SIZE)] = ColumnRegister[18];
			MemCore[RowAddr][(20 * MEM_ELEM_SIZE) - 1 : (19 * MEM_ELEM_SIZE)] = ColumnRegister[19];
			MemCore[RowAddr][(21 * MEM_ELEM_SIZE) - 1 : (20 * MEM_ELEM_SIZE)] = ColumnRegister[20];
			MemCore[RowAddr][(22 * MEM_ELEM_SIZE) - 1 : (21 * MEM_ELEM_SIZE)] = ColumnRegister[21];
			MemCore[RowAddr][(23 * MEM_ELEM_SIZE) - 1 : (22 * MEM_ELEM_SIZE)] = ColumnRegister[22];
			MemCore[RowAddr][(24 * MEM_ELEM_SIZE) - 1 : (23 * MEM_ELEM_SIZE)] = ColumnRegister[23];
			MemCore[RowAddr][(25 * MEM_ELEM_SIZE) - 1 : (24 * MEM_ELEM_SIZE)] = ColumnRegister[24];
			MemCore[RowAddr][(26 * MEM_ELEM_SIZE) - 1 : (25 * MEM_ELEM_SIZE)] = ColumnRegister[25];
			MemCore[RowAddr][(27 * MEM_ELEM_SIZE) - 1 : (26 * MEM_ELEM_SIZE)] = ColumnRegister[26];
			MemCore[RowAddr][(28 * MEM_ELEM_SIZE) - 1 : (27 * MEM_ELEM_SIZE)] = ColumnRegister[27];
			MemCore[RowAddr][(29 * MEM_ELEM_SIZE) - 1 : (28 * MEM_ELEM_SIZE)] = ColumnRegister[28];
			MemCore[RowAddr][(30 * MEM_ELEM_SIZE) - 1 : (29 * MEM_ELEM_SIZE)] = ColumnRegister[29];
			MemCore[RowAddr][(31 * MEM_ELEM_SIZE) - 1 : (30 * MEM_ELEM_SIZE)] = ColumnRegister[30];
			MemCore[RowAddr][(32 * MEM_ELEM_SIZE) - 1 : (31 * MEM_ELEM_SIZE)] = ColumnRegister[31];
			MemCore[RowAddr][(33 * MEM_ELEM_SIZE) - 1 : (32 * MEM_ELEM_SIZE)] = ColumnRegister[32];
			MemCore[RowAddr][(34 * MEM_ELEM_SIZE) - 1 : (33 * MEM_ELEM_SIZE)] = ColumnRegister[33];
			MemCore[RowAddr][(35 * MEM_ELEM_SIZE) - 1 : (34 * MEM_ELEM_SIZE)] = ColumnRegister[34];
			MemCore[RowAddr][(36 * MEM_ELEM_SIZE) - 1 : (35 * MEM_ELEM_SIZE)] = ColumnRegister[35];
			MemCore[RowAddr][(37 * MEM_ELEM_SIZE) - 1 : (36 * MEM_ELEM_SIZE)] = ColumnRegister[36];
			MemCore[RowAddr][(38 * MEM_ELEM_SIZE) - 1 : (37 * MEM_ELEM_SIZE)] = ColumnRegister[37];
			MemCore[RowAddr][(39 * MEM_ELEM_SIZE) - 1 : (38 * MEM_ELEM_SIZE)] = ColumnRegister[38];
			MemCore[RowAddr][(40 * MEM_ELEM_SIZE) - 1 : (39 * MEM_ELEM_SIZE)] = ColumnRegister[39];
			MemCore[RowAddr][(41 * MEM_ELEM_SIZE) - 1 : (40 * MEM_ELEM_SIZE)] = ColumnRegister[40];
			MemCore[RowAddr][(42 * MEM_ELEM_SIZE) - 1 : (41 * MEM_ELEM_SIZE)] = ColumnRegister[41];
			MemCore[RowAddr][(43 * MEM_ELEM_SIZE) - 1 : (42 * MEM_ELEM_SIZE)] = ColumnRegister[42];
			MemCore[RowAddr][(44 * MEM_ELEM_SIZE) - 1 : (43 * MEM_ELEM_SIZE)] = ColumnRegister[43];
			MemCore[RowAddr][(45 * MEM_ELEM_SIZE) - 1 : (44 * MEM_ELEM_SIZE)] = ColumnRegister[44];
			MemCore[RowAddr][(46 * MEM_ELEM_SIZE) - 1 : (45 * MEM_ELEM_SIZE)] = ColumnRegister[45];
			MemCore[RowAddr][(47 * MEM_ELEM_SIZE) - 1 : (46 * MEM_ELEM_SIZE)] = ColumnRegister[46];
			MemCore[RowAddr][(48 * MEM_ELEM_SIZE) - 1 : (47 * MEM_ELEM_SIZE)] = ColumnRegister[47];
			MemCore[RowAddr][(49 * MEM_ELEM_SIZE) - 1 : (48 * MEM_ELEM_SIZE)] = ColumnRegister[48];
			MemCore[RowAddr][(50 * MEM_ELEM_SIZE) - 1 : (49 * MEM_ELEM_SIZE)] = ColumnRegister[49];
			MemCore[RowAddr][(51 * MEM_ELEM_SIZE) - 1 : (50 * MEM_ELEM_SIZE)] = ColumnRegister[50];
			MemCore[RowAddr][(52 * MEM_ELEM_SIZE) - 1 : (51 * MEM_ELEM_SIZE)] = ColumnRegister[51];
			MemCore[RowAddr][(53 * MEM_ELEM_SIZE) - 1 : (52 * MEM_ELEM_SIZE)] = ColumnRegister[52];
			MemCore[RowAddr][(54 * MEM_ELEM_SIZE) - 1 : (53 * MEM_ELEM_SIZE)] = ColumnRegister[53];
			MemCore[RowAddr][(55 * MEM_ELEM_SIZE) - 1 : (54 * MEM_ELEM_SIZE)] = ColumnRegister[54];
			MemCore[RowAddr][(56 * MEM_ELEM_SIZE) - 1 : (55 * MEM_ELEM_SIZE)] = ColumnRegister[55];
			MemCore[RowAddr][(57 * MEM_ELEM_SIZE) - 1 : (56 * MEM_ELEM_SIZE)] = ColumnRegister[56];
			MemCore[RowAddr][(58 * MEM_ELEM_SIZE) - 1 : (57 * MEM_ELEM_SIZE)] = ColumnRegister[57];
			MemCore[RowAddr][(59 * MEM_ELEM_SIZE) - 1 : (58 * MEM_ELEM_SIZE)] = ColumnRegister[58];
			MemCore[RowAddr][(60 * MEM_ELEM_SIZE) - 1 : (59 * MEM_ELEM_SIZE)] = ColumnRegister[59];
			MemCore[RowAddr][(61 * MEM_ELEM_SIZE) - 1 : (60 * MEM_ELEM_SIZE)] = ColumnRegister[60];
			MemCore[RowAddr][(62 * MEM_ELEM_SIZE) - 1 : (61 * MEM_ELEM_SIZE)] = ColumnRegister[61];
			MemCore[RowAddr][(63 * MEM_ELEM_SIZE) - 1 : (62 * MEM_ELEM_SIZE)] = ColumnRegister[62];
			MemCore[RowAddr][(64 * MEM_ELEM_SIZE) - 1 : (63 * MEM_ELEM_SIZE)] = ColumnRegister[63];

			CopyToMemCore = `LOW;
			
		end
	end
	 
	always@(posedge clk)
	//always@(reset or BS or RE or Precharge or Activate)
	begin
		if(reset == `HIGH)
		begin
			$display("reset");

			// Reset MemCore
			for(index = 0; index < (2 ** ROW_ADDR_BITWIDTH); index = index + 1)
			begin
				MemCore[index] = MemCoreResetValue;
			end
			
			// Reset Column Buffers 
			for(index = 0; index < (2 ** (COL_ADDR_BITWIDTH - COL_ADDR_OFFSET)); index = index + 1)
			begin
				ColumnRegister[index] = ColBufferResetValue;
			end
		end
		else 
		begin
			if(BS == `LOW)
			begin
				if(Precharge == `HIGH)
				begin
					$display("Precharge");
					DataOut <= 'bZ;
					CopyToMemCore <= `HIGH;
				end
				else if(Activate == `HIGH)
				begin
					$display("Activate");
					DataOut <= 'bZ;
					CopyToColBuffer <= `HIGH;
				end
			end
			
			if(RE == `HIGH)
			begin
				$display("Read");
				if(Size == `SIZE_BYTE)
				begin
					case(ColAddr[COL_ADDR_OFFSET - 1 : 0])
						2'b00 : DataOut[7 : 0] <= #(DELAY) ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][7 : 0];
						2'b01 : DataOut[7 : 0] <= #(DELAY)ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][15 : 8];
						2'b10 : DataOut[7 : 0] <= #(DELAY)ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][23 : 16];
						2'b11 : DataOut[7 : 0] <= #(DELAY)ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][31 : 24];
					endcase
					
					DataOut[31 : 8] <= #(DELAY) 24'b0; // Filling Rest of the Bits with 0
				
				end
				else if(Size == `SIZE_HALF_WORD)
				begin
					case(ColAddr[COL_ADDR_OFFSET - 1 : 0])
						2'b00 : DataOut[15 : 0] <= #(DELAY) ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][15 : 0];
						2'b10 : DataOut[15 : 0] <= #(DELAY) ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][31 : 16];
					endcase
					
					DataOut[31 : 16] <= #(DELAY) 16'b0;
				end
				else
				begin
					DataOut <= #(DELAY) ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]];
				end
			end
			else if(WE == `HIGH)
			begin
				$display("Write");
				if(Size == `SIZE_BYTE)
				begin
					case(ColAddr[COL_ADDR_OFFSET - 1 : 0])
						2'b00 : ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][7 : 0] <= DataIn[7 : 0];
						2'b01 : ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][15 : 8] <= DataIn[7 : 0];
						2'b10 : ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][23 : 16] <= DataIn[7 : 0];
						2'b11 : ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][31 : 24] <= DataIn[7 : 0];
					endcase
				end
				else if(Size == `SIZE_HALF_WORD)
				begin
					case(ColAddr[COL_ADDR_OFFSET - 1 : 0])
						2'b00 : ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][15 : 0] <= DataIn[15 : 0];
						2'b10 : ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]][31 : 16] <= DataIn[15 : 0];
					endcase
				end
				else 
				begin
					ColumnRegister[ColAddr[COL_ADDR_BITWIDTH - 1 : COL_ADDR_OFFSET]] <= DataIn;
				end
				
				//DataOut <= 'bZ;
			end
		end
	end

endmodule
