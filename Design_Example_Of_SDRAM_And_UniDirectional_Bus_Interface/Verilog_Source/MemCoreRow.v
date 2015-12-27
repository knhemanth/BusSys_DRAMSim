`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:19:10 11/12/2015 
// Design Name: 
// Module Name:    MemCoreRow 
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
module MemCoreRow(
	DataOut0,
	DataOut1,
	DataOut2,
	DataOut3,
	DataOut4,
	DataOut5,
	DataOut6,
	DataOut7,
	DataOut8,
	DataOut9,
	DataOut10,
	DataOut11,
	DataOut12,
	DataOut13,
	DataOut14,
	DataOut15,
	DataOut16,
	DataOut17,
	DataOut18,
	DataOut19,
	DataOut20,
	DataOut21,
	DataOut22,
	DataOut23,
	DataOut24,
	DataOut25,
	DataOut26,
	DataOut27,
	DataOut28,
	DataOut29,
	DataOut30,
	DataOut31,
	DataOut32,
	DataOut33,
	DataOut34,
	DataOut35,
	DataOut36,
	DataOut37,
	DataOut38,
	DataOut39,
	DataOut40,
	DataOut41,
	DataOut42,
	DataOut43,
	DataOut44,
	DataOut45,
	DataOut46,
	DataOut47,
	DataOut48,
	DataOut49,
	DataOut50,
	DataOut51,
	DataOut52,
	DataOut53,
	DataOut54,
	DataOut55,
	DataOut56,
	DataOut57,
	DataOut58,
	DataOut59,
	DataOut60,
	DataOut61,
	DataOut62,
	DataOut63,

	DataIn0,
	DataIn1,
	DataIn2,
	DataIn3,
	DataIn4,
	DataIn5,
	DataIn6,
	DataIn7,
	DataIn8,
	DataIn9,
	DataIn10,
	DataIn11,
	DataIn12,
	DataIn13,
	DataIn14,
	DataIn15,
	DataIn16,
	DataIn17,
	DataIn18,
	DataIn19,
	DataIn20,
	DataIn21,
	DataIn22,
	DataIn23,
	DataIn24,
	DataIn25,
	DataIn26,
	DataIn27,
	DataIn28,
	DataIn29,
	DataIn30,
	DataIn31,
	DataIn32,
	DataIn33,
	DataIn34,
	DataIn35,
	DataIn36,
	DataIn37,
	DataIn38,
	DataIn39,
	DataIn40,
	DataIn41,
	DataIn42,
	DataIn43,
	DataIn44,
	DataIn45,
	DataIn46,
	DataIn47,
	DataIn48,
	DataIn49,
	DataIn50,
	DataIn51,
	DataIn52,
	DataIn53,
	DataIn54,
	DataIn55,
	DataIn56,
	DataIn57,
	DataIn58,
	DataIn59,
	DataIn60,
	DataIn61,
	DataIn62,
	DataIn63,
	
	RE,
	WE,
	RowEnable,
	clk
    );
	 
	parameter DATA_BIT_WIDTH = 32;
	parameter COL_ELEM_COUNT = 64;
	
	output [DATA_BIT_WIDTH - 1 : 0] DataOut0;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut1;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut2;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut3;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut4;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut5;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut6;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut7;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut8;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut9;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut10;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut11;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut12;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut13;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut14;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut15;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut16;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut17;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut18;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut19;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut20;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut21;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut22;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut23;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut24;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut25;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut26;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut27;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut28;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut29;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut30;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut31;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut32;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut33;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut34;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut35;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut36;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut37;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut38;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut39;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut40;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut41;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut42;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut43;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut44;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut45;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut46;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut47;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut48;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut49;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut50;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut51;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut52;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut53;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut54;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut55;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut56;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut57;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut58;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut59;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut60;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut61;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut62;
	output [DATA_BIT_WIDTH - 1 : 0] DataOut63;


	input [DATA_BIT_WIDTH - 1 : 0] DataIn0;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn1;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn2;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn3;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn4;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn5;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn6;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn7;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn8;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn9;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn10;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn11;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn12;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn13;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn14;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn15;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn16;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn17;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn18;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn19;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn20;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn21;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn22;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn23;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn24;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn25;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn26;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn27;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn28;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn29;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn30;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn31;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn32;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn33;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn34;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn35;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn36;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn37;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn38;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn39;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn40;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn41;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn42;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn43;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn44;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn45;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn46;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn47;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn48;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn49;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn50;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn51;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn52;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn53;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn54;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn55;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn56;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn57;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn58;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn59;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn60;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn61;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn62;
	input [DATA_BIT_WIDTH - 1 : 0] DataIn63;

	input RE; // Read Enable Signal
	input WE; // Write Enable Signal
	input RowEnable; // Row Enable Signals
	input clk; // Clock Signal

	wire REandRowEnable;
	wire WEandRowEnable;
	
	and(REandRowEnable, RE, RowEnable);
	and(WEandRowEnable, WE, RowEnable);
	
	wire [DATA_BIT_WIDTH - 1 : 0] DataOutWires [COL_ELEM_COUNT - 1 : 0];
	wire [DATA_BIT_WIDTH - 1 : 0] DataInWires [COL_ELEM_COUNT - 1 : 0];

	// Assigning DataOut to DataOutWires used in the Generate Statement
	assign DataOut0 = DataOutWires[0];
	assign DataOut1 = DataOutWires[1];	
	assign DataOut2 = DataOutWires[2];
	assign DataOut3 = DataOutWires[3];
	assign DataOut4 = DataOutWires[4];
	assign DataOut5 = DataOutWires[5];
	assign DataOut6 = DataOutWires[6];
	assign DataOut7 = DataOutWires[7];
	assign DataOut8 = DataOutWires[8];
	assign DataOut9 = DataOutWires[9];
	assign DataOut10 = DataOutWires[10];
	assign DataOut11 = DataOutWires[11];	
	assign DataOut12 = DataOutWires[12];
	assign DataOut13 = DataOutWires[13];
	assign DataOut14 = DataOutWires[14];
	assign DataOut15 = DataOutWires[15];
	assign DataOut16 = DataOutWires[16];
	assign DataOut17 = DataOutWires[17];
	assign DataOut18 = DataOutWires[18];
	assign DataOut19 = DataOutWires[19];
	assign DataOut20 = DataOutWires[20];
	assign DataOut21 = DataOutWires[21];	
	assign DataOut22 = DataOutWires[22];
	assign DataOut23 = DataOutWires[23];
	assign DataOut24 = DataOutWires[24];
	assign DataOut25 = DataOutWires[25];
	assign DataOut26 = DataOutWires[26];
	assign DataOut27 = DataOutWires[27];
	assign DataOut28 = DataOutWires[28];
	assign DataOut29 = DataOutWires[29];
	assign DataOut30 = DataOutWires[30];
	assign DataOut31 = DataOutWires[31];	
	assign DataOut32 = DataOutWires[32];
	assign DataOut33 = DataOutWires[33];
	assign DataOut34 = DataOutWires[34];
	assign DataOut35 = DataOutWires[35];
	assign DataOut36 = DataOutWires[36];
	assign DataOut37 = DataOutWires[37];
	assign DataOut38 = DataOutWires[38];
	assign DataOut39 = DataOutWires[39];
	assign DataOut40 = DataOutWires[40];
	assign DataOut41 = DataOutWires[41];	
	assign DataOut42 = DataOutWires[42];
	assign DataOut43 = DataOutWires[43];
	assign DataOut44 = DataOutWires[44];
	assign DataOut45 = DataOutWires[45];
	assign DataOut46 = DataOutWires[46];
	assign DataOut47 = DataOutWires[47];
	assign DataOut48 = DataOutWires[48];
	assign DataOut49 = DataOutWires[49];
	assign DataOut50 = DataOutWires[50];
	assign DataOut51 = DataOutWires[51];	
	assign DataOut52 = DataOutWires[52];
	assign DataOut53 = DataOutWires[53];
	assign DataOut54 = DataOutWires[54];
	assign DataOut55 = DataOutWires[55];
	assign DataOut56 = DataOutWires[56];
	assign DataOut57 = DataOutWires[57];
	assign DataOut58 = DataOutWires[58];
	assign DataOut59 = DataOutWires[59];
	assign DataOut60 = DataOutWires[60];
	assign DataOut61 = DataOutWires[61];	
	assign DataOut62 = DataOutWires[62];
	assign DataOut63 = DataOutWires[63];
	
	// Assigning DataInWires to DataIn used in the Generate Statement
	assign DataInWires[0] = DataIn0;
	assign DataInWires[1] = DataIn1;
	assign DataInWires[2] = DataIn2;
	assign DataInWires[3] = DataIn3;
	assign DataInWires[4] = DataIn4;
	assign DataInWires[5] = DataIn5;
	assign DataInWires[6] = DataIn6;
	assign DataInWires[7] = DataIn7;
	assign DataInWires[8] = DataIn8;
	assign DataInWires[9] = DataIn9;
	assign DataInWires[10] = DataIn10;
	assign DataInWires[11] = DataIn11;
	assign DataInWires[12] = DataIn12;
	assign DataInWires[13] = DataIn13;
	assign DataInWires[14] = DataIn14;
	assign DataInWires[15] = DataIn15;
	assign DataInWires[16] = DataIn16;
	assign DataInWires[17] = DataIn17;
	assign DataInWires[18] = DataIn18;
	assign DataInWires[19] = DataIn19;	
	assign DataInWires[20] = DataIn20;
	assign DataInWires[21] = DataIn21;
	assign DataInWires[22] = DataIn22;
	assign DataInWires[23] = DataIn23;
	assign DataInWires[24] = DataIn24;
	assign DataInWires[25] = DataIn25;
	assign DataInWires[26] = DataIn26;
	assign DataInWires[27] = DataIn27;
	assign DataInWires[28] = DataIn28;
	assign DataInWires[29] = DataIn29;	
	assign DataInWires[30] = DataIn30;
	assign DataInWires[31] = DataIn31;
	assign DataInWires[32] = DataIn32;
	assign DataInWires[33] = DataIn33;
	assign DataInWires[34] = DataIn34;
	assign DataInWires[35] = DataIn35;
	assign DataInWires[36] = DataIn36;
	assign DataInWires[37] = DataIn37;
	assign DataInWires[38] = DataIn38;
	assign DataInWires[39] = DataIn39;
	assign DataInWires[40] = DataIn40;
	assign DataInWires[41] = DataIn41;
	assign DataInWires[42] = DataIn42;
	assign DataInWires[43] = DataIn43;
	assign DataInWires[44] = DataIn44;
	assign DataInWires[45] = DataIn45;
	assign DataInWires[46] = DataIn46;
	assign DataInWires[47] = DataIn47;
	assign DataInWires[48] = DataIn48;
	assign DataInWires[49] = DataIn49;
	assign DataInWires[50] = DataIn50;
	assign DataInWires[51] = DataIn51;
	assign DataInWires[52] = DataIn52;
	assign DataInWires[53] = DataIn53;
	assign DataInWires[54] = DataIn54;
	assign DataInWires[55] = DataIn55;
	assign DataInWires[56] = DataIn56;
	assign DataInWires[57] = DataIn57;
	assign DataInWires[58] = DataIn58;
	assign DataInWires[59] = DataIn59;
	assign DataInWires[60] = DataIn60;
	assign DataInWires[61] = DataIn61;
	assign DataInWires[62] = DataIn62;
	assign DataInWires[63] = DataIn63;

	genvar colCount;
	
	generate
		for(colCount = 0; colCount < COL_ELEM_COUNT; colCount = colCount + 1)
		begin : Reg
			TriStatedReadWriteRegister Register(
								.DataOut(DataOutWires[colCount]), 
								.DataIn(DataInWires[colCount]), 
								.RE(REandRowEnable), 
								.WE(WEandRowEnable),
								.clk(clk)
								);
		end
	endgenerate


endmodule
