`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:22 11/09/2015 
// Design Name: 
// Module Name:    sdram_timegen 
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

`define IDLE_STATE		3'b000
`define PRECHARGE_STATE	3'b001
`define ACTIVATE_STATE	3'b010
`define READ_STATE		3'b011
`define WRITE_STATE		3'b100
`define WAIT_STATE		3'b101

module sdram_timegen
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
	CS,
	RAS,
	CAS,
	WeIn,
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
input [7:0] tburst;
input [7:0] twait;

input CS;
input RAS;
input CAS;
input WeIn;
input	Clk;
input	Rst;
input	En;

/* Mux inputs and outputs */
wire [7:0] LdvalOut;
wire [7:0] mux_tlat_in;
wire [7:0] mux_tburst_in;
wire [7:0] mux_tpre_in;
wire [7:0] mux_tcas_in;
wire [7:0] mux_twait_out;
wire [7:0] sub_tburst_in;
wire [7:0] sub_tlat_in;
wire [7:0] sub_twait_out;
wire [7:0] add_tpre_in;
wire [7:0] add_tcas_in;
wire [7:0] int_mux_out;
wire int_mux_sel;
wire twait_sel;
wire rw_out;
wire rw_en;
wire rw_reset;
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

/* Make tburst 1 less than the actual value, one data packet will be there with the command */

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

Mux2to1 int_mux
(
	.DataOut(int_mux_out),
	.In1(mux_tlat_in),
	.In2(mux_tburst_in),
	.Sel(int_mux_sel)
);

Mux2to1 wait_mux
(
	.DataOut(mux_twait_out),
	.In1(twait),
	.In2(sub_twait_out),
	.Sel(twait_sel)
);

and(int_mux_sel, ~(CS), (RAS), ~(CAS), ~(WeIn));

/* Align inputs */
assign sub_tlat_in[7:4] = 1'b0;
assign sub_tlat_in[3:0] = tlat;
//assign sub_tburst_in[7:3] = 1'b0;
//assign sub_tburst_in[2:0] = tburst;
assign sub_tburst_in = tburst;
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

/* This counter counts only when command is issued and the timing generator output is a 0 or 1 */
and(prog_mode, ~(CS), ~(RAS), ~(CAS), ~(WeIn));
xnor(prog_mode_true, prog_mode, 1'b1);
and(self_refresh_mode, ~(CS), ~(RAS), ~(CAS), (WeIn));
xnor(self_refresh_cmd_true, self_refresh_mode, 1'b1);
and(cmd_true, ~(prog_mode_true), ~(self_refresh_cmd_true), ~(CS));
and(timegen_count_0, ~timegen_out[7], ~timegen_out[6], ~timegen_out[5], ~timegen_out[4], 
     ~timegen_out[3],  ~timegen_out[2],  ~timegen_out[1],  ~timegen_out[0] ); 
and(timegen_count_1, ~timegen_out[7], ~timegen_out[6], ~timegen_out[5], ~timegen_out[4], 
     ~timegen_out[3],  ~timegen_out[2],  ~timegen_out[1],  timegen_out[0] );
or( timegen_count_1_or_0, timegen_count_1, timegen_count_0 );
and(state_read, ~StateCountOut[2], StateCountOut[1], StateCountOut[0]);
and(state_write, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0]);
or(state_burst, state_read, state_write);
and(state_burst_end, state_burst, timegen_count_1_or_0);
and( state_cnt_en_node1, timegen_count_1_or_0, cmd_true);
or(state_cnt_en_node2, state_cnt_en_node1, state_burst_end);
and(state_cnt_en, state_cnt_en_node2, En);

// twait select logic
and(twait_sel_node1, StateCountOut[2], ~StateCountOut[1], ~StateCountOut[0], timegen_count_1, ~rw_out);
and(twait_sel, timegen_count_0, 1'b1);

// Load this timer to write state when write command is issued
and(write_cmd, ~(CS), (RAS), ~(CAS), ~(WeIn));

// Reset state after wait period, If wait period is 0, reset state after burst state
and(burst_stop, ~(CS), (RAS), (CAS), ~(WeIn));
and(wait_is_zero, ~twait[7], ~twait[6], ~twait[5], ~twait[4], ~twait[3], ~twait[2], ~twait[1], ~twait[0]);
and(burst_stop_rst, state_burst, burst_stop);
and(state_cnt_rst_wait, wait_is_zero, state_burst_end);
and(state_cnt_rst_node, StateCountOut[2], ~StateCountOut[1], StateCountOut[0], timegen_count_1);
or(state_cnt_rst, state_cnt_rst_node, state_cnt_rst_wait, burst_stop_rst, Rst);

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

assign timegen_ld = state_cnt_en;
// Keep this counter enabled only if there is a load signal or count is NOT 1 or 0
xnor(timegen_cmp_is1, timegen_count_1, 1'b1);
xnor(timegen_cmp_is0, timegen_count_0, 1'b1);
or(timegen_cmp_is_1_or_0, timegen_cmp_is1, timegen_cmp_is0);
or(timegen_en_node1, ~(timegen_cmp_is_1_or_0), timegen_ld);
and(timegen_en, timegen_en_node1, En);
or(timegen_rst, Rst, burst_stop_rst);


assign TimeGenCountOut = timegen_out;

EnDflipFlop RWSignal 
(
	.q(rw_out),
	.qbar(),
	.d(1'b1),
	.clk(Clk),
	.reset(rw_reset),
	.en(rw_en)

);

assign rw_en = RwState;

and(rw_reset, ~(CS), RAS, ~(CAS), WeIn);

endmodule
