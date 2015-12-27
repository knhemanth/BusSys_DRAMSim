`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:04 11/16/2015 
// Design Name: 
// Module Name:    biu_controls 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module biu_controls
(
	CS,
	RAS,
	CAS,
	WE,
	Ready,
	StoreReg,
	EnRdata,
	EnWdata,
	AddrSel,
	Control,
	AddrIn,
	DataIn,
	Clk,
	Rst,
	En
);

output CS;
output RAS;
output CAS;
output WE;
output Ready;
output StoreReg;
output EnRdata;
output EnWdata;
output [1:0] AddrSel;

input [8:0] Control;
input [31:0] AddrIn;
input [31:0] DataIn;
input Clk;
input Rst;
input En;

// Register file ports
wire [2:0] tburst;
wire addr_mode;
wire [3:0] tlat;
wire [7:0] tpre;
wire [7:0] twait;
wire [7:0] tcas;
wire prog_mode;
wire MasterBusy;

/* Control signals from bus master */
wire [1:0] state;
wire [3:0] burst;
wire [1:0] size;
wire write;

// Timing generator ports
wire RwState;
wire TimerLd;
wire timegen_en;
wire [2:0] StateCountOut;
wire [7:0] TimerCountOut;

// Delayed commands issued for writing
wire Delayed_CS;
wire Delayed_RAS;
wire Delayed_CAS;
wire Delayed_WE;
wire Mux_CS_Out;
wire Mux_RAS_Out;
wire Mux_CAS_Out;
wire Mux_WE_Out;

// Rw latch ports
wire rw_ff_en;
wire rw_signal;

assign state = Control[8:7];
assign burst = Control[6:3];
assign size  = Control[2:1];
assign write = Control[0];


// Instantiate register file
biu_regfile regfile
(
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

and(MasterBusy, state[1], state[0], En);

// Instantiate timing generator
biu_timegen timing_generator
(
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
	.En(timegen_en)
);

// Disable timing generator only when in state 2 or 4 and master is busy - this is useful during writes
and(master_busy_node1, ~StateCountOut[2], StateCountOut[1], ~StateCountOut[0], MasterBusy, Ready);
and(master_busy_node2, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0], MasterBusy);
and(timegen_en, ~(master_busy_node1), ~(master_busy_node2));

// Latch r/w control signal at the right time
EnDflipFlop rw_ff
(
	.q(rw_signal),
	.qbar(),
	.d(write),
	.clk(Clk),
	.reset(Rst),
	.en(rw_ff_en)

);

assign rw_ff_en = StoreReg;

// Generate all signals based on timing generator state and timer counts

/* 
 * 1. Ready signal 
 * Goes high when 
		a. State count is 0 and master does not say start and TimerLd is low
		b. Address from the master is 3FFFFFFF - which means booting or programming
		c. State count is 2 and write control signal is high
		d. State count is 4 but timer count out is not 1 in case of write
		e. State count is 4 and read enable is true
		f. Special case - in write phase if burst length is only 1, don't trigger read for more than a cycle
 *
 */
 
// Condition a
and(master_start, ~state[1], ~state[0]);
and(state_zero, ~StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0]);
and(state_five, StateCountOut[2], ~StateCountOut[1], StateCountOut[0]);
and(ready_condition_1, ~(master_start), (state_zero), ~TimerLd);
and(
timegen_one, 
~TimerCountOut[7], ~TimerCountOut[6], ~TimerCountOut[5], ~TimerCountOut[4],
~TimerCountOut[3], ~TimerCountOut[2], ~TimerCountOut[1], TimerCountOut[0]
);

// Condition b
and(
boot_mode_node1,
AddrIn[29], AddrIn[28],
AddrIn[27], AddrIn[26], AddrIn[25], AddrIn[24],
AddrIn[23], AddrIn[22], AddrIn[21], AddrIn[20],
AddrIn[19], AddrIn[18], AddrIn[17], AddrIn[16],
AddrIn[15], AddrIn[14], AddrIn[13], AddrIn[12],
AddrIn[11], AddrIn[10], AddrIn[9], AddrIn[8],
AddrIn[7], AddrIn[6], AddrIn[5], AddrIn[4],
AddrIn[3], AddrIn[2], AddrIn[1], AddrIn[0],
state_zero,
En
);

and(
boot_mode_node2,
AddrIn[29], AddrIn[28],
AddrIn[27], AddrIn[26], AddrIn[25], AddrIn[24],
AddrIn[23], AddrIn[22], AddrIn[21], AddrIn[20],
AddrIn[19], AddrIn[18], AddrIn[17], AddrIn[16],
AddrIn[15], AddrIn[14], AddrIn[13], AddrIn[12],
AddrIn[11], AddrIn[10], AddrIn[9], AddrIn[8],
AddrIn[7], AddrIn[6], AddrIn[5], AddrIn[4],
AddrIn[3], AddrIn[2], AddrIn[1], AddrIn[0],
state_five,
timegen_one,
En
);

or(boot_mode, boot_mode_node1, boot_mode_node2);

// Condition c
and(state_two, ~StateCountOut[2], StateCountOut[1], ~StateCountOut[0]);
and(
timegen_two, 
~TimerCountOut[7], ~TimerCountOut[6], ~TimerCountOut[5], ~TimerCountOut[4],
~TimerCountOut[3], ~TimerCountOut[2], TimerCountOut[1], ~TimerCountOut[0]
);

and(ready_condition_2_node1, state_two, rw_signal, timegen_two, master_start, En);
and(ready_condition_2_node2, state_two, rw_signal, TimerLd, En);
or(ready_condition_2, ready_condition_2_node1, ready_condition_2_node2);

// Condition d
and(ready_condition_3_node1, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0], rw_signal, TimerLd);
//and(ready_condition_3, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0], ~(ready_condition_3_node1));
and(ready_condition_3, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0]);

// special condition
and(
ready_condition_4, 
~tburst[2], ~tburst[1], ~tburst[0], 
~StateCountOut[2], StateCountOut[1], ~StateCountOut[0],
timegen_one
);

// Ready
or(Ready_node1, ready_condition_1, boot_mode, ready_condition_2, ready_condition_3);
and(Ready, Ready_node1, ~(ready_condition_4));

/* 
 * EnRdata and EnWdata signals, state_four is the burst period 
 * Additionally, during write phase we need EnWdata to be high for one
 * cycle in state 2
 */
 
and(state_four, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0]);
and(EnRdata, state_four, ~(rw_signal), En);
and(EnWdata_node1, state_four, rw_signal, En);
and(EnWdata_node2, state_two, rw_signal, timegen_one, En);
or(EnWdata, EnWdata_node1, EnWdata_node2);


/*
 *	Define Precharge, Activation, Read, Write and burst periods 
 */
 
// If state counter is zero and TimerLd is high, CS should be low for precharging
and(precharge_signal, state_zero, TimerLd, En);

// If state counter is one and TimerLd is high, CS should be low for activation
and(state_one, ~StateCountOut[2], ~StateCountOut[1], StateCountOut[0]);
and(activation_signal, state_one, TimerLd, En);

// If state counter is two, TimerLd is high and Write is high then we are in the write period
and(state_two, ~StateCountOut[2], StateCountOut[1], ~StateCountOut[0]);
and(write_signal, state_two, rw_signal, TimerLd, En);

// If state counter is two and Write is low then we are starting the read period
and(read_signal, state_two, ~(rw_signal), TimerLd, En);

// If we are in programming mode and master is not busy, all controls needs to be low

and(all_low, prog_mode, ~(MasterBusy), ~(state_four), ~(state_five), En);

/*
 * 2. CS
 * CS is low in all periods and when entering programming mode
 */

nor(CS, precharge_signal, activation_signal, write_signal, read_signal, all_low);

/*
 * 3. RAS
 * RAS is low in precharge and activation periods and also during programming 
 */
nor(RAS, precharge_signal, activation_signal, all_low);

/*
 *	4. CAS
 * CAS is low in write and read periods and also during programming
 * Special case - CAS is low when master is busy
 */
nor(CAS, write_signal, read_signal, all_low, ~(timegen_en));

/*
 * 5. WE
 * WE is low during precharge, write, Burst stop, master busy and programming periods
 */
and(burst_stop, 
AddrIn[29], AddrIn[28],
AddrIn[27], AddrIn[26], AddrIn[25], AddrIn[24],
AddrIn[23], AddrIn[22], AddrIn[21], AddrIn[20],
AddrIn[19], AddrIn[18], AddrIn[17], AddrIn[16],
AddrIn[15], AddrIn[14], AddrIn[13], AddrIn[12],
AddrIn[11], AddrIn[10], AddrIn[9], AddrIn[8],
AddrIn[7], AddrIn[6], AddrIn[5], AddrIn[4],
~AddrIn[3], ~AddrIn[2], ~AddrIn[1], AddrIn[0],
En
);

nor(WE, precharge_signal, write_signal, burst_stop, ~(timegen_en), all_low);

/* 
 * Trigger store reg to store current address: Should happen in one of the two cases
 *
 * 1. Starting a precharge and master says start OR
 * 2. In the burst phase and master says start
 */

//assign StoreReg = precharge_signal;
and(StoreReg_node1, precharge_signal, master_start);
and(StoreReg_node2, state_four, master_start);
or(StoreReg, StoreReg_node1, StoreReg_node2);

// Select pulses
assign AddrSel[1] = activation_signal;

// The first address for reading should be dispatched at the end of activation period
//and(dispatch_col_addr, ~StateCountOut[2], StateCountOut[2], ~StateCountOut[2], TimerLd );
//assign AddrSel[0] = dispatch_col_addr;
or(AddrSel[0], read_signal, write_signal);

endmodule
