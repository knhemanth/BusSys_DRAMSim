`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:45:07 11/16/2015
// Design Name:   biu_regfile
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_biu_regfile.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: biu_regfile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CLK_PERIOD	30

module TB_biu_regfile;

	// Inputs
	reg Clk;
	reg Rst;
	reg MasterBusy;
	reg [31:0] AddrIn;
	reg [31:0] DataIn;
	reg En;

	// Outputs
	wire [2:0] tburst;
	wire addr_mode;
	wire [3:0] tlat;
	wire [7:0] tpre;
	wire [7:0] twait;
	wire [7:0] tcas;
	wire prog_mode;	
	
	// File handle to record inputs and outputs to file
	integer fd, clk_period;

	// Instantiate the Unit Under Test (UUT)
	biu_regfile uut (
		.tburst(tburst), 
		.addr_mode(addr_mode), 
		.tlat(tlat), 
		.tpre(tpre), 
		.twait(twait), 
		.tcas(tcas), 
		.prog_mode(prog_mode),
		.Clk(Clk), 
		.Rst(Rst), 
		.MasterBusy(MasterBusy), 
		.AddrIn(AddrIn), 
		.DataIn(DataIn), 
		.En(En)
	);
	
	initial begin
		// Initialize Inputs
		Clk = 0;
		Rst = 0;
		MasterBusy = 0;
		AddrIn = 0;
		DataIn = 0;
		En = 0;
		clk_period = 0;
		
		fd = $fopen("biu_regfile_test.txt");
		$fdisplay(fd,"Clock period,Reset,MasterBusy,AddrIn,DataIn,En,tburst,addr_mode,tlat,tpre,twait,tcas,prog_mode\n");	

		// Wait One clock cycle for global reset to finish
		#10 Rst = 1'b1; En = 1'b1;
		#(`CLK_PERIOD + 3) Rst = 1'b0;
        
		// Add stimulus here
		#(`CLK_PERIOD)
		AddrIn = 32'h3FFFFFFF;
		
		#(`CLK_PERIOD)
		AddrIn = 32'h01234567;
		DataIn = 32'h060708AF;
		
		#(`CLK_PERIOD)
		AddrIn = 32'h3FFFFFFF;
		DataIn = 0;
		
		#(`CLK_PERIOD)
		DataIn = 32'hABCDEF12;
		MasterBusy = 1'b1;
		
		#(`CLK_PERIOD)
		MasterBusy = 1'b0;
		
		#(`CLK_PERIOD)
		En = 1'b0;
		
		#(2 * `CLK_PERIOD)
		$fclose(fd);
		$finish;

	end
	
	always
	begin
		#((`CLK_PERIOD)/2) Clk = ~Clk;
		
		if( Clk == 1'b1 )
		begin
			clk_period = clk_period + 1;
			$fdisplay(fd,"%2d,%d,%d,%x,%x,%d,%x,%d,%x,%x,%x,%x,%d\n",clk_period,Rst,MasterBusy,AddrIn,DataIn,En,
															tburst,addr_mode,tlat,tpre,twait,tcas,prog_mode);
		end
	end
      
endmodule

