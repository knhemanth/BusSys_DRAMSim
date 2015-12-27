`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:47:04 11/08/2015
// Design Name:   sdram_regfile
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_sdram_regfile.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sdram_regfile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_sdram_regfile;

	// Inputs
	reg CS;
	reg RAS;
	reg CAS;
	reg WeIn;
	reg Clk;
	reg Rst;
	reg [31:0] AddrIn;

	// Outputs
	wire [7:0] tburst;
	wire addr_mode;
	wire [3:0] tlat;
	wire [7:0] tpre;
	wire [7:0] twait;
	wire [7:0] tcas;
	
	// File handle to record inputs and outputs to file
	integer fd, clk_period;

	// Instantiate the Unit Under Test (UUT)
	sdram_regfile uut (
		.tburst(tburst), 
		.addr_mode(addr_mode), 
		.tlat(tlat), 
		.tpre(tpre), 
		.twait(twait), 
		.tcas(tcas), 
		.CS(CS), 
		.RAS(RAS), 
		.CAS(CAS), 
		.WeIn(WeIn), 
		.Clk(Clk), 
		.Rst(Rst), 
		.AddrIn(AddrIn)
	);

	initial begin
		// Initialize Inputs
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		AddrIn = 0;
		WeIn = 0;
		Clk = 0;
		Rst = 1'b0;
		clk_period = 0;
		
		fd = $fopen("sdram_regfile_test.txt");
		$fdisplay(fd, "Clk_period,Rst,addr_mode,tburst,tpre,tlat,tcas,twait,AddrIn,CS,RAS,CAS,WeIn");
		
		record_result();

		// Wait 20 ns for global reset to finish
		#5  Rst = 1'b1;
		record_result();
		#18 Rst = 1'b0;
		record_result();
        
		// Add stimulus here
		#20 AddrIn = 32'h030303AF;
		CS = 0;
		RAS = 0;
		CAS = 0;
		WeIn = 0;
		record_result();
		
		#20 CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		AddrIn = 32'h050505C6;
		record_result();
		
		#20 CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b0;
		WeIn = 1'b0;
		record_result();
		
		#20 CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		record_result();
		
		#40 
		record_result();
		$fclose(fd);
		$finish;

	end
	
	task record_result;
	begin
		
		
	end
	endtask
	
	always
	begin
		#10 Clk = ~Clk;
		
		if( Clk == 1'b1 )
		begin
			clk_period = clk_period + 1;
			$fdisplay(fd,"%2d,%2d,%2d,%3d,%3d,%3d,%3d,%3d,0x%x,%2d,%2d,%2d,%2d",
						clk_period,Rst,addr_mode,tburst,tpre,tlat,tcas,twait,AddrIn,CS,RAS,CAS,WeIn);
		end
	end
	
endmodule

