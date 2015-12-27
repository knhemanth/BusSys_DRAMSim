`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:21 11/13/2015 
// Design Name: 
// Module Name:    sdram_enable_gen 
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
module sdram_enable_gen
(
	Precharge,
	Activate,
	Re,
	We,
	AddrGenEn,
	TimerLd,
	RwState,
	LdState,
	TimerCount,
	BusySignal,
	Clk,
	Reset
);

output Precharge; // Active High Precharge Signal to Bank
output Activate; // Active High Actiavte Signal to Bank
output Re; // Active High Read Enable to Bank
output We; // Active High Read Enable to Bank
output AddrGenEn; 

input TimerLd; // Load Signal for the timing generator
input RwState; // 1 - Write Command; 0 - Read Command
input [2:0]LdState; // Current State Of Operation of SDRAM
input [7:0] TimerCount;
input Clk; // Clock Signal
input Reset; //  Reset Signal
input BusySignal;


wire re_reset; // Reset Signal for RE Flip Flop
wire re_en; // Enable Signal for RE Flip Flop
wire re_en_ff_out;

wire we_reset; // Reset Signal for WE Flip Flop
wire we_en; // Enable Signal for WE Flip Flop
wire we_en_ff_out;
wire re_we_en;

wire timer_count_2;

EnDflipFlop RESignal 
(
	.q(re_en_ff_out),
	.qbar(),
	.d(1'b1),
	.clk(Clk),
	.reset(re_reset),
	.en(re_en)

);

EnDflipFlop WESignal 
(
	.q(we_en_ff_out),
	.qbar(),
	.d(1'b1),
	.clk(Clk),
	.reset(we_reset),
	.en(we_en)

);

and(timer_count_2, ~TimerCount[7], ~TimerCount[6], ~TimerCount[5], 
    ~TimerCount[4], ~TimerCount[3], ~TimerCount[2], TimerCount[1], ~TimerCount[0]);
	 
and(timer_count_1, ~TimerCount[7], ~TimerCount[6], ~TimerCount[5], 
    ~TimerCount[4], ~TimerCount[3], ~TimerCount[2], ~TimerCount[1], TimerCount[0]);
	 
and(timer_count_0, ~TimerCount[7], ~TimerCount[6], ~TimerCount[5], 
    ~TimerCount[4], ~TimerCount[3], ~TimerCount[2], ~TimerCount[1], ~TimerCount[0]);
	 
or(timer_count_1_or_0, timer_count_1, timer_count_0);
or(timer_count_2_or_1, timer_count_2, timer_count_1);


and(Precharge, TimerLd, ~LdState[2], ~LdState[1], ~LdState[0]);
and(Activate, TimerLd, ~LdState[2], ~LdState[1], LdState[0]);
and(we_en, TimerLd, ~LdState[2], LdState[1], ~LdState[0], RwState);
and(re_en, TimerLd, ~LdState[2], LdState[1], LdState[0]);
//and(we_reset_node, TimerLd, LdState[2], ~LdState[1], LdState[0]);

and(re_reset_node, LdState[2], ~LdState[1], ~LdState[0], timer_count_2_or_1);
and(re_reset_burst1, LdState[2], ~LdState[1], ~LdState[0], timer_count_1);
and(we_reset_node, LdState[2], ~LdState[1], ~LdState[0], timer_count_1_or_0);
or(re_reset, re_reset_node, Reset);
or(we_reset, we_reset_node, Reset);
or (We_node1, we_en, we_en_ff_out);
and#(3)(We, We_node1, ~(timer_count_0), ~BusySignal);
or(Re_node1, re_en, re_en_ff_out);
and#(3)(Re, Re_node1, ~(re_reset_burst1), ~BusySignal);

and(re_we_en_node, TimerLd, ~LdState[2], LdState[1], ~LdState[0]);
or(re_we_en, re_we_en_node, we_en);

assign AddrGenEn = re_we_en;

endmodule
