`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:19:03 11/12/2015 
// Design Name: 
// Module Name:    MemCore_v1 
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
module MemCore_v1(
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

	RowAddrEn,
	RE,
	WE,
	clk
    );
	
	parameter ROW_ADDR_BITWIDTH = 8;
	parameter COL_ADDR_BITWIDTH = 8;
	parameter COL_OFFSET_BITWIDTH = 2;
	parameter COL_ELEM_COUNT = (2 ** COL_ADDR_BITWIDTH - COL_OFFSET_BITWIDTH);
	parameter DATA_BIT_WIDTH = 32;

	input [(2 ** ROW_ADDR_BITWIDTH) - 1 : 0] RowAddrEn; // Enable Signal for Each Row
	input RE; // Read Enable Signal
	input WE; // Write Enable Signal
	input clk; // Clock Signal

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

	genvar rowindex;
	
	generate
		//for(rowindex = 0; rowindex < (2 ** ROW_ADDR_BITWIDTH); rowindex = rowindex + 1)
		for(rowindex = 0; rowindex < (3); rowindex = rowindex + 1)
		begin : MemCoreRow
			MemCoreRow Row (
			.DataOut0(DataOut0), 
			.DataOut1(DataOut1), 
			.DataOut2(DataOut2), 
			.DataOut3(DataOut3), 
			.DataOut4(DataOut4), 
			.DataOut5(DataOut5), 
			.DataOut6(DataOut6), 
			.DataOut7(DataOut7), 
			.DataOut8(DataOut8), 
			.DataOut9(DataOut9), 
			.DataOut10(DataOut10), 
			.DataOut11(DataOut11), 
			.DataOut12(DataOut12), 
			.DataOut13(DataOut13), 
			.DataOut14(DataOut14), 
			.DataOut15(DataOut15), 
			.DataOut16(DataOut16), 
			.DataOut17(DataOut17), 
			.DataOut18(DataOut18), 
			.DataOut19(DataOut19), 
			.DataOut20(DataOut20), 
			.DataOut21(DataOut21), 
			.DataOut22(DataOut22), 
			.DataOut23(DataOut23), 
			.DataOut24(DataOut24), 
			.DataOut25(DataOut25), 
			.DataOut26(DataOut26), 
			.DataOut27(DataOut27), 
			.DataOut28(DataOut28), 
			.DataOut29(DataOut29), 
			.DataOut30(DataOut30), 
			.DataOut31(DataOut31), 
			.DataOut32(DataOut32), 
			.DataOut33(DataOut33), 
			.DataOut34(DataOut34), 
			.DataOut35(DataOut35), 
			.DataOut36(DataOut36), 
			.DataOut37(DataOut37), 
			.DataOut38(DataOut38), 
			.DataOut39(DataOut39), 
			.DataOut40(DataOut40), 
			.DataOut41(DataOut41), 
			.DataOut42(DataOut42), 
			.DataOut43(DataOut43), 
			.DataOut44(DataOut44), 
			.DataOut45(DataOut45), 
			.DataOut46(DataOut46), 
			.DataOut47(DataOut47), 
			.DataOut48(DataOut48), 
			.DataOut49(DataOut49), 
			.DataOut50(DataOut50), 
			.DataOut51(DataOut51), 
			.DataOut52(DataOut52), 
			.DataOut53(DataOut53), 
			.DataOut54(DataOut54), 
			.DataOut55(DataOut55), 
			.DataOut56(DataOut56), 
			.DataOut57(DataOut57), 
			.DataOut58(DataOut58), 
			.DataOut59(DataOut59), 
			.DataOut60(DataOut60), 
			.DataOut61(DataOut61), 
			.DataOut62(DataOut62), 
			.DataOut63(DataOut63), 
			.DataIn0(DataIn0), 
			.DataIn1(DataIn1), 
			.DataIn2(DataIn2), 
			.DataIn3(DataIn3), 
			.DataIn4(DataIn4), 
			.DataIn5(DataIn5), 
			.DataIn6(DataIn6), 
			.DataIn7(DataIn7), 
			.DataIn8(DataIn8), 
			.DataIn9(DataIn9), 
			.DataIn10(DataIn10), 
			.DataIn11(DataIn11), 
			.DataIn12(DataIn12), 
			.DataIn13(DataIn13), 
			.DataIn14(DataIn14), 
			.DataIn15(DataIn15), 
			.DataIn16(DataIn16), 
			.DataIn17(DataIn17), 
			.DataIn18(DataIn18), 
			.DataIn19(DataIn19), 
			.DataIn20(DataIn20), 
			.DataIn21(DataIn21), 
			.DataIn22(DataIn22), 
			.DataIn23(DataIn23), 
			.DataIn24(DataIn24), 
			.DataIn25(DataIn25), 
			.DataIn26(DataIn26), 
			.DataIn27(DataIn27), 
			.DataIn28(DataIn28), 
			.DataIn29(DataIn29), 
			.DataIn30(DataIn30), 
			.DataIn31(DataIn31), 
			.DataIn32(DataIn32), 
			.DataIn33(DataIn33), 
			.DataIn34(DataIn34), 
			.DataIn35(DataIn35), 
			.DataIn36(DataIn36), 
			.DataIn37(DataIn37), 
			.DataIn38(DataIn38), 
			.DataIn39(DataIn39), 
			.DataIn40(DataIn40), 
			.DataIn41(DataIn41), 
			.DataIn42(DataIn42), 
			.DataIn43(DataIn43), 
			.DataIn44(DataIn44), 
			.DataIn45(DataIn45), 
			.DataIn46(DataIn46), 
			.DataIn47(DataIn47), 
			.DataIn48(DataIn48), 
			.DataIn49(DataIn49), 
			.DataIn50(DataIn50), 
			.DataIn51(DataIn51), 
			.DataIn52(DataIn52), 
			.DataIn53(DataIn53), 
			.DataIn54(DataIn54), 
			.DataIn55(DataIn55), 
			.DataIn56(DataIn56), 
			.DataIn57(DataIn57), 
			.DataIn58(DataIn58), 
			.DataIn59(DataIn59), 
			.DataIn60(DataIn60), 
			.DataIn61(DataIn61), 
			.DataIn62(DataIn62), 
			.DataIn63(DataIn63), 
			.RE(RE), 
			.WE(WE), 
			.RowEnable(RowAddrEn[rowindex]),
			.clk(clk));
		end
	endgenerate
	
	
endmodule
