`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 San Jose State University, CMPE 240
// Engineer: 		 Hemanth Konanur Nagendra
// 
// Create Date:    13:15:58 09/16/2015 
// Design Name: 	 A generic N bit Counter
// Module Name:    NBitCounter 
// Project Name: 	 Assignment 1
// Target Devices: Simulation only
// Tool versions: 
// Description: 	 A generic N bit counter
//
// Dependencies: 	 FullAdder
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define state_s0	2'b00
`define state_s1	2'b01
`define state_s2	2'b10



module NBitCounter
#(parameter COUNT_BITS = 8, parameter PATH_DELAY=3)	// 8-bit counter by default)
(
	 count,
	 clk,
    ld,
	 en,
    rst,
    start_seq
);



output reg [(COUNT_BITS-1):0] count;
input	 [(COUNT_BITS-1):0] start_seq;
input	clk;
input ld;
input en;
input rst;

reg [1:0]present_state;
reg [1:0]next_state;
wire	[COUNT_BITS-1:0]	adder_out;
wire adder_cout;
wire [COUNT_BITS-1:0]adder_inputA;

assign adder_inputA = 1;


// Instance of FullAdder
NBitFullAdder #(.BITWIDTH(COUNT_BITS),.PATH_DELAY(PATH_DELAY)) Counter_Adder (.sum(adder_out), .cout(adder_cout),.a(adder_inputA), .b(count));

// Sequential part of the circuit

always@( posedge clk )
begin

	present_state = next_state;
		
	case( present_state )
	
		`state_s0:	 count <= #(PATH_DELAY) 0;		// Always allow a reset

		`state_s1:	
						if( en == 1'b1 )
						begin
							count <= #(PATH_DELAY) start_seq;
						end
		`state_s2:	
						if( en == 1'b1 )
						begin
							count <= #(PATH_DELAY) adder_out;
						end
	
	endcase
	
end

always@*
begin

	if( rst )
	begin
		next_state <= `state_s0;
	end
	
	else
	begin
		if( ld == 1'b1 )
		begin
			next_state <= `state_s1;
		end
		
		else
		begin
			case(present_state)
			
				`state_s0: next_state <= `state_s2;
				`state_s1: next_state <= `state_s2;
			
			endcase
		end
		
	end

end
endmodule


