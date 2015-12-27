`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		SJSU, CMPE 240
// Engineer: 		Hemanth Konanur Nagendra
// 
// Create Date:    22:01:02 09/23/2015 
// Design Name: 
// Module Name:    GenericMux 
// Project Name: 
// Target Devices: Simulation only 
// Tool versions: 
// Description: 	 A generic (2^N):1 Mux where N is the number of select lines
//
// Dependencies: 	 None
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GenericMux
#( 
	parameter SEL_WIDTH = 1,		// By default 2:1 Mux
	parameter DATA_WIDTH = 8		// By default data width of each input is 1bit
)
(

	Out,
	In,
	Sel
	
);

	output [ DATA_WIDTH-1:0 ]								Out;		// Mux output
	input	 [ SEL_WIDTH-1:0 ]								Sel;		// Select lines
	input	 [ ((2**SEL_WIDTH)*DATA_WIDTH)-1:0 ]		In;		// Mux input
	
	
	wire	 [ DATA_WIDTH-1:0 ] connect_bus [ (2**SEL_WIDTH)-1:0 ];
	
	genvar gen;
	generate for( gen = 0; gen < (2**SEL_WIDTH); gen = gen + 1 )
	begin:	generate_block_mux
	
		assign connect_bus[(2**SEL_WIDTH)-1-gen]	=	In[ ( ( DATA_WIDTH*gen )+DATA_WIDTH-1 ):(DATA_WIDTH*gen)];
		
	end
	endgenerate
	
	assign Out = connect_bus[Sel];

endmodule
