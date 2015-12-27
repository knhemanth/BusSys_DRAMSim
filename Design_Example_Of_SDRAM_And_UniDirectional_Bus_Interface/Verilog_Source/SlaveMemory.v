`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:01:15 10/16/2015 
// Design Name: 
// Module Name:    SlaveMemory 
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

`define ADDR_MASK	(8'hFFFFFF00)

module SlaveMemory
(
	DataOut,
	Ready,
	DataIn,
	Addr,
	Control,
	Clk,
	Rst,
	En
);

/* PORTS */
output [31:0] DataOut;
output Ready;

input [31:0] DataIn;
input [31:0] Addr;
input [8:0] Control;

input Clk;
input Rst;
input En;

/* Internal nodes */

// Controller outputs
wire Wen;
wire Ren;

// Data-path inputs and outputs from core memory block

wire [31:0] MDataOut;
wire [31:0] MDataIn;

wire [7:0] MRdAddr;
wire [7:0] MWrAddr;

// Flip-flop inputs for registers holding bytes
wire [7:0] Byte4;
wire [7:0] Byte3;
wire [7:0] Byte2;
wire [7:0] Byte1;

// Tri-state buffer inputs, outputs and enables

wire [31:0] FWBuff_In;		// Full Word buffer input
wire [15:0] HWBuff_In;		// Half Word buffer input
wire [7:0]	BBuff_In;		// Byte buffer input

wire [31:0] FWBuff_Out;		// Full Word buffer output
wire [15:0] HWBuff_Out;	// Half Word buffer output
wire [7:0]	BBuff_Out;		// Byte buffer output

wire FWBuff_En;				// Full Word buffer enable
wire HWBuff_En;				// Half Word buffer enable
wire BBuff_En;					// Byte buffer enable

// Tri-state buffers for reading out the data from the memory
wire [31:0] RdFWBuff_In;	// Full Word buffer input
wire [15:0] RdHWHBuff_In;	// Higher bytes of Half Word
wire [15:0] RdHWLBuff_In;	// Lower bytes of Half Word
wire [7:0]	RdB4Buff_In;	// Byte buffers
wire [7:0]	RdB3Buff_In;
wire [7:0]	RdB2Buff_In;
wire [7:0]	RdB1Buff_In;

wire [31:0] RdFWBuff_Out;	// Full Word buffer output
wire [15:0] RdHWHBuff_Out;	// Higher bytes of Half Word
wire [15:0] RdHWLBuff_Out;	// Lower bytes of Half Word
wire [7:0]	RdB4Buff_Out;	// Byte buffers
wire [7:0]	RdB3Buff_Out;
wire [7:0]	RdB2Buff_Out;
wire [7:0]	RdB1Buff_Out;

wire RdFWBuff_En;	// Full Word buffer Enable
wire RdHWHBuff_En;	// Higher bytes of Half Word
wire RdHWLBuff_En;	// Lower bytes of Half Word
wire RdB4Buff_En;	// Byte buffers
wire RdB3Buff_En;
wire RdB2Buff_En;
wire RdB1Buff_En;

// Multiplexer port wires
wire [31:0] Byte4_MuxIn;
wire [31:0] Byte3_MuxIn;
wire [31:0] Byte2_MuxIn;
wire [31:0] Byte1_MuxIn;

wire [1:0] Byte4_Sel;
wire [1:0] Byte3_Sel;
wire [1:0] Byte2_Sel;
wire [1:0] Byte1_Sel;

// Multiplexer port wires for reading
wire RdAddr_Sel;
wire [15:0] RdAddr_In;

// Multiplexer port wires for the output masking logic
wire [63:0] RdHW_Mux_In;
wire [31:0] RdHW_Mux_Out;
wire RdHW_Mux_Sel;

wire [127:0] RdB_Mux_In;
wire [31:0] RdB_Mux_Out;
wire [1:0] RdB_Mux_Sel;

wire [127:0] RdOut_Mux_In;
wire [31:0] RdOut_Mux_Out;
wire [1:0] RdOut_Mux_Sel; 

// Outputs from address and size registers
wire [31:0] Current_Addr;
wire [1:0]	Current_Size;

// Input for current size register
wire [1:0] Size;
wire Write;

/* Instantiate the controller */
SlaveMemoryCtrl slv_controller
(
	.Wen(Wen),
	.Ren(Ren),
	.Ready(Ready),
	.Control(Control),
	.Clk(Clk),
	.Rst(Rst),
	.En(En)
);

/* Instantiate the memory core */
SlaveMemBlock #(.ADDRWIDTH(8)) slave_memblk
(
	.DataOut(MDataOut),
	.DataIn(MDataIn),
	.RdAddr(MRdAddr),
	.WrAddr(MWrAddr),
	.Ren(Ren),
	.Wen(Wen),
	.Clk(Clk)
);

/* Registers for current read/write address and size */
EnDflipFlop #(.BITWIDTH(32)) Addr_reg
(
	.q(Current_Addr),
	.qbar(),
	.d(Addr),
	.clk(Clk),
	.reset(Rst),
	.en(Ready)
);

EnDflipFlop #(.BITWIDTH(2)) Size_reg
(
	.q(Current_Size),
	.qbar(),
	.d(Size),
	.clk(Clk),
	.reset(Rst),
	.en(Ready)
);

assign Size = Control[2:1];
assign Write = Control[0];

// Mask the last 2-bits of the address, memory block is 32-bit aligned
assign MWrAddr = Current_Addr[9:2];
//assign MRdAddr = Current_Addr[9:2];

/* Handle the datapath */

/*
	We have a set of input tri-state buffers as follows:
	
	1. One 32-bit buffer reading all the lines of the data input.
	2. One 16-bit buffer reading one Half Word from the data input line.
	3. One 8-bit buffer reading a byte from the data input line.
	
	If the transaction size is Full Word or Double Word, buffer "1" will be used.
	If the transaction size is a Half Word, the buffer from "2" will be used.
	If the transaction size is a Byte, the buffer from "3" will be used.
	
	Using these buffers, we drive the input to the memory core.
	Combining them we get a 32-bit data, where each byte is driven based on
	the transaction size.
	
	The masking logic will read a full word from the memory and overwrite the required
	bits of data using the buffers above and write back.

*/

// Connect data-bytes to byte-wise bus
assign MDataIn[31:24] = Byte4;
assign MDataIn[23:16] = Byte3;
assign MDataIn[15:8] = Byte2;
assign MDataIn[7:0] = Byte1;

// Tri-state buffers

genvar bits;
generate

	for( bits = 0; bits < 32; bits = bits+1 )
	begin: Buffer_32BitGen							// Full Word Buffer
	
		bufif1(FWBuff_Out[bits], FWBuff_In[bits], FWBuff_En);
	
	end
	
	for( bits = 0; bits < 16; bits = bits+1 )
	begin: Buffer_16BitGen						// Half Word Buffer
	
		bufif1(HWBuff_Out[bits], HWBuff_In[bits], HWBuff_En);
	
	end
	
	
	for( bits = 0; bits < 8; bits = bits+1 )
	begin: Buffer_8BitGen						// Byte buffer
	
		bufif1(BBuff_Out[bits], BBuff_In[bits], BBuff_En);	
	
	end
	
endgenerate


// Connect the tri-state buffers inputs
assign FWBuff_In 	= DataIn;
assign HWBuff_In = DataIn[15:0];
assign BBuff_In 	= DataIn[7:0];

// Tri-state buffer enables
assign FWBuff_En = 1'b1;
assign HWBuff_En = 1'b1;
assign BBuff_En  = 1'b1;

/* Muliplexer for each byte FF-input */
GenericMux #(.SEL_WIDTH(2), .DATA_WIDTH(8)) Byte4_Mux
(
	.Out(Byte4),
	.In(Byte4_MuxIn),
	.Sel(Byte4_Sel)
);

GenericMux #(.SEL_WIDTH(2), .DATA_WIDTH(8)) Byte3_Mux
(
	.Out(Byte3),
	.In(Byte3_MuxIn),
	.Sel(Byte3_Sel)
);

GenericMux #(.SEL_WIDTH(2), .DATA_WIDTH(8)) Byte2_Mux
(
	.Out(Byte2),
	.In(Byte2_MuxIn),
	.Sel(Byte2_Sel)
);

GenericMux #(.SEL_WIDTH(2), .DATA_WIDTH(8)) Byte1_Mux
(
	.Out(Byte1),
	.In(Byte1_MuxIn),
	.Sel(Byte1_Sel)
);

/* 

	Assign Multiplexer inputs 
	
								FW[1-Byte]	|\
								-----/------|  \
Inputs from Byte			HW[1-Byte]	|    \
Buffer and memory			----/-------|     |    8-bit output to Byte Flip-flop
Core							B[1-Byte]	|     |-------/-------  
								----/-------|     | 
								Mem[1-Byte] |    /
								----/-------|  /
												|/
*/

// 1. Byte 4
assign Byte4_MuxIn[7:0]	= FWBuff_Out[31:24];
assign Byte4_MuxIn[15:8]	= HWBuff_Out[15:8];
assign Byte4_MuxIn[23:16]	= BBuff_Out;
assign Byte4_MuxIn[31:24]		= MDataOut[31:24];

// 1. Byte 3
assign Byte3_MuxIn[7:0]	= FWBuff_Out[23:16];
assign Byte3_MuxIn[15:8]	= HWBuff_Out[7:0];
assign Byte3_MuxIn[23:16]	= BBuff_Out;
assign Byte3_MuxIn[31:24]		= MDataOut[23:16];

// 1. Byte 2
assign Byte2_MuxIn[7:0]	= FWBuff_Out[15:8];
assign Byte2_MuxIn[15:8]	= HWBuff_Out[15:8];
assign Byte2_MuxIn[23:16]	= BBuff_Out;
assign Byte2_MuxIn[31:24]		= MDataOut[15:8];

// 1. Byte 1
assign Byte1_MuxIn[7:0]	= FWBuff_Out[7:0];
assign Byte1_MuxIn[15:8]	= HWBuff_Out[7:0];
assign Byte1_MuxIn[23:16]	= BBuff_Out;
assign Byte1_MuxIn[31:24]		= MDataOut[7:0];

/* 
	Handle the Multiplexer select lines:
	All expressions derived from K-map
*/

// Byte4 Select
and(nodeB4S1, Current_Size[0], Current_Addr[1]);
or(Byte4_Sel[1], nodeB4S1, Current_Size[1]);

and(nodeB4S0, Current_Addr[1], Current_Addr[0]);
or(Byte4_Sel[0], Current_Size[1], nodeB4S0);

// Byte3 Select
assign Byte3_Sel[1] = Byte4_Sel[1];

and(nodeB3S0, ~(Current_Size[0]), ~(Current_Addr[0]), Current_Addr[1]);
or(Byte3_Sel[0], nodeB3S0, Current_Size[1]);

// Byte 2 Select
and(nodeB2S1, Current_Size[0], ~(Current_Addr[1]));
or(Byte2_Sel[1], nodeB2S1, Current_Size[1]);

and(nodeB2S0, ~(Current_Addr[1]), Current_Addr[0]);
or(Byte2_Sel[0], nodeB2S0, Current_Size[1]);

// Byte 1 Select
assign Byte1_Sel[1] = Byte2_Sel[1];

and(nodeB1S0, ~(Current_Size[0]), ~(Current_Addr[1]), ~(Current_Addr[0]));
or(Byte1_Sel[0], nodeB1S0, Current_Size[1]);


/* 
	Read transactions:
	Patch the read address straight away 
	to the memory when 'Write' is low and
	'Ren' is high and 'Ready' is high
*/

// 2:1 Mux to select between delayed and address on the line
GenericMux #(.DATAWIDTH(8)) Read_Mux
(
	.Out(MRdAddr),
	.In(RdAddr_In),
	.Sel(RdAddr_Sel)
);

and(RdAddr_Sel, ~Write, Ren, Ready);
assign RdAddr_In[15:8] = Current_Addr[9:2];
assign RdAddr_In[7:0] = Addr[9:2];

/* 
	Multiplexer and buffering structure similar to that of writing 
	to transfer the right bytes from a memory read transaction to the 
	right lines on the data-bus.
	
	Here we have
	
	1. One Full Word buffer to output a full word to the out port
	2. Two Half Word buffers to output either higher half of the read lines
		or lower half of the read lines from memory.
	3. Four Byte sized buffers to output any one of the bytes onto the module
		output line.
*/

// Generate the tri-state buffers

generate
	for( bits = 0; bits < 32; bits=bits+1)
	begin: RdBuff_FWGen								// FW buffer
		
		bufif1(RdFWBuff_Out[bits], RdFWBuff_In[bits], RdFWBuff_En);
	
	end
	
	for( bits = 0; bits < 16; bits=bits+1)
	begin: RdBuff_HWHGen								// HW high buffer
		
		bufif1(RdHWHBuff_Out[bits], RdHWHBuff_In[bits], RdHWHBuff_En);
	
	end
	
	for( bits = 0; bits < 16; bits=bits+1)
	begin: RdBuff_HWLGen								// HW Low buffer
		
		bufif1(RdHWLBuff_Out[bits], RdHWLBuff_In[bits], RdHWLBuff_En);
	
	end
	
	for( bits = 0; bits < 8; bits=bits+1)
	begin: RdBuff_B4HGen								// Byte4 buffer
		
		bufif1(RdB4Buff_Out[bits], RdB4Buff_In[bits], RdB4Buff_En);
	
	end
	
	for( bits = 0; bits < 8; bits=bits+1)
	begin: RdBuff_B3HGen								// Byte3 buffer
		
		bufif1(RdB3Buff_Out[bits], RdB3Buff_In[bits], RdB3Buff_En);
	
	end
	
	for( bits = 0; bits < 8; bits=bits+1)
	begin: RdBuff_B2HGen								// Byte2 buffer
		
		bufif1(RdB2Buff_Out[bits], RdB2Buff_In[bits], RdB2Buff_En);
	
	end
	
	for( bits = 0; bits < 8; bits=bits+1)
	begin: RdBuff_B1HGen								// Byte1 buffer
		
		bufif1(RdB1Buff_Out[bits], RdB1Buff_In[bits], RdB1Buff_En);
	
	end
	
endgenerate

// Connect the buffer inputs

assign RdFWBuff_In = MDataOut[31:0];
assign RdHWHBuff_In = MDataOut[31:16];
assign RdHWLBuff_In = MDataOut[15:0];
assign RdB4Buff_In = MDataOut[31:24];
assign RdB3Buff_In = MDataOut[23:16];
assign RdB2Buff_In = MDataOut[15:8];
assign RdB1Buff_In = MDataOut[7:0];

// Connect the buffer enables
assign RdFWBuff_En = 1'b1;
assign RdHWHBuff_En = 1'b1;
assign RdHWLBuff_En = 1'b1;
assign RdB4Buff_En = 1'b1;
assign RdB3Buff_En = 1'b1;
assign RdB2Buff_En = 1'b1;
assign RdB1Buff_En = 1'b1;

// 2:1 Mux to select between the two Half Words
GenericMux #(.DATA_WIDTH(32)) RdHW_Mux
(
	.Out(RdHW_Mux_Out),
	.In(RdHW_Mux_In),
	.Sel(RdHW_Mux_Sel)
);

// Assign the mux inputs
assign RdHW_Mux_In[63:48] = 0;
assign RdHW_Mux_In[31:16] = 0;
assign RdHW_Mux_In[47:32] = RdHWHBuff_Out;
assign RdHW_Mux_In[15:0] = RdHWLBuff_Out;

and(RdHW_Mux_Sel, ~(Current_Addr[1]), ~(Current_Addr[0]));

// 4:1 Mux to select between the 4 bytes
GenericMux #(.DATA_WIDTH(32), .SEL_WIDTH(2)) RdB_Mux
(
	.Out(RdB_Mux_Out),
	.In(RdB_Mux_In),
	.Sel(RdB_Mux_Sel)
);

// Assign the mux inputs
assign RdB_Mux_In[127:104] = 0;
assign RdB_Mux_In[95:72] = 0;
assign RdB_Mux_In[63:40] = 0;
assign RdB_Mux_In[31:8] = 0;

assign RdB_Mux_In[103:96] = RdB1Buff_Out;
assign RdB_Mux_In[71:64] = RdB2Buff_Out;
assign RdB_Mux_In[39:32] = RdB3Buff_Out;
assign RdB_Mux_In[7:0] = RdB4Buff_Out;

assign RdB_Mux_Sel[1] = Current_Addr[1];
assign RdB_Mux_Sel[0] = Current_Addr[0];

// 4:1 Mux to select one of the Mux outputs to go on the output line
GenericMux #(.DATA_WIDTH(32), .SEL_WIDTH(2)) RdOut_Mux
(
	.Out(RdOut_Mux_Out),
	.In(RdOut_Mux_In),
	.Sel(RdOut_Mux_Sel)
);

// Assign the Mux inputs
assign RdOut_Mux_In[127:96] = RdB_Mux_Out;
assign RdOut_Mux_In[95:64] = RdHW_Mux_Out;
assign RdOut_Mux_In[63:32] = RdFWBuff_Out;
assign RdOut_Mux_In[31:0] = RdFWBuff_Out;

assign RdOut_Mux_Sel[1] = Current_Size[1];
assign RdOut_Mux_Sel[0] = Current_Size[0];

// Final output port
assign DataOut = RdOut_Mux_Out;

endmodule
