`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:01:22 11/09/2015
// Design Name:   sdram_timegen
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_sdram_timegen.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sdram_timegen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_sdram_timegen;

	// Inputs
	reg [7:0] tpre;
	reg [7:0] tcas;
	reg [3:0] tlat;
	reg [7:0] tburst;
	reg [7:0] twait;
	reg CS;
	reg RAS;
	reg CAS;
	reg WeIn;
	reg Clk;
	reg Rst;
	reg En;

	// Outputs
	wire [7:0] TimeGenCountOut;
	wire [2:0] StateCountOut;
	
	
	// File handle to record inputs and outputs to file
	integer fd, clk_period;

	// Instantiate the Unit Under Test (UUT)
	sdram_timegen uut (
		.TimerCountOut(TimeGenCountOut), 
		.StateCountOut(StateCountOut),
		.tpre(tpre), 
		.tcas(tcas), 
		.tlat(tlat),
		.tburst(tburst), 
		.twait(twait), 
		.CS(CS),
		.RAS(RAS),
		.CAS(CAS),
		.WeIn(WeIn),
		.Clk(Clk), 
		.Rst(Rst), 
		.En(En)
	);


	initial begin
		// Initialize Inputs
		tpre = 5;
		tcas = 6;
		tburst = 7;
		twait = 1;
		tlat = 2;
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		Clk = 0;
		Rst = 0;
		En = 0;
		clk_period = 0;
		
		fd = $fopen("sdram_timegen_test.txt");
		$fdisplay(fd, "INPUTS\t\t\t\t\t|\t\t\t\t\tOUTPUTS");
		$fdisplay(fd, "====================================================\n");
		$fdisplay(fd, "Fixed inputs: TPRE = %x;",tpre,"TCAS = %x;",tcas,"TBURST = %x;",tburst,"TWAIT = %x\n",twait);	

		// Wait 20 ns for global reset to finish
		#10 Rst = 1'b1;
		#13 Rst = 1'b0; En = 1'b1;
        
		// Add stimulus here
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b0;
		
		#30
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#150
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#30
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
//		#75 En = 1'b0;
//		#30 En = 1'b1;
		
		#180
		CS = 1'b0;
		RAS = 1'b1;
		CAS = 1'b0;
		WeIn = 1'b0;
		
		
		#30
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
//		#60 CS = 1'b0;
//		RAS = 1'b1;
//		CAS = 1'b1;
//		WeIn = 1'b0;
		
		#30
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#120
		#210
//		#240
		
		#60
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b0;
		
		#30
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#150
		CS = 1'b0;
		RAS = 1'b0;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#30
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
//		#75 En = 1'b0;
//		#30 En = 1'b1;
		
		#180
		CS = 1'b0;
		RAS = 1'b1;
		CAS = 1'b0;
		WeIn = 1'b1;
		
		
		#30
		CS = 1'b1;
		RAS = 1'b1;
		CAS = 1'b1;
		WeIn = 1'b1;
		
		#120
		
		#30
		$fclose(fd);
		$finish;

	end

	always
	begin
		#15 Clk = ~Clk;
		
		if( Clk == 1'b1 )
		begin
			clk_period = clk_period + 1;
			$fdisplay(fd, "Clk_period = %2d, Rst = %x, TimeGenCountOut = %x, StateCountOut= %x, CS = %2d, RAS = %2d, CAS = %2d, WeIn = %2d\n", 
		               clk_period, Rst , TimeGenCountOut, StateCountOut,CS,RAS,CAS,WeIn);
		end
	end
      
endmodule

