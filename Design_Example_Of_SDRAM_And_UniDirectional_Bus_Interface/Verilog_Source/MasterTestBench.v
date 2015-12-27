`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:56:54 10/17/2015
// Design Name:   Master
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project2/MasterTestBench.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Master
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MasterTestBench;

	// Inputs
	reg clk;
	reg en;
	reg reset;
	reg Ready;
	reg [31:0] RData;
	reg Ack;
	reg [31:0] ProgAddress;
	reg [31:0] ProgData;
	reg [6:0] ProgControl;
	reg Prog;

	// Outputs
	wire [8:0] Control;
	wire [31:0] Address;
	wire [31:0] WData;
	wire Req;
	
	wire [7 : 0] MemIndex;
	//wire WriteEnBuffer;
	wire busy;
//	wire [1 : 0] Status;
	wire [1 : 0] PState;
	wire [15 : 0] BurstCount;
	
	assign MemIndex = uut.MemIndex;
	//assign WriteEnBuffer = uut.WriteEnBuffer;
	assign busy = uut.busy;
	assign PState	= uut.PState;
// assign Status = uut.Control[8 : 7];
	assign BurstCount = uut.BurstCount;

	// Instantiate the Unit Under Test (UUT)
	Master #(.DELAY(2))uut (
		.clk(clk), 
		.en(en), 
		.reset(reset), 
		.EControl(Control), 
		.EAddress(Address), 
		.EWData(WData), 
		.Req(Req), 
		.Ready(Ready), 
		.RData(RData), 
		.Ack(Ack), 
		.ProgAddress(ProgAddress), 
		.ProgData(ProgData), 
		.ProgControl(ProgControl), 
		.Prog(Prog)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		
		#10 Prog = 1; reset = 0;  en = 0;
		#2  ProgAddress = 32'h0; ProgControl = 7'b0000001; ProgData = 32'h00000045;
		
		#10 ProgAddress = 32'h1; ProgControl = 7'b0000001; ProgData = 32'h00000099;
		
		// Read; burst 2; HW
		#10 ProgAddress = 32'h2; ProgControl = 7'b0001010;
		#10 ProgAddress = 32'h4; ProgControl = 7'b0001010;

		// Read; burst 2; HW
		#10 ProgAddress = 32'h6; ProgControl = 7'b0001010;		

		// Read; burst 1; W
		#10 ProgAddress = 32'h8; ProgControl = 7'b0000100;
		
		// Write; burst 1; W
		#10 ProgAddress = 32'hC; ProgControl = 7'b0000101; ProgData = 32'h87654321;
		
		// Write; burst 1; W
		#10 ProgAddress = 32'h10; ProgControl = 7'b0000101; ProgData = 32'h66778899;
		
		// Write; burst 1; DW
		#10 ProgAddress = 32'h14; ProgControl = 7'b0000111; ProgData = 32'h11111111;
		#10 ProgAddress = 32'h18; ProgControl = 7'b0000111; ProgData = 32'h22222222;
		
		// Read; burst 1; DW
		#10 ProgAddress = 32'h1C; ProgControl = 7'b0000110;
		#10 ProgAddress = 32'h20; ProgControl = 7'b0000110;

		#10 ProgAddress = 32'hFFFFFFFF; ProgControl = 7'b1111111; ProgData = 32'hFFFFFFFF;
		
		#10 Prog = 0; reset = 1; en = 0;
		#10 reset = 0; en = 1; Ready = 0; Ack = 0;
		#5 en =0;
		#10 Ack = 1;
		
		#30 RData <= 32'hB;
		#10 RData <= 32'h4455;
		#10 Ready = 0;
		#40 Ready = 1;
		#40 Ready = 0;
		#15 Ready = 1;


		// Wait 100 ns for global reset to finish
        
		// Add stimulus here

	end
	
	always
	begin
		#5 clk <= ~clk;
	end
      
endmodule

