`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:35:08 10/16/2015 
// Design Name: 
// Module Name:    SlaveMemoryCtrl 
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

`define DELAY 3

/* Data sizes */
`define BYTE	2'b00
`define HW		2'b01
`define FW		2'b10
`define DW		2'b11

module SlaveMemoryCtrl(
	Wen,
	Ren,
	Ready,
	Control,
	Clk,
	Rst,
	En
);

output Ready;
output Wen;
output Ren;

input [8:0] Control;
input Clk;
input Rst;
input En;

wire Wen;
wire Ren;

wire [1:0] state;
wire [3:0] burst;
wire [1:0] size;
wire write;

wire [2:0] rdy_comp_a;
wire [2:0] rdy_comp_b;
wire rdy_comp_out;
wire [1:0] rdy_count_out;
wire rdy_count_ld;
wire rdy_count_en;
wire rdy_count_rst;
wire [1:0] rdy_mux_in;
wire [1:0] start_seq_mux_out;
wire start_seq_sel;
wire write_count_en;
wire inv_count0;
wire inv_count1;

assign state = Control[8:7];
assign burst = Control[6:3];
assign size  = Control[2:1];
assign write = Control[0];

assign rdy_comp_a[1:0] = size;
assign rdy_comp_b[1:0] = `FW;
assign rdy_comp_a[2] = 1'b0;
assign rdy_comp_b[2] = 1'b0;

assign rdy_mux_in[0] = rdy_comp_out;
assign rdy_mux_in[1] = 1'b1;
 

/* Controller implementation */

// 1. Ready signal - using counter decoder

NBitComparator #(.BITWIDTH(3)) ready_comp(
	.out(rdy_comp_out),
	.a(rdy_comp_a),
	.b(rdy_comp_b)
);

/* 2:1 Mux for handling counter enable */
GenericMux #(.DATA_WIDTH(1)) rdy_mux(
	.Out(rdy_count_en),
	.In(rdy_mux_in),
	.Sel(Ready)
);

/* 2:1 Mux for handling counter loading */
GenericMux #(.DATA_WIDTH(2)) start_seq_mux(
	.Out(start_seq_mux_out),
	.In(4'b0111),				// We will be loading the mux with either a '1' or a '3'
	.Sel(start_seq_sel)
);

/* 2-bit counter */
NBitCounter #(.COUNT_BITS(2)) rdy_counter(
	 .count(rdy_count_out),
	 .clk(Clk),
    .ld(rdy_count_ld),
	 .en(write_count_en),
    .rst(rdy_count_rst),
    .start_seq(start_seq_mux_out)
);

/* Decoder */
and(node1, ~(rdy_count_out[1]), ~(rdy_count_out[0]));
and(node2, rdy_count_out[1], rdy_count_out[0]);
//and(noderdy1, rdy_count_out[1], ~(rdy_count_out[0]));
or #(`DELAY) (Ready, node1, node2); //noderdy1

// Enable signal
and(count_en, rdy_count_en, En);
and(start_seq_sel, write, node1, ~rdy_comp_out);
and(node3, rdy_count_out[1], rdy_count_out[0]);
or(rdy_count_ld, node3, start_seq_sel);
or(write_count_en, rdy_count_en, start_seq_sel);

// Reset counter
and(node4, Ready, ~write);
and(node7, node3, ~En);
and(node8, ~(rdy_count_out[1]), ~(rdy_count_out[0]), ~(En));
or(rdy_count_rst, Rst, node4, node7, node8);

// 2. Wen for Memory block
and #(`DELAY)(Wen, rdy_count_out[1], rdy_count_out[0]);

// 3. Ren for Memory block
and #(`DELAY)(node5, ~(rdy_count_out[1]), rdy_count_out[0]);	// While writing
and (node6, Ready, ~write, En);												// While reading
or #(`DELAY) (Ren, node5, node6);


endmodule
