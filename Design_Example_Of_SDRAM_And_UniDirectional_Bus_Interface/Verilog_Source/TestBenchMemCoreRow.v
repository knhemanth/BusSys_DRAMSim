`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:02:01 11/12/2015
// Design Name:   MemCoreRow
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project3/FinalProject/TestBenchMemCoreRow.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MemCoreRow
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBenchMemCoreRow;

	// Inputs
	reg [31:0] DataIn0;
	reg [31:0] DataIn1;
	reg [31:0] DataIn2;
	reg [31:0] DataIn3;
	reg [31:0] DataIn4;
	reg [31:0] DataIn5;
	reg [31:0] DataIn6;
	reg [31:0] DataIn7;
	reg [31:0] DataIn8;
	reg [31:0] DataIn9;
	reg [31:0] DataIn10;
	reg [31:0] DataIn11;
	reg [31:0] DataIn12;
	reg [31:0] DataIn13;
	reg [31:0] DataIn14;
	reg [31:0] DataIn15;
	reg [31:0] DataIn16;
	reg [31:0] DataIn17;
	reg [31:0] DataIn18;
	reg [31:0] DataIn19;
	reg [31:0] DataIn20;
	reg [31:0] DataIn21;
	reg [31:0] DataIn22;
	reg [31:0] DataIn23;
	reg [31:0] DataIn24;
	reg [31:0] DataIn25;
	reg [31:0] DataIn26;
	reg [31:0] DataIn27;
	reg [31:0] DataIn28;
	reg [31:0] DataIn29;
	reg [31:0] DataIn30;
	reg [31:0] DataIn31;
	reg [31:0] DataIn32;
	reg [31:0] DataIn33;
	reg [31:0] DataIn34;
	reg [31:0] DataIn35;
	reg [31:0] DataIn36;
	reg [31:0] DataIn37;
	reg [31:0] DataIn38;
	reg [31:0] DataIn39;
	reg [31:0] DataIn40;
	reg [31:0] DataIn41;
	reg [31:0] DataIn42;
	reg [31:0] DataIn43;
	reg [31:0] DataIn44;
	reg [31:0] DataIn45;
	reg [31:0] DataIn46;
	reg [31:0] DataIn47;
	reg [31:0] DataIn48;
	reg [31:0] DataIn49;
	reg [31:0] DataIn50;
	reg [31:0] DataIn51;
	reg [31:0] DataIn52;
	reg [31:0] DataIn53;
	reg [31:0] DataIn54;
	reg [31:0] DataIn55;
	reg [31:0] DataIn56;
	reg [31:0] DataIn57;
	reg [31:0] DataIn58;
	reg [31:0] DataIn59;
	reg [31:0] DataIn60;
	reg [31:0] DataIn61;
	reg [31:0] DataIn62;
	reg [31:0] DataIn63;
	reg RE;
	reg WE;
	reg RowEnable;

	// Outputs
	wire [31:0] DataOut0;
	wire [31:0] DataOut1;
	wire [31:0] DataOut2;
	wire [31:0] DataOut3;
	wire [31:0] DataOut4;
	wire [31:0] DataOut5;
	wire [31:0] DataOut6;
	wire [31:0] DataOut7;
	wire [31:0] DataOut8;
	wire [31:0] DataOut9;
	wire [31:0] DataOut10;
	wire [31:0] DataOut11;
	wire [31:0] DataOut12;
	wire [31:0] DataOut13;
	wire [31:0] DataOut14;
	wire [31:0] DataOut15;
	wire [31:0] DataOut16;
	wire [31:0] DataOut17;
	wire [31:0] DataOut18;
	wire [31:0] DataOut19;
	wire [31:0] DataOut20;
	wire [31:0] DataOut21;
	wire [31:0] DataOut22;
	wire [31:0] DataOut23;
	wire [31:0] DataOut24;
	wire [31:0] DataOut25;
	wire [31:0] DataOut26;
	wire [31:0] DataOut27;
	wire [31:0] DataOut28;
	wire [31:0] DataOut29;
	wire [31:0] DataOut30;
	wire [31:0] DataOut31;
	wire [31:0] DataOut32;
	wire [31:0] DataOut33;
	wire [31:0] DataOut34;
	wire [31:0] DataOut35;
	wire [31:0] DataOut36;
	wire [31:0] DataOut37;
	wire [31:0] DataOut38;
	wire [31:0] DataOut39;
	wire [31:0] DataOut40;
	wire [31:0] DataOut41;
	wire [31:0] DataOut42;
	wire [31:0] DataOut43;
	wire [31:0] DataOut44;
	wire [31:0] DataOut45;
	wire [31:0] DataOut46;
	wire [31:0] DataOut47;
	wire [31:0] DataOut48;
	wire [31:0] DataOut49;
	wire [31:0] DataOut50;
	wire [31:0] DataOut51;
	wire [31:0] DataOut52;
	wire [31:0] DataOut53;
	wire [31:0] DataOut54;
	wire [31:0] DataOut55;
	wire [31:0] DataOut56;
	wire [31:0] DataOut57;
	wire [31:0] DataOut58;
	wire [31:0] DataOut59;
	wire [31:0] DataOut60;
	wire [31:0] DataOut61;
	wire [31:0] DataOut62;
	wire [31:0] DataOut63;

	// Instantiate the Unit Under Test (UUT)
	MemCoreRow uut (
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
		.RowEnable(RowEnable)
	);

	initial begin
		// Initialize Inputs
		DataIn0 = 0;
		DataIn1 = 0;
		DataIn2 = 0;
		DataIn3 = 0;
		DataIn4 = 0;
		DataIn5 = 0;
		DataIn6 = 0;
		DataIn7 = 0;
		DataIn8 = 0;
		DataIn9 = 0;
		DataIn10 = 0;
		DataIn11 = 0;
		DataIn12 = 0;
		DataIn13 = 0;
		DataIn14 = 0;
		DataIn15 = 0;
		DataIn16 = 0;
		DataIn17 = 0;
		DataIn18 = 0;
		DataIn19 = 0;
		DataIn20 = 0;
		DataIn21 = 0;
		DataIn22 = 0;
		DataIn23 = 0;
		DataIn24 = 0;
		DataIn25 = 0;
		DataIn26 = 0;
		DataIn27 = 0;
		DataIn28 = 0;
		DataIn29 = 0;
		DataIn30 = 0;
		DataIn31 = 0;
		DataIn32 = 0;
		DataIn33 = 0;
		DataIn34 = 0;
		DataIn35 = 0;
		DataIn36 = 0;
		DataIn37 = 0;
		DataIn38 = 0;
		DataIn39 = 0;
		DataIn40 = 0;
		DataIn41 = 0;
		DataIn42 = 0;
		DataIn43 = 0;
		DataIn44 = 0;
		DataIn45 = 0;
		DataIn46 = 0;
		DataIn47 = 0;
		DataIn48 = 0;
		DataIn49 = 0;
		DataIn50 = 0;
		DataIn51 = 0;
		DataIn52 = 0;
		DataIn53 = 0;
		DataIn54 = 0;
		DataIn55 = 0;
		DataIn56 = 0;
		DataIn57 = 0;
		DataIn58 = 0;
		DataIn59 = 0;
		DataIn60 = 0;
		DataIn61 = 0;
		DataIn62 = 0;
		DataIn63 = 0;
		RE = 0;
		WE = 0;
		RowEnable = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
		RowEnable = 1; RE = 1; 
		#10 RowEnable = 1; WE = 1; RE = 0; DataIn10 = 32'h11223344;
		#10 RowEnable = 1; WE = 0; RE = 1;
		#10 RowEnable = 1; WE = 0; RE = 0;
		// Add stimulus here

	end
      
endmodule

