`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:39:27 11/18/2015
// Design Name:   biu
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_biu.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: biu
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

`define BURST1 3'b000
`define BURST2 3'b001
`define BURST4 3'b010
`define BURST8 3'b011
`define BURST16 3'b100
`define BURST32 3'b101
`define BURST64 3'b110
`define BURSTPAGE	3'b111

`define READ 1'b0
`define WRITE 1'b1

`define S_START 2'b00
`define S_CONT 2'b01
`define S_IDLE 2'b10
`define S_BUSY 2'b11

`define PROGRAM_ADDRESS_SEQUENCE 32'h3FFFFFFF

module TB_biu;

	parameter CLOCK_CYCLE = 30;
	
	// Inputs
	reg [31:0] DataIn;
	reg [31:0] AddrIn;
	reg [8:0] Control;
	reg Clk;
	reg Rst;
	reg En;

	// Outputs
	wire CS;
	wire RAS;
	wire CAS;
	wire WE;
	wire Ready;
	wire EnWData;
	wire EnRData;
	wire [1:0] BS;
	wire [31:0] AddrOut;
	wire [1:0] SizeOut;

	// Instantiate the Unit Under Test (UUT)
	biu uut (
		.CS(CS), 
		.RAS(RAS), 
		.CAS(CAS), 
		.WE(WE), 
		.Ready(Ready), 
		.EnWdata(EnWData), 
		.EnRdata(EnRData), 
		.BS(BS), 
		.AddrOut(AddrOut), 
		.SizeOut(SizeOut),
		.DataIn(DataIn), 
		.AddrIn(AddrIn), 
		.Control(Control), 
		.Clk(Clk), 
		.Rst(Rst), 
		.En(En)
	);

	initial begin
		// Initialize Inputs
		/* Control Signals */
		// Control[8 : 7] - Status
		// Control[6 : 3] - Burst
		// Control[2 : 1] - Size
		// Control[0]     - WE
		
		DataIn = 0;
		AddrIn = 0;
		Control = 0;
		Clk = 0;
		Rst = 0;
		En = 0;
		
		#10 Rst = `HIGH;
		#(CLOCK_CYCLE) Rst = `LOW; En = `HIGH;
		
		// Program SDRAM
		AddrIn = `PROGRAM_ADDRESS_SEQUENCE;
		Control = {{`S_START},{4'b0},{`SIZE_W},{`WRITE}};
		
		// tCAS = 5
		// tWait = 4
		// tPre = 3
		// TLat - 3
		// Addr Mode - 1 (Linear)
		// Burst = 3'b010 (Burst 4)
		
		#(CLOCK_CYCLE)
		DataIn = 32'h0504053A;
		
		// Write
		AddrIn = 32'h00004AD0;
		Control = {{`S_START},{4'b0010},{`SIZE_W},{`WRITE}};
		
		#(13 * CLOCK_CYCLE)
		AddrIn = 32'h00004AD0;
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h11111111;

		#(CLOCK_CYCLE)
		AddrIn = 32'h00004AD0;	
		DataIn = 32'h22222222;
		
		#(CLOCK_CYCLE)
		AddrIn = 32'h00004AD0;	
		DataIn = 32'h33333333;
		
		// Read
		#(CLOCK_CYCLE)
		DataIn = 32'h44444444;
		
		AddrIn = 32'h00004AD0;
		Control = {{`S_START},{4'b0010},{`SIZE_W},{`READ}};
		
		#(20 * CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`READ}};
		
		// Read Other Address
		#(4 * CLOCK_CYCLE)
		Control = {{`S_IDLE},{4'b0010},{`SIZE_W},{`READ}};

		#(4 * CLOCK_CYCLE)

		#(CLOCK_CYCLE)		
		AddrIn = 32'h0000FFAA;
		Control = {{`S_START},{4'b0010},{`SIZE_W},{`READ}};
		
		#(15 * CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`READ}};
		
		#(4 * CLOCK_CYCLE)
		// Re-programming
		AddrIn = `PROGRAM_ADDRESS_SEQUENCE;
		Control = {{`S_START},{4'b0},{`SIZE_W},{`WRITE}};
		
		#(4 * CLOCK_CYCLE)
		DataIn = 32'hAA040533;
		Control = {{`S_START},{4'b0},{`SIZE_B},{`WRITE}};
		AddrIn = 32'h0000ABCD;
		
		#(13 * CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h11111111;
		
		#(CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h22222222;
		
		#(CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h33333333;
		
		#(CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h44444444;
		
		#(CLOCK_CYCLE)
		Control = {{`S_BUSY},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h44444444;
		
		#(CLOCK_CYCLE)
		Control = {{`S_BUSY},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h44444444;
		
		#(CLOCK_CYCLE)
		Control = {{`S_BUSY},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h44444444;
		
		#(CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h55555555;
		
		#(CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h66666666;
		
		#(CLOCK_CYCLE)
		Control = {{`S_CONT},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h77777777;
		
		#(CLOCK_CYCLE)
		Control = {{`S_IDLE},{4'b0010},{`SIZE_W},{`WRITE}};
		DataIn = 32'h88888888;
		
		#(100 * CLOCK_CYCLE)
		
		$finish;
		
		
		// Read from prev address 
		
		// Write
		
		// Go Busy
		
		// Read

	end
	
	always
	begin
		#(CLOCK_CYCLE / 2) Clk = ~Clk;
	end
      
endmodule

