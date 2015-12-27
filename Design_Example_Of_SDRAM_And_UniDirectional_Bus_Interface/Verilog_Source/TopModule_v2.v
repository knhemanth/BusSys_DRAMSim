`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:37:59 10/18/2015 
// Design Name: 
// Module Name:    TopModule 
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
module TopModule_v2(
	clk, 		// Clock Signal 
	reset,   // Global Reset
	trigger, // Input Signal used to trigget the masters
	prog,
	progaddress,
	progdata,
	progcontrol
	);
	
	input clk;
	input reset;
	input trigger;
	
	input prog;
	input [31 : 0] progaddress;
	input [31 : 0] progdata;
	input [6  : 0] progcontrol;
	
	// Wires for Master 1
	wire master1_req;
	wire master1_ack;
	wire master1_ready;
	wire master1_prog;
	
	wire [8 : 0]  master1_control;
	wire [31 : 0] master1_address;
	wire [31 : 0] master1_wdata;
	wire [31 : 0] master1_rdata;
	wire [31 : 0] master1_progaddress;
	wire [31 : 0] master1_progdata;
	wire [6 :  0] master1_progcontrol;
	
	// Wires for Master 2
	wire master2_req;
	wire master2_ack;
	wire master2_ready;
	wire master2_prog;
	
	wire [8 :  0] master2_control;
	wire [31 : 0] master2_address;
	wire [31 : 0] master2_wdata;
	wire [31 : 0] master2_rdata;
	wire [31 : 0] master2_progaddress;
	wire [31 : 0] master2_progdata;
	wire [6 :  0] master2_progcontrol;
	
	// Wires for Arbiter
	wire [1 : 0] arbiter_ack;
	wire [1 : 0] arbiter_req;
	
	// Wires for AddressMux
	wire [31 : 0] mux_address_out;
	wire [31 : 0] mux_address_in_master1;
	wire [31 : 0] mux_address_in_master2;
	wire [1 :  0] mux_address_ack;
	
	// Wires for DataMux
	wire [31 : 0] mux_data_out;
	wire [31 : 0] mux_data_in_master1;
	wire [31 : 0] mux_data_in_master2;
	wire [1 :  0] mux_data_ack;
	
	// Wires for ControlMux
	wire [8 : 0] mux_control_out;	
	wire [8 : 0] mux_control_in_master1;
	wire [8 : 0] mux_control_in_master2;
	wire [1 : 0] mux_control_ack;
	
	// Wire for all Slave
	wire [3  : 0] slave_en;
/* 
	slave_rdata_ready[32] = ready signal
	slave_rdata_ready[31 : 0] = rdata; */
	
	wire [32 : 0] slave_rdata_ready;
	wire [1 : 0 ] slave_output_sel;
	
	// Wires for Slave 0
	wire slave0_en;
	wire [31 : 0] slave0_address;
	wire [31 : 0] slave0_wdata;
	wire [8  : 0] slave0_control;
	wire [32 : 0] slave0_rdata_ready;
	
	// Wires for Slave 1
	wire slave1_en;
	wire [31 : 0] slave1_address;
	wire [31 : 0] slave1_wdata;
	wire [8  : 0] slave1_control;
	wire [32 : 0] slave1_rdata_ready;
	
	// Wires for Slave 2
	wire slave2_en;
	wire [31 : 0] slave2_address;
	wire [31 : 0] slave2_wdata;
	wire [8  : 0] slave2_control;
	wire [32 : 0] slave2_rdata_ready;
	
	// Wires for Slave 3
	wire slave3_en;
	wire [31 : 0] slave3_address;
	wire [31 : 0] slave3_wdata;
	wire [8  : 0] slave3_control;
	wire [32 : 0] slave3_rdata_ready;

	// Connections to Master 1'
	assign master1_progaddress = progaddress;
	assign master1_progdata = progdata;
	assign master1_progcontrol = progcontrol;
	assign master1_prog = prog;
	
	assign master1_ack = arbiter_ack[1];
	assign master1_rdata = slave_rdata_ready[31 : 0];
	assign master1_ready = slave_rdata_ready[32];
	
	// Connections to Master 2
	assign master2_progaddress = progaddress;
	assign master2_progdata = progdata;
	assign master2_progcontrol = progcontrol;
	assign master2_prog = prog;
	assign master2_ack = arbiter_ack[0];
	
	assign master1_ack = arbiter_ack[1];
	assign master1_rdata = slave_rdata_ready[31 : 0];
	assign master1_ready = slave_rdata_ready[32];

	// Connections from Master to Arbiter
	
	assign arbiter_req[0] = master2_req;
	assign arbiter_req[1] = master1_req;
	
	// Connections to mux_address
	assign mux_address_in_master1 = master1_address;
	assign mux_address_in_master2 = master2_address;
	assign mux_address_ack = arbiter_ack;
	
	// Connections to control_address
	assign mux_control_in_master1 = master1_control;
	assign mux_control_in_master2 = master2_control;
	assign mux_control_ack = arbiter_ack;
	
	// Connections to data_address
	assign mux_data_in_master1 = master1_wdata;
	assign mux_data_in_master2 = master2_wdata;
	assign mux_data_ack = arbiter_ack;
	
	// Connections to Slave 0
	assign slave0_en = slave_en[0];
	assign slave0_address = mux_address_out;
	assign slave0_wdata = mux_data_out;
	assign slave0_control = mux_control_out;
	
	// Connections to Slave 1
	assign slave1_en = slave_en[1];
	assign slave1_address = mux_address_out;
	assign slave1_wdata = mux_data_out;
	assign slave1_control = mux_control_out;
	
	// Connections to Slave 2
	assign slave2_en = slave_en[2];
	assign slave2_address = mux_address_out;
	assign slave2_wdata = mux_data_out;
	assign slave2_control = mux_control_out;

	// Connections to Slave 3
	assign slave3_en = slave_en[3];
	assign slave3_address = mux_address_out;
	assign slave3_wdata = mux_data_out;
	assign slave3_control = mux_control_out;

	Arbiter arbiter (.clk(clk), .reset(reset), .Ack(arbiter_ack), .Req(arbiter_req));
	
	Master_v1 master1 (.clk(clk), 
						 .en(trigger), 
						 .reset(reset),
						 .EControl(master1_control),
						 .EAddress(master1_address),
						 .EWData(master1_wdata),
						 .Req(master1_req),
						 .Ready(master1_ready),
						 .RData(master1_rdata),
						 .Ack(master1_ack),
						 .ProgAddress(master1_progaddress),
						 .ProgControl(master1_progcontrol),
						 .ProgData(master1_progdata),
						 .Prog(master1_prog)
						 );
						 
	Master_v1 master2 (.clk(clk), 
						 .en(trigger), 
						 .reset(reset),
						 .EControl(master2_control),
						 .EAddress(master2_address),
						 .EWData(master2_wdata),
						 .Req(master2_req),
						 .Ready(master2_ready),
						 .RData(master2_rdata),
						 .Ack(master2_ack),
						 .ProgAddress(master2_progaddress),
						 .ProgControl(master2_progcontrol),
						 .ProgData(master2_progdata),
						 .Prog(master2_prog)
						 );
						 
	SpecializedMux #(.DATA_BITWIDTH(32)) mux_address(
																	 .out(mux_address_out),
																	 .in1(32'hz),
																	 .in2(mux_address_in_master1),
																	 .in3(mux_address_in_master2),
																	 .in4(32'hz),
																	 .sel(mux_address_ack)
																	);
																	
	SpecializedMux #(.DATA_BITWIDTH(32)) mux_data(
															    .out(mux_data_out),
																 .in1(32'hz),
																 .in2(mux_data_in_master1),
																 .in3(mux_data_in_master2),
																 .in4(32'hz),
																 .sel(mux_data_ack)
																);
	
	SpecializedMux #(.DATA_BITWIDTH(9)) mux_control(
																	 .out(mux_control_out),
																	 .in1(9'hz),
																	 .in2(mux_control_in_master1),
																	 .in3(mux_control_in_master2),
																	 .in4(9'hz),
																	 .sel(mux_control_ack)
																	);
																	
	ADL adl_instance(
						  .address(mux_address_out), 
						  .slave_en(slave_en),
						  .slave_output_sel(slave_output_sel)
						  );
															
	// Slave 0
	Slave_BIU_SDRAM SDRAMSlave(
								.DataOut(slave0_rdata_ready[31 : 0]),
								.Ready(slave0_rdata_ready[32]),
								.DataIn(slave0_wdata),
								.Address(slave0_address),
								.Control(slave0_control),
								.clk(clk),
								.reset(reset),
								.en(slave0_en)	
								);

	// Slave 1
	SlaveMemory slave1(
							.DataOut(slave1_rdata_ready[31 : 0]),
							.Ready(slave1_rdata_ready[32]),
							.DataIn(slave1_wdata),
							.Addr(slave1_address),
							.Control(slave1_control),
							.Clk(clk),
							.Rst(reset),
							.En(slave1_en)
								);
	// Slave 2
	SlaveMemory slave2(
							.DataOut(slave2_rdata_ready[31 : 0]),
							.Ready(slave2_rdata_ready[32]),
							.DataIn(slave2_wdata),
							.Addr(slave2_address),
							.Control(slave2_control),
							.Clk(clk),
							.Rst(reset),
							.En(slave2_en)
								);
	// Slave 3
	SlaveMemory slave3(
							.DataOut(slave3_rdata_ready[31 : 0]),
							.Ready(slave3_rdata_ready[32]),
							.DataIn(slave3_wdata),
							.Addr(slave3_address),
							.Control(slave3_control),
							.Clk(clk),
							.Rst(reset),
							.En(slave3_en)
								);

	SpecializedMux #(.DATA_BITWIDTH(33)) mux_slave_output(
																	.out(slave_rdata_ready),
																	.in1(slave3_rdata_ready),
																	.in2(slave2_rdata_ready),
																	.in3(slave1_rdata_ready),
																	.in4(slave0_rdata_ready),
																	.sel(slave_output_sel)
																	);


endmodule
