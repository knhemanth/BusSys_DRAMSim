`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:21:20 10/16/2015 
// Design Name: 
// Module Name:    Arbiter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This module models a unidirectional bus arbiter in a 
// 				 system with 2 masters and 4 slaves. 
// 				 The Req Inputs have an order of priority as below:
//              	Req[0] - Lowest Priority
//              	Req[1] - Highest Priority
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define STATE_IDLE 2'b00     /* State - IDLE */
`define STATE_MASTER1 2'b10  /* State - Master 1 [High Priority] */
`define STATE_MASTER2 2'b01  /* State - Master 2 [Low Priority]  */

`define ACK_MASTER1 2'b10    /* Ack for Master 1 */
`define ACK_MASTER2 2'b01    /* Ack for Master 2 */
`define ACK_NONE 2'b00       /* No Ack */

`define REQ_NONE 2'b00		  /* Request on 'Req' from No Master */
`define REQ_MASTER1 2'b10    /* Request on 'Req' from Master 1 Only */
`define REQ_MASTER2 2'b01    /* Request on 'Req' from Master 2 Only */
`define REQ_MASTER_1_2 2'b11 /* Request on 'Req' from Master 1 and 2 */

module Arbiter(
	clk,   // Clock
	reset, // Reset
	Ack,   // Output Port for Ack
	Req    // Input Port for Req
    );
	 
	parameter DELAY = 2;
	
	output [1:0] Ack; /* 2 Bit Acknowledge Output to each of the 2 masters */
	input [1:0] Req;  /* 2 Bit Request Input from each of the 2 masters */
	input clk;			/* Clock Signal */
	input reset;      /* Reset Signal for the Module */
	
	reg [1:0] AckReg;
	
	reg [1 : 0] PState; /* Present State of the Arbiter */
	reg [1 : 0] NState; /* Next State of the Arbiter */
	
	initial
	begin
		PState = `STATE_IDLE;
	end
	
	always@(posedge reset)
	begin
		PState <= `STATE_IDLE;
		AckReg <= `ACK_NONE;
	end
	
	always@(posedge clk)
	begin
		case(PState)
			`STATE_IDLE :
			begin
				case(Req)
					`REQ_NONE:
					begin
						NState <= `STATE_IDLE;
						AckReg <= `ACK_NONE;
					end
					
					`REQ_MASTER1:
					begin
						NState <= `STATE_MASTER1;
						AckReg <= `ACK_MASTER1;
					end
					
					`REQ_MASTER2:
					begin
						NState <= `STATE_MASTER2;
						AckReg <= `ACK_MASTER2;
					end
					
					`REQ_MASTER_1_2:
					begin
						NState <= `STATE_MASTER1;
						AckReg <= `ACK_MASTER1;
					end
				endcase
			end
			
			`STATE_MASTER1: /* High Priority Master */
			begin
				case(Req)
					`REQ_NONE :
					begin
						NState <= `STATE_IDLE;
						AckReg <= `ACK_NONE;
					end
					
					`REQ_MASTER1 :
					begin
						NState <= `STATE_MASTER1;
						AckReg <= `ACK_MASTER1;
					end
					
					`REQ_MASTER2 : 
					begin
						NState <= `STATE_MASTER2;
						AckReg <= `ACK_MASTER2;
					end
					
					`REQ_MASTER_1_2 :
					begin
						NState <= `STATE_MASTER1;
						AckReg <= `ACK_MASTER1;
					end
				endcase
				
			end
			
			`STATE_MASTER2: /* Low Priority Master */
			begin
				case(Req)
					`REQ_NONE :
					begin
						NState <= `STATE_IDLE;
						AckReg <= `ACK_NONE;
					end
					
					`REQ_MASTER1 : 
					begin
						NState <= `STATE_MASTER1;
						AckReg <= `ACK_MASTER1;
					end
					
					`REQ_MASTER2 :
					begin
						NState <= `STATE_MASTER2;
						AckReg <= `ACK_MASTER2;
					end
					
					`REQ_MASTER_1_2:
					begin
						NState <= `STATE_MASTER2;
						AckReg <= `ACK_MASTER2;
					end
				endcase
			end
		endcase
		
		PState <= NState;	
	end
	
	assign #(DELAY) Ack = AckReg;

endmodule
