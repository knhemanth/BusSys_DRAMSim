`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:10:33 11/16/2015
// Design Name:   biu_controls
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_biu_controls.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: biu_controls
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CLK_PERIOD	30

`define 	READ 	1'b0
`define 	WRITE 1'b1

`define 	START	2'b00
`define	CONT	2'b01
`define	IDLE	2'b10
`define 	BUSY	2'b11

module TB_biu_controls;

	// Inputs
	reg [8:0] Control;
	reg [31:0] AddrIn;
	reg [31:0] DataIn;
	reg Clk;
	reg Rst;
	reg En;

	// Outputs
	wire CS;
	wire RAS;
	wire CAS;
	wire WE;
	wire Ready;
	wire StoreReg;
	wire EnRdata;
	wire EnWdata;
	wire [1:0] AddrSel;
	
	// Time period
	integer clk_period;
	integer transaction_id;
	integer fd;
	
	// Internal register storing a list of commands from bus master
	/*
	 *	List of tests
	 * 1. Program register file - Status = start, control = write, Addr = 3FFFFFFF
	 * 2. a. Issue register file data - DataIn = 0503043A [tcas(05) twait(03) tpre(04) tlat(3) addr_mode(1) burst(2) ]
			b. Issue first transaction - Status = start, control = write, Addr = 0xAB
			
			// Burst length 4
	 *	3. Status = CONT		// Data 1
	 * 4. Status = CONT		// Data 2
	 * 5. Status = CONT		// Data 3
	 * 6. Status = Start, control = read
	 * 7. Status = CONT		// Read data 1
	 * 8. Status = CONT		// Read data 2
	 * 9. Status = BUSY		
	 * 10. Status = BUSY
	 * 11. Status = CONT		// Read data 3
	 * 12. Status = BUSY
	 * 13. Status = START, control = write, AddrIn = 3FFFFFFF
	 * 14. Status = START, control = write, DataIn = 05050751
	 
			// Burst length = 2
			
	 * 15. Status = CONT		// Write Data 1
	 * 16. Status = BUSY	
	 * 17. Status = BUSY	
	 * 18. Status = START, control = write		// Write Data 2 + new controls
	 * 19. Status = CONT		// Write Data 1
	 * 20. Status = START, control = read		// Write data 2 + new controls
	 * 21. Status = CONT		// Read Data 1
	 * 22. Status = START, control = write, AddrIn = 3FFFFFFF
	 * 23. Status = START, control = read, DataIn = 090a1b9
	 
			// Burst length = 1
			
	 * 24. Status = START, control = read
	 * 25. Status = START, control = write
	 * 26. Status = BUSY
	 * 27. Status = BUSY
	 * 28. Status = start, control = write,  AddrIn = 3FFFFFFF
	 * 29. Status = start, control = write, DataIn = 070301F3
			
			// Burst length = 8
	 * 30. Status = CONT
	 * 31. Status = CONT
	 * 32...35 Status = BUSY
	 * 36..40 Status = CONT
	 * 37. Status = START, control = read
	 * 38..44 Status = CONT
	 * 39. Status = START, control = write, AddrIn = 3FFFFFFF
	 * 40. Status = START, control = read, DataIn = 01010105
	 
			// Burst length = 32
			
	 * 41..71 Status = CONT
	 * 72. Status = START, control = write
	 * 73..104 Status = CONT
	 * 74. Status = START, control = write, AddrIn = 3FFFFFFF
	 * 75. Status = START, control = read, DataIn = 01010106
	 
			// Burst length = 64
			
	 * 76..125 Status = CONT
	 * 126..130 Status = BUSY
	 * 131..143 Status = CONT
	 * 144 Status = START, control = write, AddrIn = 3FFFFFFF
	 * 145 Status = START, control = read, DataIn = 01010107
	 
			// Burst length = 255 [Full page]
	 * 146..399 Status = CONT
	 * 400 Status = IDLE
	 */
	reg [40:0] master_signal[399:0];
	reg [40:0] master_out;
	
	integer master_index;
	reg [31:0] master_address;
	reg [8:0] master_control;


	// Instantiate the Unit Under Test (UUT)
	biu_controls uut (
		.CS(CS), 
		.RAS(RAS), 
		.CAS(CAS), 
		.WE(WE), 
		.Ready(Ready), 
		.StoreReg(StoreReg),
		.EnRdata(EnRdata),
		.EnWdata(EnWdata),
		.AddrSel(AddrSel), 
		.Control(Control), 
		.AddrIn(AddrIn), 
		.DataIn(DataIn), 
		.Clk(Clk), 
		.Rst(Rst), 
		.En(En)
	);
	
	

	initial begin
		
		// Program the master register
		for( master_index = 0; master_index < 400; master_index=master_index+1 )
		begin
		
			master_control[8:7] = `CONT;
			master_address = 32'h000000AB;
		
			// First 32 bits address and then 9 bits of control
			/* 1. START cases */
			if( (master_index == 0) || (master_index == 1) || (master_index == 5) ||
				 (master_index == 12) || (master_index == 13) || (master_index == 17) ||
				 (master_index == 19) || (master_index == 21) || (master_index == 22) || 
				 (master_index == 27) ||
				 (master_index == 28) || (master_index == 40) || (master_index == 41) ||
				 (master_index == 73) ||
				 (master_index == 143) || (master_index == 144)
			  )
			begin
				master_address = 32'h000000AB;
				master_control = {{`START},{6'b0},{`READ}};
			end
			
			/* Write cases */
			if( (master_index == 0) || (master_index == 1) || (master_index == 12) ||
				 (master_index == 13) || (master_index == 17) || (master_index == 21) ||
				 (master_index == 24) || (master_index == 27) || (master_index == 28) ||
				 (master_index == 38) || (master_index == 73) ||
				 (master_index == 143)
			  )
			begin
				master_control[0] = `WRITE;
			end
			
			/* Program mode cases */
			if( (master_index == 0) || (master_index == 12) || (master_index == 21) || (master_index == 22) ||
				 (master_index == 27) ||(master_index == 41) ||
				 (master_index == 143)
			  )
			begin
				master_address = 32'h3FFFFFFF;
			end
			
			/* BUSY cases */
			if( (master_index == 8) || (master_index == 9) ||
				 (master_index == 15) || (master_index == 16) || (master_index == 25) ||
				 (master_index == 31) || (master_index == 32) ||
				 (master_index == 33) || (master_index == 34) || (master_index == 125) ||
				 (master_index == 126) || (master_index == 127) || (master_index == 128) ||
				 (master_index == 129)
			  )
			begin
				master_control[8:7] = `BUSY;
			end
			
			if( master_index >= 74 )
			begin
				master_control[8:7] = `IDLE;
			end
			
			master_signal[master_index] = {{master_address},{master_control}};
		end
		
		// Initialize Inputs
		master_index = 0;
		AddrIn = 32'h3FFFFFFF;
		Control = 9'h000000001;
		DataIn = 32'h0503043A;
		clk_period = 0;
		transaction_id = 0;
		Clk = 0;
		Rst = 0;
		En = 0;
		
		fd = $fopen("biu_controls_test.txt");
		$fwrite(fd, "Clk,Transaction ID,Rst,En,Control,AddrIn,DataIn,CS,RAS,CAS,WE,Ready,StoreReg,EnRdata,EnWdata,AddrSel\n\n");

		// Wait one clock cycle for global reset to finish
		#3 Rst = 1'b1;
		#66 Rst = 1'b0; En = 1'b1;
		
        
//		// Add stimulus here
//		#30 DataIn = 32'h030705AA; AddrIn = 32'h0;
//		#690 Control = 9'h180;
//		#60 Control = 9'h000;
//		#60 Control = 9'h100;
//		#450 Control = 9'h001;
//		
//		#360 Control = 9'h181;
//		#60 Control = 9'h001;
//		
//		#30 Control = 9'h000;
	

	end
	
	always
	begin
		#(`CLK_PERIOD/2) Clk = ~Clk;
		
		if( Clk == 1'b1 )
		begin
			clk_period = clk_period + 1;
			
			// Log all the inputs and outputs for every clock period
			$fwrite(fd, "%3d,%3d,%2d,%2d,%b,0x%x,0x%x,%2d,%2d,%2d,%2d,%2d,%2d,%2d,%2d,%2d\n",
				   clk_period,transaction_id,Rst,En,Control,AddrIn,DataIn,CS,RAS,CAS,WE,Ready,StoreReg,EnRdata,EnWdata,AddrSel);
			
		end
	end
	
	always@(posedge Clk)
	begin
	
		if( master_index > 72 )
		begin
			/* Do nothing */
			master_index = master_index + 1;
			
			if( master_index == 77 )
			begin
				$fclose(fd);
				$finish;
			end
		end
		else if( ((Ready == 1'b1) && (Rst == 1'b0 )) ||
			 ((master_index == 8) || (master_index == 9) || (master_index == 11) ||
			 (master_index == 15) || (master_index == 16) || (master_index == 25) ||
			 (master_index == 26) || (master_index == 31) || (master_index == 32) ||
			 (master_index == 33) || (master_index == 34) || (master_index == 125) ||
			 (master_index == 126) || (master_index == 127) || (master_index == 128) ||
			 (master_index == 129))
		  )
		begin
			#3 master_out = master_signal[master_index];
			#3 master_index = master_index + 1;
			
			Control <= master_out[8:0];
			AddrIn <= master_out[40:9];
			
			if(master_index == 14)
				DataIn = 32'h05050751;
			if(master_index == 23)
				DataIn = 32'h090a1b0;
			if(master_index == 29)
				DataIn = 32'h070301F3;
			if(master_index == 40)
				DataIn = 32'h01010105;
			if(master_index == 75)
				DataIn = 32'h01010106;
			if(master_index == 145)
				DataIn = 32'h01010107;
				
			if( (master_index == 1) || (master_index == 2) || (master_index == 6) ||
				 (master_index == 13) || (master_index == 14) || (master_index == 18) ||
				 (master_index == 20) || (master_index == 22) || (master_index == 23) ||
				 (master_index == 24) || (master_index == 25) || (master_index == 28) ||
				 (master_index == 29) || (master_index == 37) || (master_index == 39) ||
				 (master_index == 40) || (master_index == 72) || (master_index == 74) ||
				 (master_index == 75) || (master_index == 144) || (master_index == 145)
			  )
			begin
				transaction_id = transaction_id + 1;
			end			
		end
	end
      
endmodule

