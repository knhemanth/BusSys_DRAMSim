`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:58:58 11/16/2015
// Design Name:   biu_timegen
// Module Name:   /media/hemanthkn/Linux_HDD/Xilinx_ISE/Projects/SJSU_Cmpe_240/Assignments/Project_Assignments/TB_biu_timegen.v
// Project Name:  Project_Assignments
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: biu_timegen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CLK_PERIOD	30

// Master control signals that matter
`define 	READ 	1'b0
`define 	WRITE 1'b1
`define 	START	2'b00
`define	CONT	2'b01
`define	IDLE	2'b10
`define 	BUSY	2'b11

`define NEXT_READ		2'b01
`define NEXT_WRITE	2'b10
`define NEXT_NONE		2'b00

module TB_biu_timegen;

	// Inputs
	reg [7:0] tpre;
	reg [7:0] tcas;
	reg [3:0] tlat;
	reg [2:0] tburst;
	reg [7:0] twait;
	reg [8:0] Control;
	reg [31:0] AddrIn;
	reg prog_mode;
	reg Clk;
	reg Rst;
	reg En;

	// Outputs
	wire [2:0] StateCountOut;
	wire [7:0] TimerCountOut;
	wire RwState;
	wire TimerLd;
	
	// Internal nodes
	wire [7:0] trans_burst_out;
	
	// File handle to record inputs and outputs to file
	integer fd, clk_period;
	
	event transact_done;

	// Instantiate the Unit Under Test (UUT)
	biu_timegen uut (
		.StateCountOut(StateCountOut), 
		.TimerCountOut(TimerCountOut), 
		.RwState(RwState), 
		.TimerLd(TimerLd), 
		.tpre(tpre), 
		.tcas(tcas), 
		.tlat(tlat), 
		.tburst(tburst), 
		.twait(twait), 
		.Control(Control), 
		.AddrIn(AddrIn),
		.prog_mode(prog_mode),
		.Clk(Clk), 
		.Rst(Rst), 
		.En(En)
	);
	
	assign trans_burst_out = uut.trans_burst_out;

	initial begin
		// Initialize Inputs
		tpre = 6;
		tcas = 7;
		tlat = 3;
		tburst = 3;
		twait = 10;
//		Control = 9'h000;
		AddrIn = 0;
		prog_mode = 1'b0;
		Clk = 0;
		Rst = 0;
		En = 1'b1;
		clk_period = 0;
		
		fd = $fopen("biu_timegen_test.txt");
		//$fwrite(fd,"Clk,Rst,En,Control,tpre,tcas,tlat,tburst,twait,AddrIn,StateCountOut,TimerCountOut,TimerLd,RwState\n");

		// Wait 100 ns for global reset to finish
		#10 Rst = 1'b1;
		#10 Rst = 1'b0; En = 1'b1;
		
//		#66 Control = 9'h0;
//        
//		// Add stimulus here
		transact_task(`NEXT_WRITE,0,`WRITE);
		
		// Emulate a reprogram of register file
		AddrIn = 32'h3FFFFFFF;
		
		#(`CLK_PERIOD)
		#3
		tburst = 1;		// Burst length is 2 now
		AddrIn = 32'h000000AB;
		
		$fwrite(fd,"------------------------------------------\n");
		$fwrite(fd,"Changed burst length to %3d\n", 2);
		$fwrite(fd,"------------------------------------------\n");
		
		// Do another read transaction
		transact_task(`NEXT_READ, 0, `WRITE);
		
				// Emulate a reprogram of register file
		AddrIn = 32'h3FFFFFFF;
		
		#(`CLK_PERIOD)
		#3
		tburst = 2;		// Burst length is 4 now
		AddrIn = 32'h000000AB;
		
		$fwrite(fd,"------------------------------------------\n");
		$fwrite(fd,"Changed burst length to %3d\n", 4);
		$fwrite(fd,"------------------------------------------\n");
		
		// Do another read transaction
		transact_task(`NEXT_READ, 0, `READ);
		
				// Emulate a reprogram of register file
		AddrIn = 32'h3FFFFFFF;
		
		#(`CLK_PERIOD)
		#3
		tburst = 3;		// Burst length is 8 now
		AddrIn = 32'h000000AB;
		
		$fwrite(fd,"------------------------------------------\n");
		$fwrite(fd,"Changed burst length to %3d\n", 8);
		$fwrite(fd,"------------------------------------------\n");
		
		// Do another read transaction
		transact_task(`NEXT_WRITE, 5, `READ);		// Request emulation of busy signal at 5th Cycle of burst
		
				// Emulate a reprogram of register file
		AddrIn = 32'h3FFFFFFF;
		
		#(`CLK_PERIOD)
		#3
		tburst = 4;		// Burst length is 16 now
		AddrIn = 32'h000000AB;
		
		$fwrite(fd,"------------------------------------------\n");
		$fwrite(fd,"Changed burst length to %3d\n", 16);
		$fwrite(fd,"------------------------------------------\n");
		
		// Do another read transaction
		transact_task(`NEXT_READ, 10, `WRITE);
		
				// Emulate a reprogram of register file
		AddrIn = 32'h3FFFFFFF;
		
		#(`CLK_PERIOD)
		#3
		tburst = 5;		// Burst length is 32 now
		AddrIn = 32'h000000AB;
		
		$fwrite(fd,"------------------------------------------\n");
		$fwrite(fd,"Changed burst length to %3d\n", 32);
		$fwrite(fd,"------------------------------------------\n");
		
		// Do another write transaction
		transact_task(`NEXT_NONE, 3, `READ);
		

		#300
		$fclose(fd);
		$finish;

	end
	
	always
	begin
		#15 Clk = ~Clk;
		
		if( Clk == 1'b1 )
		begin
			clk_period = clk_period + 1;
		//	$fwrite(fd,"%2d,%d,%d,%x,%x,%x,%x,%x,%x,%x,%x,%x,%d,%d\n",clk_period,Rst,En,Control,tpre,tcas,tlat,
			//				  tburst,twait,AddrIn,StateCountOut,TimerCountOut,TimerLd,RwState);
		end
	end
	
	task transact_task;
		input integer next_cmd;
		input integer busy_cycle;
		input rw;
	begin: TRANS_TASK
	
		integer stat;
	
		// Following steps we need to follow:
		/*
		 *	1. Trigger a master start with control
		 * 2. Wait out the precharge and activation
		 * 3. Call the read or write task
		 */
		 Control[8:7] = `START;
		 Control[0] = rw;
		 Control[6:1] = 0;
		 
		 $fwrite(fd, "======================================================\n");
		 
		 if( rw == `READ )
		 begin
			$fwrite(fd, "Clk period : %3d, beginning read\n\n", clk_period);
		 end
		 
		 else if( rw == `WRITE )
		 begin
			$fwrite(fd, "Clk period : %3d, beginning write\n\n", clk_period);
		 end
		 
		 // Assuming all reset is completed
		 @ (posedge Clk);
		 if( TimerLd == 1'b1 )
		 begin
			$fwrite(fd, "Timer load verified; Clk period: %3d\n", clk_period);
		 end
		 else
		 begin
			$fwrite(fd, "Timer load is not high: FAILED; Clk period: %3d\n", clk_period);
		 end
		 
		 // Issue next control signal
		 if( tburst == 0 )
		 begin
			if( next_cmd == `NEXT_WRITE )
			begin
				#3 Control[8:7] = `START;
					Control[0] = `WRITE;
			end
			
			else if( next_cmd == `NEXT_READ )
			begin
				#3 Control[8:7] = `START;
					Control[0] = `READ;
			end
			
			else
			begin
				#3 Control[8:7] = `IDLE;
			end
			
		 end
		 
		 else
		 begin
			#3 Control[8:7] = `CONT;
		 end
		 
		 // Expected State counter to proceed to state 1, TimerLd to go high and Counter out to be tpre
		 @ (posedge Clk);
		 
		 $fwrite(fd, "Checking for precharge ---> ");
		 if( StateCountOut == 3'b001 )
		 begin
			
			if( TimerCountOut == (tpre+1) )
			begin
				$fwrite(fd, "PASSED\n");
			end
			
			else
			begin
				$fwrite(fd, "FAILED\n");
				$fwrite(fd, "State Count verified but precharge value loaded is incorrect: 0x%x, Expected 0x%x\n", 
								TimerCountOut, (tpre + 1));
			end
			
		 end
		 else
		 begin
			$fwrite(fd, "FAILED\n");
			$fwrite(fd, "State count is invalid: 0x%x, Expected 0x%x\n", StateCountOut, 1);
		 end
		 
		 // Monitor precharge count-out
		 count_down(tpre,0,stat);
		 
		 if( stat == 0 )
		 begin
			$fwrite(fd,"Precharge phase SUCCESSFUL\n\n");
		 end
		 
		 else
		 begin
			$fwrite(fd,"Precharge count-down FAILED\n\n");
		 end
		 
		 if( TimerLd == 1'b1 )
		 begin
			$fwrite(fd, "Timer load verified; Clk period: %3d\n", clk_period);
		 end
		 else
		 begin
			$fwrite(fd, "Timer load is not high: FAILED; Clk period: %3d\n", clk_period);
		 end
		 
		 // Expected State counter to proceed to state 2, TimerLd to go high and Counter out to be tcas
		 @ (posedge Clk);
		 
		 $fwrite(fd, "Checking for activation ---> ");
		 if( StateCountOut == 3'b010 )
		 begin
			
			if( TimerCountOut == (tcas+1) )
			begin
				$fwrite(fd, "PASSED\n");
			end
			
			else
			begin
				$fwrite(fd, "FAILED\n");
				$fwrite(fd, "State Count verified but tcas value loaded is incorrect: 0x%x, Expected 0x%x\n", 
								TimerCountOut, (tcas + 1));
			end
			
		 end
		 else
		 begin
			$fwrite(fd, "FAILED\n");
			$fwrite(fd, "State count is invalid: 0x%x, Expected 0x%x\n", StateCountOut, 2);
		 end
		 
		 // Monitor tcas count-out
		 count_down(tcas,0,stat);
		 
		 if( stat == 0 )
		 begin
			$fwrite(fd,"Activation phase SUCCESSFUL\n\n");
		 end
		 
		 else
		 begin
			$fwrite(fd,"Activation count-down FAILED\n\n");
		 end
		 
		 // Call read or write burst task here
		 if( rw == `READ )
		 begin
			read_task(next_cmd, busy_cycle);
		 end
		 
		 else if( rw == `WRITE )
		 begin
			write_task(next_cmd, busy_cycle);
		 end
		 
		 else
		 begin
			$fwrite("ERROR!!!: Invalid parameters to transact_task\n");
		 end
		 
		 // Wait period
		 if( TimerLd == 1'b1 )
		 begin
			$fwrite(fd, "Timer load verified; Clk period: %3d\n", clk_period);
		 end
		 else
		 begin
			$fwrite(fd, "Timer load is not high: FAILED; Clk period: %3d\n", clk_period);
		 end
		 
		 // Expected State counter to proceed to state 5, TimerLd to go high and Counter out to be twait
		 @ (posedge Clk);
		 
		 $fwrite(fd, "Checking for wait period ---> ");
		 if( StateCountOut == 3'b101 )
		 begin
			if( (tburst == 0) && (rw == `WRITE) )
			begin
				if( TimerCountOut == (twait - 1) )
				begin
					$fwrite(fd, "PASSED\n");
				end
				
				else
				begin
					$fwrite(fd, "FAILED\n");
					$fwrite(fd, "State Count verified but twait value loaded is incorrect: 0x%x, Expected 0x%x\n", 
									TimerCountOut, twait - 1);
				end
			end
			
			else
			begin
				if( TimerCountOut == (twait) )
				begin
					$fwrite(fd, "PASSED\n");
				end
				
				else
				begin
					$fwrite(fd, "FAILED\n");
					$fwrite(fd, "State Count verified but twait value loaded is incorrect: 0x%x, Expected 0x%x\n", 
									TimerCountOut, twait);
				end
			end
			
		 end
		 else
		 begin
			$fwrite(fd, "FAILED\n");
			$fwrite(fd, "State count is invalid: 0x%x, Expected 0x%x\n", StateCountOut, 5);
		 end
		 
		 // Monitor tcas count-out
		 if( (rw == `WRITE) && (tburst == 0) )
		 begin
			count_down(twait-2,0,stat);
		 end
		 
		 else
		 begin
			count_down(twait-1,0,stat);
		 end
		 
		if( stat == 0 )
		begin
			$fwrite(fd,"Wait phase SUCCESSFUL\n\n");
		end

		else
		begin
			$fwrite(fd,"Wait count-down FAILED\n\n");
		end

		// One full transaction is completed
		if( rw == `READ )
		begin
			$fwrite(fd, "Completed READ transaction\n");
		end
		
		else if( rw == `WRITE )
		begin
			$fwrite(fd, "Completed WRITE transaction\n");
		end
		
		$fwrite(fd, "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n\n");
		 	
	end	
	endtask
	
	task read_task;
		input integer next_cmd;
		input integer busy_cycle;
	begin: READ_TASK
	
		integer stat;
		 
		 if( TimerLd == 1'b1 )
		 begin
			$fwrite(fd, "Timer load verified; Clk period: %3d\n", clk_period);
		 end
		 else
		 begin
			$fwrite(fd, "Timer load is not high: FAILED; Clk period: %3d\n", clk_period);
		 end
		 
		 // Expected State counter to proceed to state 2, TimerLd to go high and Counter out to be tcas
		 @ (posedge Clk);
		 
		 $fwrite(fd, "Checking for read latency ---> ");
		 if( StateCountOut == 3'b011 )
		 begin
			
			if( TimerCountOut == (tlat-1) )
			begin
				$fwrite(fd, "PASSED\n");
			end
			
			else
			begin
				$fwrite(fd, "FAILED\n");
				$fwrite(fd, "State Count verified but tlat value loaded is incorrect: 0x%x, Expected 0x%x\n", 
								TimerCountOut, (tlat - 1));
			end
			
		 end
		 else
		 begin
			$fwrite(fd, "FAILED\n");
			$fwrite(fd, "State count is invalid: 0x%x, Expected 0x%x\n", StateCountOut, 3);
		 end
		 
		 // Monitor tcas count-out
		 count_down((tlat-2),0,stat);
		 
		 if( stat == 0 )
		 begin
			$fwrite(fd,"Latency phase SUCCESSFUL\n\n");
		 end
		 
		 else
		 begin
			$fwrite(fd,"Latency count-down FAILED\n\n");
		 end
		 
		 // Burst period
		 if( TimerLd == 1'b1 )
		 begin
			$fwrite(fd, "Timer load verified; Clk period: %3d\n", clk_period);
		 end
		 else
		 begin
			$fwrite(fd, "Timer load is not high: FAILED; Clk period: %3d\n", clk_period);
		 end
		 
		 // Expected State counter to proceed to state 4, TimerLd to go high and Counter out to be tras_burst
		 @ (posedge Clk);
		 
		 $fwrite(fd, "Checking for read burst ---> ");
		 if( StateCountOut == 3'b100 )
		 begin
			
			if( TimerCountOut == (trans_burst_out) )
			begin
				$fwrite(fd, "PASSED\n");
			end
			
			else
			begin
				$fwrite(fd, "FAILED\n");
				$fwrite(fd, "State Count verified but tlat value loaded is incorrect: 0x%x, Expected 0x%x\n", 
								TimerCountOut, trans_burst_out);
			end
			
		 end
		 else
		 begin
			$fwrite(fd, "FAILED\n");
			$fwrite(fd, "State count is invalid: 0x%x, Expected 0x%x\n", StateCountOut, 4);
		 end
		 
		 // Monitor tburst count-out
		 if( busy_cycle != 0 )
		 begin
			count_down((trans_burst_out-1),(busy_cycle),stat);
		 end
		 
		 else
		 begin
			count_down((trans_burst_out-1),1,stat);
		 end
		 
		 if( stat != 0 )
		 begin
			$fwrite(fd,"Read burst count-down FAILED\n\n");
			//$fwrite(fd,"Read burst phase SUCCESSFUL\n\n");
		 end
		 
		 // We have busy period + 1 cycles to complete
		 /*
		  *	1. During busy period, just switch master to busy state.
		  *		The counter should not count down and the state should not progress
		  *	2. After busy period we need to go back to counting down
		  */
		if( busy_cycle != 0 )
		begin
			Control[8:7] = `BUSY;
			repeat (busy_cycle)
			begin
				@ (posedge Clk);
				$fwrite(fd, "Emulating master busy; Clk period: %3d\n", clk_period);
			end
			
			// Busy period is over
			if( StateCountOut != 3'b100 )
			begin
				$fwrite(fd, "Burst phase FAILED. State Counter did not stop when master is busy; Clk period: %3d\n",
							clk_period);
			end
			else
			begin
				Control[8:7] = `CONT;
				
				// Check if down-counters held their values
				if( TimerCountOut != (busy_cycle) )
				begin
					$fwrite(fd,"BUSY phase verification FAILED; Clk Period: %3d\n", clk_period);
					$fwrite(fd,"Expected count-down to stop at %3d, currently counter is at %3d\n", 
								(busy_cycle), TimerCountOut);
				end
				else
				begin
					$fwrite(fd, "BUSY phase verified successfully\n");
					// Let the continue be noticed by the timegen
					@ (posedge Clk);
				end
				
				// Continue down-counting till last but one value
				count_down((busy_cycle-1),1,stat);
			end
		end
		
		else
		begin
			$fwrite(fd,"No busy cycles requested\n");
		end
		  
		if( tburst != 0 )
		begin
		 @ (posedge Clk);	// One burst is already over
		end
		
		if( next_cmd == `NEXT_WRITE )
		begin
			Control[8:7] = `START;
			Control[0] = `WRITE;
		end
		
		else if( next_cmd == `NEXT_READ )
		begin
			Control[8:7] = `START;
			Control[0] = `READ;
		end
		
		else
		begin
			Control[8:7] = `IDLE;
		end
		 
		 if( TimerCountOut != 1 )
		 begin
			$fwrite(fd, "Read burst FAILED: Expected count-down %3d, Current count-down is %3d\n\n", 1, TimerCountOut);
		 end
		 
		 else
		 begin
			$fwrite(fd,"Count-down counter output: %3d, Clk period: %3d\n", TimerCountOut, clk_period);
			$fwrite(fd, "Read burst phase SUCCESSFUL\n\n");
		 end
		 	
	end	
	endtask
	
	task write_task;
		input integer next_cmd;
		input integer busy_cycle;
	begin: WRITE_TASK
	
		integer stat;
		 
		 if( TimerLd == 1'b1 )
		 begin
			$fwrite(fd, "Timer load verified; Clk period: %3d\n", clk_period);
		 end
		 else
		 begin
			$fwrite(fd, "Timer load is not high: FAILED; Clk period: %3d\n", clk_period);
		 end
		 
		 // Expected State counter to proceed to state 4, TimerLd to go high and Counter out to be trans_burst-1
		 @ (posedge Clk);
		 
		 $fwrite(fd, "Checking for write burst ---> ");
		 if( StateCountOut == 3'b100 )
		 begin
			if( tburst == 0 )
			begin
				if( TimerCountOut == 0 )
				begin
					$fwrite(fd, "PASSED\n");
				end
				
				else
				begin
					$fwrite(fd, "FAILED\n");
					$fwrite(fd, "State Count verified but tburst value loaded is incorrect: 0x%x, Expected 0x%x\n", 
									TimerCountOut, 0);
				end
			end		
			
			else
			begin
				if( TimerCountOut == (trans_burst_out - 1) )
				begin
					$fwrite(fd, "PASSED\n");
				end
				
				else
				begin
					$fwrite(fd, "FAILED\n");
					$fwrite(fd, "State Count verified but tburst value loaded is incorrect: 0x%x, Expected 0x%x\n", 
									TimerCountOut, trans_burst_out-1);
				end
			end
			
		 end
		 else
		 begin
			$fwrite(fd, "FAILED\n");
			$fwrite(fd, "State count is invalid: 0x%x, Expected 0x%x\n", StateCountOut, 4);
		 end
		 
		 // Monitor tburst count-out
		 if( busy_cycle != 0 )
		 begin
			count_down((trans_burst_out-2),(busy_cycle),stat);
		 end
		 
		 else
		 begin
			count_down((trans_burst_out-2),1,stat);
		 end
		 
		 if( stat != 0 )
		 begin
			$fwrite(fd,"Write burst count-down FAILED\n\n");
		 end
		 
		 // We have busy period + 1 cycles to complete
		 /*
		  *	1. During busy period, just switch master to busy state.
		  *		The counter should not count down and the state should not progress
		  *	2. After busy period we need to go back to counting down
		  */
		if( busy_cycle != 0 )
		begin
			Control[8:7] = `BUSY;
			repeat (busy_cycle)
			begin
				@ (posedge Clk);
				$fwrite(fd, "Emulating master busy; Clk period: %3d\n", clk_period);
			end
			
			// Busy period is over
			if( StateCountOut != 3'b100 )
			begin
				$fwrite(fd, "Burst phase FAILED. State Counter did not stop when master is busy; Clk period: %3d\n",
							clk_period);
			end
			else
			begin
				Control[8:7] = `CONT;
				
				// Check if down-counters held their values
				if( TimerCountOut != (busy_cycle) )
				begin
					$fwrite(fd,"BUSY phase verification FAILED; Clk Period: %3d\n", clk_period);
					$fwrite(fd,"Expected count-down to stop at %3d, currently counter is at %3d\n", 
								(busy_cycle), TimerCountOut);
				end
				else
				begin
					$fwrite(fd, "BUSY phase verified successfully\n");
					// Let the continue be noticed by the timegen
					@ (posedge Clk);
				end
				
				// Continue down-counting till last but one value
				count_down((busy_cycle-1),1,stat);
			end
		end
		
		else
		begin
			$fwrite(fd,"No busy cycles requested\n");
		end
		  
		if( (tburst > 1) )
		begin
		 @ (posedge Clk);	// One burst is already over
		end
		
		if( next_cmd == `NEXT_WRITE )
		begin
			Control[8:7] = `START;
			Control[0] = `WRITE;
		end
		
		else if( next_cmd == `NEXT_READ )
		begin
			Control[8:7] = `START;
			Control[0] = `READ;
		end
		
		else
		begin
			Control[8:7] = `IDLE;
		end
		 
		if( tburst != 0 )
		begin
			if( TimerCountOut != 1 )
			begin
				$fwrite(fd, "Write burst FAILED: Expected count-down %3d, Current count-down is %3d\n\n", 1, TimerCountOut);
			end

			else
			begin
				$fwrite(fd,"Count-down counter output: %3d, Clk period: %3d\n", TimerCountOut, clk_period);
				$fwrite(fd, "Write burst phase SUCCESSFUL\n\n");
			end
		end
		
		else
		begin
			if( TimerCountOut != 0 )
			begin
				$fwrite(fd, "Write burst FAILED: Expected count-down %3d, Current count-down is %3d\n\n", 1, TimerCountOut);
			end

			else
			begin
				$fwrite(fd,"Count-down counter output: %3d, Clk period: %3d\n", TimerCountOut, clk_period);
				$fwrite(fd, "Write burst phase SUCCESSFUL\n\n");
			end
		end
		 	
	end	
	endtask
	
	task count_down;
		input integer start_count;
		input integer end_count;
		output integer stat;
	begin: COUNT_DOWN_BLOCK
		
		integer old_count;
		
		old_count = start_count + 1;
		$fwrite(fd, "Count-down counter output: %3d; Clk period: %3d\n", TimerCountOut, clk_period);
		
		repeat (start_count-end_count) 
		begin
			@ (posedge Clk);
			
			if( TimerCountOut != old_count - 1)
			begin
				$fwrite(fd, "Verifying count-down FAILED: Clk period %3d\n", clk_period);
				$fwrite(fd, "Expected count-down: %3d, Current value %3d\n", (old_count - 1), TimerCountOut);
				stat = 1;
			end
			
			else
			begin
				$fwrite(fd, "Count-down counter output: %3d; Clk period: %3d\n", TimerCountOut, clk_period);
				old_count = TimerCountOut;
				stat = 0;
			end
		end
	end
	endtask
      
endmodule

