`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:37:04 11/08/2015
// Design Name:   sdram_controls
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_sdram_controls.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sdram_controls
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CLK_PERIOD 30

module TB_sdram_controls;

	// Inputs
	reg CS;
	reg RAS;
	reg CAS;
	reg [31:0] AddrIn;
	reg WeIn;
	reg Clk;
	reg Rst;
	reg [1:0] SizeIn;
	reg [7:0] tburst;
	reg [2:0] tburst_config;
	reg addr_mode;
	reg [3:0] tlat;
	reg [7:0] tpre;
	reg [7:0] twait;
	reg [7:0] tcas;

	// Outputs
	wire WeOut;
	wire ReOut;
	wire PrechargeOut;
	wire ActivateOut;
	wire [7:0] ColAddr;
	wire [7:0] RowAddr;
	wire [1:0] SizeOut;
	
	
	// Enable unit verification done here
	wire Precharge; // Active High Precharge Signal to Bank
	wire Activate; // Active High Actiavte Signal to Bank
	wire Re; // Active High Read Enable to Bank
	wire We; // Active High Read Enable to Bank
	wire AddrGenEn; 
	wire TimerLd; // Load Signal for the timing generator
	wire RwState; // 1 - Write Command; 0 - Read Command
	wire [2:0]LdState; // Current State Of Operation of SDRAM
	wire [7:0] TimerCount;
	wire BusySignal;
	
	
	// File logging
	integer fd, fd1, clk_period;
	

	// Instantiate the Unit Under Test (UUT)
	sdram_controls uut (
		
		.WeOut(WeOut),
		.ReOut(ReOut),
		.PrechargeOut(PrechargeOut),
		.ActivateOut(ActivateOut),
		.BusySignalOut(),
		.RowAddr(RowAddr),
		.ColAddr(ColAddr),
		.SizeOut(SizeOut),
		.CS(CS),
		.RAS(RAS),
		.CAS(CAS),
		.WeIn(WeIn),
		.AddrIn(AddrIn),
		.SizeIn(SizeIn),
		.tburst(tburst),
		.tburst_config(tburst_config),
		.addr_mode(addr_mode),
		.tlat(tlat),
		.tpre(tpre),
		.twait(twait),
		.tcas(tcas),
		.Clk(Clk),
		.Rst(Rst)
		
	);
	
	assign Precharge = uut.EnableUnit.Precharge;
	assign Activate = uut.EnableUnit.Activate;
	assign Re = uut.EnableUnit.Re;
	assign We = uut.EnableUnit.We;
	assign AddrGenEn = uut.EnableUnit.AddrGenEn;
	assign TimerLd = uut.EnableUnit.TimerLd;
	assign RwState = uut.EnableUnit.RwState;
	assign LdState = uut.EnableUnit.LdState;
	assign TimerCount = uut.EnableUnit.TimerCount;
	assign BusySignal = uut.EnableUnit.BusySignal;

	

	initial begin
		// Initialize Inputs
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		AddrIn = 0;
		WeIn = 1'b1;
		Clk = 0;
		Rst = 1'b0;
		SizeIn = 2'b10;
		tburst = 8'h8;
		tburst_config = 3'b011;
		addr_mode = 1'b0;
		tlat = 4'd7;
		tpre = 8'h3;
		twait = 8'h3;
		tcas = 8'h5;
		clk_period = 0;
		
		fd = $fopen("sdram_controls_test.csv");
		$fdisplay(fd,"Clk Period,Rst,WeOut,ReOut,PrechargeOut,ActivateOut,RowAddr,ColAddr,SizeOut,CS,RAS,CAS,WeIn,AddrIn,addr_mode");
		
		
		fd1 = $fopen("sdram_enable_unit_test.csv");
		$fdisplay(fd1,"Clk Period,Reset,Precharge,Activate,Re,We,AddrGenEn,TimerLd,RwState,LdState,TimerCount,BusySignal");
	

		// Wait 20 ns for global reset to finish
		#5  Rst = 1'b1;
		#28 Rst = 1'b0;
        
		// Add stimulus here
//		#30 AddrIn = 32'h030303AF;
//		CS = 0;
//		RAS = 0;
//		CAS = 0;
//		WeIn = 0;
//		
//		#30 CS = 1'b1;
//		RAS = 1'b1;
//		CAS = 1'b1;
//		WeIn = 1'b1;
//		
		// Pre-charge
		#(`CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b0;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Activate
		#(3 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b1;
		AddrIn = 32'hAA;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Write
		#(5 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b1;
		CAS = 1'b0;
		WeIn = 1'b0;
		AddrIn = 32'hBB;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		 
		#(6 * `CLK_PERIOD);
		#(3 * `CLK_PERIOD);
		
		// Precharge again
		#(`CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b0;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Activate
		#(3 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b1;
		AddrIn = 32'h12;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Read
		#(5 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b1;
		CAS = 1'b0;
		WeIn = 1'b1;
		AddrIn = 32'h5A;
		SizeIn = 2'b01;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#(6 * `CLK_PERIOD );	// Latency period
		#(7 * `CLK_PERIOD);	// Burst period
		#(3 * `CLK_PERIOD);	// Wait period
		
		// Change burst configuration
		tburst = 8'd4;		// Burst length of 4
		tburst_config = 3'b010;
		addr_mode = 1'b1;	// Linear addressing mode
		
		// Precharge again
		#(`CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b0;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Activate
		#(3 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b1;
		AddrIn = 32'h12;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Read
		#(5 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b1;
		CAS = 1'b0;
		WeIn = 1'b1;
		AddrIn = 32'h5A;
		SizeIn = 2'b00;		// Byte sized transactions
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#(6 * `CLK_PERIOD );	// Latency period
		#(3 * `CLK_PERIOD);	// Burst period
		#(3 * `CLK_PERIOD);	// Wait period
		
		
		// Pre-charge
		#(`CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b0;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Activate
		#(3 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b1;
		AddrIn = 32'hCC;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Write
		#(5 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b1;
		CAS = 1'b0;
		WeIn = 1'b0;
		AddrIn = 32'hBB;
		SizeIn = 2'b01;		// Half word sized transactions
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		 
		#(2 * `CLK_PERIOD);	// Burst period
		#(3 * `CLK_PERIOD);	// Wait period
		
		// Change burst configuration
		tburst = 8'd32;		// Burst length of 4
		tburst_config = 3'b101;
		addr_mode = 1'b0;	// Sequential addressing mode
		
		// Precharge again
		#(`CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b0;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Activate
		#(3 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b1;
		AddrIn = 32'h12;
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		// Read
		#(5 * `CLK_PERIOD)
		CS = 1'b0;
		RAS = 1'b1;
		CAS = 1'b0;
		WeIn = 1'b1;
		AddrIn = 32'h5A;
		SizeIn = 2'b01;		// Half-word sized transactions
		
		#(`CLK_PERIOD)
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#(6 * `CLK_PERIOD );	// Latency period
		#(31 * `CLK_PERIOD);	// Burst period
		#(3 * `CLK_PERIOD);	// Wait period
		
		#(`CLK_PERIOD)
		$fclose(fd);
		$fclose(fd1);
		$finish;

	end
	
	always
	begin
		#15 Clk = ~Clk;
		if( Clk == 1'b1 )
		begin
			clk_period = clk_period + 1;
			$fdisplay(fd,"%3d,%2d,%2d,%2d,%2d,%2d,0x%x,0x%x,0x%x,%2d,%2d,%2d,%2d,0x%x,%2d",
			clk_period,Rst,WeOut,ReOut,PrechargeOut,ActivateOut,RowAddr,ColAddr,SizeOut,CS,RAS,CAS,WeIn,AddrIn,addr_mode);
			
			$fdisplay(fd1,"%3d,%2d,%2d,%2d,%2d,%2d,%2d,%2d,%2d,%2d,0x%x,%2d",clk_period,Rst,Precharge,Activate,Re,We,AddrGenEn,TimerLd,RwState,LdState,TimerCount,BusySignal);
		end
	end
      
endmodule

