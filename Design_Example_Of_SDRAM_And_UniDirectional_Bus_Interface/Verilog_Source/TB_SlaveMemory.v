`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:52:04 10/17/2015
// Design Name:   SlaveMemory
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_SlaveMemory.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SlaveMemory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_SlaveMemory;

	// Inputs
	reg [31:0] DataIn;
	reg [31:0] Addr;
	reg [8:0] Control;
	reg Clk;
	reg Rst;
	reg En;

	// Outputs
	wire [31:0] DataOut;
	wire Ready;

	// Signal taps
	wire Wen;
	wire Ren;
	wire [31:0] MDataOut;
	wire [31:0] MDataIn;
	wire [7:0] MRdAddr;
	wire [7:0] MWrAddr;
	wire [7:0] Byte4;
	wire [7:0] Byte3;
	wire [7:0] Byte2;
	wire [7:0] Byte1;
	wire [31:0] FWBuff_In;		// Full Word buffer input
	wire [15:0] HWBuff_In;		// Half Word buffer input
	wire [7:0]	BBuff_In;		// Byte buffer input
	wire [31:0] FWBuff_Out;		// Full Word buffer output
	wire [15:0] HWBuff_Out;	// Half Word buffer output
	wire [7:0]	BBuff_Out;		// Byte buffer output
	wire FWBuff_En;				// Full Word buffer enable
	wire HWBuff_En;				// Half Word buffer enable
	wire BBuff_En;					// Byte buffer enable
	wire [31:0] Byte4_MuxIn;
	wire [31:0] Byte3_MuxIn;
	wire [31:0] Byte2_MuxIn;
	wire [31:0] Byte1_MuxIn;
	wire [1:0] Byte4_Sel;
	wire [1:0] Byte3_Sel;
	wire [1:0] Byte2_Sel;
	wire [1:0] Byte1_Sel;
	wire [31:0] Current_Addr;
	wire [1:0]	Current_Size;
	wire [1:0] Size;
	wire nodeB4S0;
	wire nodeB4S1;
	wire nodeB3S0;
	wire nodeB2S0;
	wire nodeB2S1;
	wire nodeB1S0;
	
	assign Wen = uut.Wen;
	assign Ren = uut.Ren;
	assign MDataOut = uut.MDataOut;
	assign MDataIn = uut.MDataIn;
	assign MRdAddr = uut.MRdAddr;
	assign MWrAddr = uut.MWrAddr;
	assign Byte4 = uut.Byte4;
	assign Byte3 = uut.Byte3;
	assign Byte2 = uut.Byte2;
	assign Byte1 = uut.Byte1;
	assign FWBuff_In = uut.FWBuff_In;		// Full Word buffer input
	assign HWBuff_In = uut.HWBuff_In;		// Half Word buffer input
	assign BBuff_In = uut.BBuff_In;		// Byte buffer input
	assign FWBuff_Out = uut.FWBuff_Out;		// Full Word buffer output
	assign HWBuff_Out = uut.HWBuff_Out;	// Half Word buffer output
	assign BBuff_Out = uut.BBuff_Out;		// Byte buffer output
	assign FWBuff_En = uut.FWBuff_En;				// Full Word buffer enable
	assign HWBuff_En = uut.HWBuff_En;				// Half Word buffer enable
	assign BBuff_En = uut.BBuff_En;					// Byte buffer enable
	assign Byte4_MuxIn = uut.Byte4_MuxIn;
	assign Byte3_MuxIn = uut.Byte3_MuxIn;
	assign Byte2_MuxIn = uut.Byte2_MuxIn;
	assign Byte1_MuxIn = uut.Byte1_MuxIn;
	assign Byte4_Sel= uut.Byte4_Sel;
	assign Byte3_Sel = uut.Byte3_Sel;
	assign Byte2_Sel= uut.Byte2_Sel;
	assign Byte1_Sel = uut.Byte1_Sel;
	assign Current_Addr = uut.Current_Addr;
	assign Current_Size = uut.Current_Size;
	assign Size = uut.Size;
	assign nodeB4S0 = uut.nodeB4S0;
	assign nodeB4S1 = uut.nodeB4S1;
	assign nodeB3S0 = uut.nodeB3S0;
	assign nodeB2S0 = uut.nodeB2S0;
	assign nodeB2S1 = uut.nodeB2S1;
	assign nodeB1S0 = uut.nodeB1S0;

	// Instantiate the Unit Under Test (UUT)
	SlaveMemory uut (
		.DataOut(DataOut), 
		.Ready(Ready), 
		.DataIn(DataIn), 
		.Addr(Addr), 
		.Control(Control), 
		.Clk(Clk), 
		.Rst(Rst), 
		.En(En)
	);

	initial begin
		// Initialize Inputs
		Addr = 32'h 2Ac;
		Control = 0;
		Clk = 0;
		Rst = 1'b1;
		En = 1'b1;
		
		#23 Rst = 1'b0;
		Control = 9'b0000000101;
		
		
		#10; 	
	   Addr = 32'h 34e; 
		Control = 9'b000000011; 
		DataIn = 32'h B7462120;
		
		#20; 
		Addr = 32'h 3f6; 
		Control = 9'b000000001; 
		DataIn = 747;
		
		#60;
		Addr = 32'h 078;
		Control = 9'b000000111;
		DataIn = 32'h DEADBEEF;
		
		#60;
		Addr = 32'h 07C;
		DataIn = 32'h ABCD;
		
		#20; 
		En = 1'b1;
		Control = 000000010;
		Addr = 32'h 07c;
		DataIn = 32'h 1234;
		
		#20
		Addr = 32'h 3f6;
		Control = 9'b000000000;
		
		#20
		Addr = 32'h 2;
		Control = 9'b000000001;

		#60;
		Addr = 32'h 3f6;
		Control = 9'b000000100;
		DataIn = 32'h 17; 
		
		#20;
		En = 1'b0;
										
		#40 $finish;
	end
	
	always
	begin
		#10 Clk = ~Clk;
	end
      
endmodule

