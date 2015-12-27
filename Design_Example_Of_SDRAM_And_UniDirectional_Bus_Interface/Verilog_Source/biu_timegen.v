`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:08 11/16/2015 
// Design Name: 
// Module Name:    biu_timegen 
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

`define ONE_PACKET				8'h00000001
`define TWO_PACKETS				8'h00000002
`define FOUR_PACKETS				8'h00000004
`define EIGHT_PACKETS			8'h00000008
`define SIXTEEN_PACKETS			8'h00000010
`define THIRTY_TWO_PACKETS		8'h00000020
`define SIXTY_FOUR_PACKETS		8'h00000040
`define FULL_PAGE					8'h000000FF

`define IDLE_STATE		3'b000
`define PRECHARGE_STATE	3'b001
`define ACTIVATE_STATE	3'b010
`define READ_STATE		3'b011
`define WRITE_STATE		3'b100
`define WAIT_STATE		3'b101

module biu_timegen
(
	StateCountOut,
	TimerCountOut,
	RwState, 
	TimerLd,
	tpre,
	tcas,
	tlat,
	tburst,
	twait,
	Control,
	AddrIn,
	prog_mode,
	Clk,
	Rst,
	En
);

/* Output ports */
output RwState;
output TimerLd;
output [2:0] StateCountOut;
output [7:0] TimerCountOut;

/* Input ports */
input [7:0] tpre;
input [7:0] tcas;
input [3:0] tlat;
input [2:0] tburst;
input [7:0] twait;
input [8:0] Control;		// Control signals from the bus master
input [31:0] AddrIn;
input prog_mode;
input	Clk;
input	Rst;
input	En;

/* Control signals from bus master */
wire [1:0] state;
wire [3:0] burst;
wire [1:0] size;
wire write;

/* Mux inputs and outputs */
wire [7:0] LdvalOut;
wire [7:0] mux_tlat_in;
wire [7:0] mux_tburst_in;
wire [7:0] mux_tpre_in;
wire [7:0] mux_tcas_in;
wire [7:0] mux_twait_out;
wire [7:0] sub_twait_out;
wire [7:0] sub_tburst_in;
wire [7:0] sub_tlat_in;
wire [7:0] add_tpre_in;
wire [7:0] add_tcas_in;
wire [7:0] int_mux_out;
wire [7:0] trans_burst_out;
wire int_mux_sel;
wire twait_sel;
wire rw_signal;
wire rw_ff_en;
wire [2:0] mux_sel;

/* State counter inputs and outputs */
wire state_cnt_en;
wire state_cnt_rst;
wire state_cnt_ld;
wire state_write;
wire state_read;
wire state_burst;
wire state_burst_end;
wire write_cmd;
wire wait_is_zero;
wire burst_stop;

/* Timing generator inputs and outputs */
wire [7:0] timegen_out;
wire timegen_ld;
wire timegen_en;
wire timegen_rst;
wire cmd_true;
wire prog_mode;
wire self_refresh_mode;
wire self_refresh_cmd_true;
wire prog_mode_true;
wire timegen_count_1;
wire timegen_count_0;
wire timegen_count_1_or_0;
wire timegen_cmp_is1;

assign RwState = int_mux_sel; 
assign TimerLd = timegen_ld;
assign TimerCountOut = timegen_out;

assign state = Control[8:7];
assign burst = Control[6:3];
assign size  = Control[2:1];
assign write = Control[0];

/* Burst is expressed as powers of 2, provide a translation */
Mux8to1 mux_trans_burst
(
	.DataOut(trans_burst_out),
	.In1(`ONE_PACKET),
	.In2(`TWO_PACKETS),
	.In3(`FOUR_PACKETS),
	.In4(`EIGHT_PACKETS),
	.In5(`SIXTEEN_PACKETS),
	.In6(`THIRTY_TWO_PACKETS),
	.In7(`SIXTY_FOUR_PACKETS),
	.In8(`FULL_PAGE),
	.Sel(tburst)
);

/* Multiplexer to select load value to counter */
Mux8to1 mux_ldval
(
	.DataOut(LdvalOut),
	.In1(mux_tpre_in),
	.In2(mux_tcas_in),
	.In3(int_mux_out),
	.In4(sub_tburst_in),
	.In5(mux_twait_out),
	.In6(),
	.In7(),
	.In8(),
	.Sel(mux_sel)
);

Mux2to1 twait_mux
(
	.DataOut(mux_twait_out),
	.In1(twait),
	.In2(sub_twait_out),
	.Sel(twait_sel)
);

Mux2to1 int_mux
(
	.DataOut(int_mux_out),
	.In1(mux_tlat_in),
	.In2(mux_tburst_in),
	.Sel(int_mux_sel)
);

/* Skip latency loading in case of write => Bus master says write enable is high */
assign int_mux_sel = rw_signal;

/* Align inputs */
assign sub_tlat_in[7:4] = 1'b0;
assign sub_tlat_in[3:0] = tlat;
assign sub_tburst_in = trans_burst_out;
assign add_tpre_in = tpre;
assign add_tcas_in = tcas;

NBitAddSub burst_sub
(
    .sum(mux_tburst_in),
    .cout(),
    .a(sub_tburst_in),
    .b(8'b00000001),
	 .sub(1'b1)
);

NBitAddSub twait_sub
(
    .sum(sub_twait_out),
    .cout(),
    .a(twait),
    .b(8'b00000001),
	 .sub(1'b1)
);

NBitAddSub lat_sub
(
    .sum(mux_tlat_in),
    .cout(),
    .a(sub_tlat_in),
    .b(8'b00000001),
	 .sub(1'b1)
);

NBitAddSub tpre_add
(
    .sum(mux_tpre_in),
    .cout(),
    .a(add_tpre_in),
    .b(8'b00000001),
	 .sub(1'b0)
);

NBitAddSub tcas_add
(
    .sum(mux_tcas_in),
    .cout(),
    .a(add_tcas_in),
    .b(8'b00000001),
	 .sub(1'b0)
);

/* Select logic of mux depends on the counter output */
assign mux_sel = StateCountOut;

/* State counter - Instance of 3-bit upcounter */
NBitCounter #(.COUNT_BITS(3)) state_counter
(
	 .count(StateCountOut),
	 .clk(Clk),
    .ld(write_cmd),
	 .en(state_cnt_en),
    .rst(state_cnt_rst),
    .start_seq(`WRITE_STATE)
);

/* 
 * This counter counts only when command is issued and the timing generator output is a 0 or 1 
 * Program mode is true only when the Bus master sends 0x3FFFFFFF as address
 */
and(
prog_mode_1,
AddrIn[29], AddrIn[28],
AddrIn[27], AddrIn[26], AddrIn[25], AddrIn[24],
AddrIn[23], AddrIn[22], AddrIn[21], AddrIn[20],
AddrIn[19], AddrIn[18], AddrIn[17], AddrIn[16],
AddrIn[15], AddrIn[14], AddrIn[13], AddrIn[12],
AddrIn[11], AddrIn[10], AddrIn[9], AddrIn[8],
AddrIn[7], AddrIn[6], AddrIn[5], AddrIn[4],
AddrIn[3], AddrIn[2], AddrIn[1], AddrIn[0],
En
);
or(prog_mode_true, prog_mode_1, prog_mode);
//xnor(prog_mode_true, prog_mode, 1'b1);

/* Go into self refresh mode when address issued is 0x3FFFFFF0 */
and(
self_refresh_mode,
AddrIn[29], AddrIn[28],
AddrIn[27], AddrIn[26], AddrIn[25], AddrIn[24],
AddrIn[23], AddrIn[22], AddrIn[21], AddrIn[20],
AddrIn[19], AddrIn[18], AddrIn[17], AddrIn[16],
AddrIn[15], AddrIn[14], AddrIn[13], AddrIn[12],
AddrIn[11], AddrIn[10], AddrIn[9], AddrIn[8],
AddrIn[7], AddrIn[6], AddrIn[5], AddrIn[4],
~AddrIn[3], ~AddrIn[2], ~AddrIn[1], ~AddrIn[0],
En
);
xnor(self_refresh_cmd_true, self_refresh_mode, 1'b1);


/* Time generator values */
and(timegen_count_0, ~timegen_out[7], ~timegen_out[6], ~timegen_out[5], ~timegen_out[4], 
     ~timegen_out[3],  ~timegen_out[2],  ~timegen_out[1],  ~timegen_out[0] ); 
and(timegen_count_1, ~timegen_out[7], ~timegen_out[6], ~timegen_out[5], ~timegen_out[4], 
     ~timegen_out[3],  ~timegen_out[2],  ~timegen_out[1],  timegen_out[0] );
or( timegen_count_1_or_0, timegen_count_1, timegen_count_0 );

/* 
 * New command from master being issued when 
 * status is NOT BUSY and a read or a write burst is happening
 * Time Counter is either 1 or zero
 */
and(state_read, ~StateCountOut[2], StateCountOut[1], StateCountOut[0]);
and(state_write, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0]);
and(state_wait, StateCountOut[2], ~StateCountOut[1], StateCountOut[0]);
and(master_busy, state[1], state[0], state_write);
and(cmd_true, ~(prog_mode_true), ~(self_refresh_cmd_true), ~master_busy, timegen_count_1_or_0, En);
or(state_burst, state_read, state_write);
and(state_burst_end, state_burst, timegen_count_1);
and( state_cnt_en_node1, timegen_count_1_or_0, cmd_true);
or(state_cnt_en_node2, state_cnt_en_node1, state_burst_end);
and(state_cnt_en, state_cnt_en_node2, En);

// Latch the current r/w control signal
EnDflipFlop rw_ff
(
	.q(rw_signal),
	.qbar(),
	.d(write),
	.clk(Clk),
	.reset(Rst),
	.en(rw_ff_en)

);

and(rw_ff_en, ~StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0], TimerLd, En);

// twait select will depend on read or write
and(twait_sel, timegen_count_0, 1'b1);

/* 
 * Load this timer to write state when write command is issued and 
 * the current state count is 2, i.e., activate stage and time counter has reached 1
 */
and(write_cmd, rw_signal, En, timegen_count_1, ~StateCountOut[2], StateCountOut[1], ~StateCountOut[0]);

// Reset state after wait period, If wait period is 0, reset state after burst state, Reset when master is idle
// Burst stop when address is 0x3FFFFFF1
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
and(master_idle, state[1], ~state[0], timegen_count_1, ~(state_write), ~(state_wait), En);	// Don't consider master going idle in wait period or burst period
and(wait_is_zero, ~twait[7], ~twait[6], ~twait[5], ~twait[4], ~twait[3], ~twait[2], ~twait[1], ~twait[0]);
and(burst_stop_rst, state_burst, burst_stop);
and(state_cnt_rst_wait, wait_is_zero, state_burst_end);
and(state_cnt_rst_node, StateCountOut[2], ~StateCountOut[1], StateCountOut[0], timegen_count_1);
or(state_cnt_rst, state_cnt_rst_node, state_cnt_rst_wait, burst_stop_rst, master_idle, Rst);

/* Timing generator Down-counter */
NBitDownCounter timegen_counter
(
	 .count(timegen_out),
	 .clk(Clk),
    .ld(timegen_ld),
	 .en(timegen_en),
    .rst(timegen_rst),
    .start_seq(LdvalOut)
);

and(timegen_ld, state_cnt_en, ~state_cnt_rst);
// Keep this counter enabled only if there is a load signal or count is NOT 1 or 0
xnor(timegen_cmp_is1, timegen_count_1, 1'b1);
xnor(timegen_cmp_is0, timegen_count_0, 1'b1);
or(timegen_cmp_is_1_or_0, timegen_cmp_is1, timegen_cmp_is0);
or(timegen_en_node1, ~(timegen_cmp_is_1_or_0), timegen_ld);
and(timegen_en, timegen_en_node1, ~(master_busy), En);
or(timegen_rst, Rst, burst_stop_rst);


assign TimeGenCountOut = timegen_out;

endmodule
