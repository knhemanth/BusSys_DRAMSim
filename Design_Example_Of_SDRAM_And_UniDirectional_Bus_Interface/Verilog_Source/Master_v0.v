`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:07:40 10/16/2015 
// Design Name: 
// Module Name:    Master 
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
/* The Address line is 32 - bit wide :
 *	Address[32 : 0] -
 * 	Address[32 : 31] - Chip Select
 *		Address[9  :  0] - Address in Slave
 *
 *	The Control Line is 10 - bit wide :
 *	Control[9 : 0] -
 *		Control[9 : 8] - Status
 * 	Control[7 : 4] - Burst Length
 * 	Control[3 : 1] - Size
 * 	Control[0]     - Write Enable
 *
 */


`define STATE_IDLE 		        3'b000
`define STATE_REQUEST_BUS       3'b001
`define STATE_TRANSACT_SINGLE   3'b010
`define STATE_TRANSACT_MULTI    3'b011
`define STATE_BUSY_NOT_READY	  3'b100
`define STATE_TRANSACT_LAST     3'b101

`define HIGH 1'b1
`define LOW  1'b0

`define BUS_HIGH `HIGH
`define BUS_LOW  `LOW

`define MASTER_INACTIVE 1'b0
`define MASTER_ACTIVE   1'b1

`define ACK_HIGH 1'b1
`define ACK_LOW  1'b0

`define SIZE_B  2'b00
`define SIZE_HW 2'b01
`define SIZE_W  2'b10
`define SIZE_DW 2'b11

`define WE 1'b1
`define RE 1'b0

`define STATUS_START 2'b00
`define STATUS_CONT  2'b01
`define STATUS_IDLE  2'b10
`define STATUS_BUSY  2'b11

module Master(
	clk,
	en,
	reset,
	Control, /* Control Signal consisting of Status, Burst Length, Size and Write Enable */
	Address, /* Address provided to the slave */
	WData,	/* Data to be written to the slave */
	Req,		/* Request Line to the arbiter to request for the ownership of the bus */
	Ready,	/* Ready Signal from Slave */
	RData, 	/* Data from Slave */
	Ack,		/* Acknowledgement Signal from Arbiter */
	ProgAddress, /* Input Port used to Program Address in MasterAddressMemory*/
	ProgData, /* Input Port usd to Program Data in MasterDataMemory */
	ProgControl, /* Input Port used to Program 7 bit Data in MasterControlMemory */
	Prog     /* Program the Address, Control and Data Memories */
    );

	parameter DELAY = 0;
	parameter MEMORY_DEPTH = 50;
	parameter CLOCKCYCLE = 10;
	
	output reg [8  : 0] Control;
	output reg [31 : 0] Address; 
	output reg [31 : 0] WData;
	output reg Req;
	
	input clk;
	input reset;
	input en; /* Enable Signel. When en = 1, Master State Machine begins to function */
	input Ack;
	input [31 : 0] RData;
	input Ready;
	
	/* Input Ports used to program the Master's inbuild Memory */
	input [31 : 0] ProgAddress;
	input [6 : 0] ProgControl;
	input [31 : 0] ProgData;
	input Prog; // Enable Programming of Address, Control and Data Memories
	
	/* Registers to Use for Working of the Master */
	reg [31 : 0] AddressMemory [MEMORY_DEPTH - 1 : 0];
	reg [6 : 0] ControlMemory [MEMORY_DEPTH - 1 : 0];
	reg [31 : 0] DataMemory [MEMORY_DEPTH - 1 : 0];
	reg [31 : 0] ReadDataMemory [MEMORY_DEPTH - 1 : 0];
	reg [31 : 0] ReadAddressMemory [MEMORY_DEPTH - 1 : 0];
	
//	/* Wires used for Control Signals */
//	reg [1 : 0] Status;
//	reg [3 : 0] BurstLength;
	reg [1 : 0] Size;
//	reg WriteEn;
//	
//	wire [8 : 0] ControlSignalConnection;
	
	reg [15 : 0] BurstMemory[15 : 0]; /* A Lookup Table for the Burst Count */
	
	integer MemIndex;
	integer ReadDataMemIndex;
	integer ReadAddressMemIndex;
	integer i;
	
	reg [31 : 0] DataBuffer;
	reg WriteEnBuffer;
	reg [15 : 0] BurstCount;

	/* The busy condition in this pseudo-master module is generated when a write is followed by a read
    * The 'busy' register is set to '1' when this condition occures, forcing the module to go into the busy state
 	 */
	reg busy;
	
	/* The Master Module is a state machine with 5 states
	 * Write State Machine Details Here 
	*/
	
	reg [2 : 0]PState;
	
	/* Making Connections for Control Signals */
//	assign Control = ControlSignalConnection;
//	assign ControlSignalConnection[8 : 7] = Status;
//	assign ControlSignalConnection[6 : 3] = BurstLength;
//	assign ControlSignalConnection[2 : 1] = Size;
//	assign ControlSignalConnection[0] = WriteEn;
	
	initial
	begin 
		MemIndex = 0;
		PState = `STATE_IDLE;
		
		for(i = 0; i <= 15; i = i + 1)
		begin
			BurstMemory[i] = (2 ** i);
		end
	end
	
	always@(posedge reset)
	begin
		PState = `STATE_IDLE;
		MemIndex = 0;
		ReadDataMemIndex = 0;
		ReadAddressMemIndex = 0;
	end
	
	/* Simulating a Master Busy Condition when a read follows a write */
	always@(*)
	begin
		if((Control[0] == `RE) && (WriteEnBuffer == `WE))
		begin
			busy <= `HIGH;
		end
	end
	
	always@(*)
	begin
		if(busy  == `HIGH)
		begin	
			busy <= #(CLOCKCYCLE) `LOW;
		end
	end
	
	always@(posedge clk)
	begin
		if(Prog == 1'b1)
		begin
			AddressMemory[MemIndex] <= ProgAddress;
			ControlMemory[MemIndex] <= ProgControl;
			DataMemory[MemIndex] <= ProgData;
			MemIndex <= #2 (MemIndex + 1);	
		end
		
		case(PState)
			`STATE_IDLE :
			begin
				case(en)
				`MASTER_INACTIVE :
				begin
					PState <= #(DELAY) `STATE_IDLE;
					Req <= #(DELAY) `BUS_LOW;
				end
				
				`MASTER_ACTIVE : 
				begin
					PState <= #(DELAY) `STATE_REQUEST_BUS;
					Req <= #(DELAY) `BUS_HIGH;
				end
				endcase
			end
			
			`STATE_REQUEST_BUS :
			/* The Master has pending transactions to perform. In this state:
			 * - Master sends a request to the arbiter for the bus.
			 */
			begin
				case(Ack)
					`ACK_HIGH :
					begin
						PState <= #(DELAY) `STATE_TRANSACT_SINGLE;	

						if(ControlMemory[MemIndex][2 : 1] == `SIZE_DW)
						begin
							BurstCount <= #(DELAY) ((2 * BurstMemory[ControlMemory[MemIndex][6 : 3]]) - 1);
						end
						else
						begin
							/* Load the Burst Length and decrement it*/
							BurstCount <= #(DELAY) (BurstMemory[ControlMemory[MemIndex][6 : 3]] - 1);
						end
						
						Control[8 : 7] <= #(DELAY) `STATUS_START;
						//Status <= #(DELAY) `STATUS_START;
						
						Address <= #(DELAY) AddressMemory[MemIndex];
						Control[6 : 0] <= #(DELAY) ControlMemory[MemIndex];
						WData <= #(DELAY) DataBuffer;
						
						if(ControlMemory[MemIndex][0] == `WE)
						begin
							DataBuffer <= #(DELAY) DataMemory[MemIndex];
						end
						
						// Storing Read Address in Read Address Memory
						if(ControlMemory[MemIndex][0] == `RE)
						begin
							ReadAddressMemory[ReadAddressMemIndex] <= AddressMemory[MemIndex];
							ReadAddressMemIndex <= ReadAddressMemIndex + 1;
						end
						
						WriteEnBuffer <= #(DELAY + CLOCKCYCLE) ControlMemory[MemIndex][0];
					
						MemIndex = #(DELAY) MemIndex + 1; // Increment Memory Index						
					end
					
					`ACK_LOW :
					begin
						PState <= #(DELAY) `STATE_REQUEST_BUS;
						Req <= #(DELAY) `BUS_HIGH;
					end
				endcase
			end
			
			`STATE_TRANSACT_SINGLE :
			begin
				 
				if((busy == `HIGH) || (Ready == `LOW))
				begin
					PState <= #(DELAY) `STATE_BUSY_NOT_READY;
					if(busy == `HIGH)
					begin
						Control[8 : 7] <= #(DELAY) `STATUS_BUSY;
					end

					// Hold Address
					// Hold Remaining Controls
					// Hold Data
					// No Read Occures even though data might be available on RData
					
				end
				
				else //(busy == `LOW && Read == `HIGH)
				begin
					if(BurstCount == 0) // Transaction Complete. Load new set of Address, Control
					begin
					
						// Condition in this Master that marks the End of all Transactions until Enabled again.
						// Address = 0xFFFFFFFF, Control = 0x7F, Data = 0xFFFFFFFF
						if((AddressMemory[MemIndex] == 32'hFFFFFFFF) && (ControlMemory[MemIndex] == 7'b1111111) && (DataMemory[MemIndex] == 32'hFFFFFFFF))
						begin
						
							PState <= #(DELAY) `STATE_TRANSACT_LAST;
							Control[8 : 7] <= #(DELAY) `STATUS_IDLE;
							// Do not increment Memory Index as all transactions are done!
							
						end
						else
						begin
					
							PState <= #(DELAY) `STATE_TRANSACT_SINGLE;
							Control[8 : 7] <= #(DELAY) `STATUS_START;

							if(ControlMemory[MemIndex][2 : 1] == `SIZE_DW)
							begin
								BurstCount <= #(DELAY) ((2 * BurstMemory[ControlMemory[MemIndex][6 : 3]]) - 1);
							end
							else
							begin
								/* Load the Burst Length and decrement it*/
								BurstCount <= #(DELAY) (BurstMemory[ControlMemory[MemIndex][6 : 3]] - 1);
							end	
							
							MemIndex <= #(DELAY) (MemIndex + 1); // Increment Memory Index

						end
					end
					else // (BurstCount > 0) ; For Busts of 4 or 8 etc
					begin
						PState <= #(DELAY) `STATE_TRANSACT_MULTI;
						Control[8 : 7] <= #(DELAY) `STATUS_CONT;

						// Decrement BurstCount by 1 for having sent one set of address and controls
						BurstCount <= #(DELAY) (BurstCount - 1);
						MemIndex <= #(DELAY) (MemIndex + 1); // Increment Memory Index

					end
					
					Address <= #(DELAY) AddressMemory[MemIndex];
					Control[6 : 0] <= #(DELAY) ControlMemory[MemIndex];
					WData <= #(DELAY) DataBuffer;
					
					if(ControlMemory[MemIndex][0] == `WE)
					begin
						DataBuffer <= #(DELAY) DataMemory[MemIndex];
					end

					// Storing Read Address in Read Address Memory
					if(ControlMemory[MemIndex][0] == `RE)
					begin
						ReadAddressMemory[ReadAddressMemIndex] <= AddressMemory[MemIndex];
						ReadAddressMemIndex <= ReadAddressMemIndex + 1;
					end
					
					if(WriteEnBuffer == `RE)
					begin
						ReadDataMemory[ReadDataMemIndex] <= RData;
						ReadDataMemIndex <= ReadDataMemIndex + 1;
					end
					
					WriteEnBuffer <= #(DELAY + CLOCKCYCLE) ControlMemory[MemIndex][0];
				end
			end
			
			`STATE_TRANSACT_MULTI : 
			begin
				if((busy == `HIGH) || (Ready == `LOW))
				begin
					PState <= #(DELAY) `STATE_BUSY_NOT_READY;
					if(busy == `HIGH)
					begin
						Control[8 : 7] <= #(DELAY) `STATUS_BUSY;
					end

					// Hold Address
					// Hold Remaining Controls
					// Hold Data
					// No Read Occures even though data might be available on RData
					
				end
				else //(busy == `LOW && Read == `HIGH)
				begin
					if(BurstCount == 0)
					begin
						// Condition in this Master that marks the End of all Transactions until Enabled again.
						// Address = 0xFFFFFFFF, Control = 0x7F, Data = 0xFFFFFFFF
						if((AddressMemory[MemIndex] == 32'hFFFFFFFF) && (ControlMemory[MemIndex] == 7'b1111111) && (DataMemory[MemIndex] == 32'hFFFFFFFF))
						begin
						
							PState <= #(DELAY) `STATE_TRANSACT_LAST;
							Control[8 : 7] <= `STATUS_IDLE;
							// Do not increment Memory Index as all transactions are done!
							
						end
						else
						begin
						
							PState <= #(DELAY) `STATE_TRANSACT_SINGLE;
							Control[8 : 7] <= #(DELAY) `STATUS_START;

							if(ControlMemory[MemIndex][2 : 1] == `SIZE_DW)
							begin
								BurstCount <= #(DELAY) ((2 * BurstMemory[ControlMemory[MemIndex][6 : 3]]) - 1);
							end
							else
							begin
								/* Load the Burst Length and decrement it*/
								BurstCount <= #(DELAY) (BurstMemory[ControlMemory[MemIndex][6 : 3]] - 1);
							end
							
							MemIndex <= #(DELAY) MemIndex + 1; // Increment Memory Index					

						end
					end
					else // if(BurstCount > 0)
					begin
						PState <= #(DELAY) `STATE_TRANSACT_MULTI;
						Control[8 : 7] <= #(DELAY) `STATUS_CONT;
						
						// Decrement BurstCount by 1 for having sent one set of address and controls
						BurstCount <= #(DELAY) (BurstCount - 1);
						MemIndex <= #(DELAY) MemIndex + 1; // Increment Memory Index					

					end
												
					Address <= #(DELAY) AddressMemory[MemIndex];
					Control[6 : 0] <= #(DELAY) ControlMemory[MemIndex];				
					WData <= #(DELAY) DataBuffer;
					
					if(ControlMemory[MemIndex][0] == `WE)
					begin
						DataBuffer <= #(DELAY) DataMemory[MemIndex];
					end
					
					// Storing Read Address in Read Address Memory
					if(ControlMemory[MemIndex][0] == `RE)
					begin
						ReadAddressMemory[ReadAddressMemIndex] <= AddressMemory[MemIndex];
						ReadAddressMemIndex <= ReadAddressMemIndex + 1;
					end
					
					if(WriteEnBuffer == `RE)
					begin
						ReadDataMemory[ReadDataMemIndex] <= RData;
						ReadDataMemIndex <= ReadDataMemIndex + 1;
					end
					
					WriteEnBuffer <= #(DELAY + CLOCKCYCLE) ControlMemory[MemIndex][0];
					
				end
			end
			
			`STATE_BUSY_NOT_READY : 
			begin
				if((busy == `HIGH) || (Ready == `LOW))
				begin
					PState <= #(DELAY) `STATE_BUSY_NOT_READY;
					if(busy == `HIGH)
					begin
						Control[8 : 7] <= #(DELAY) `STATUS_BUSY;
					end

					// Hold Address
					// Hold Remaining Controls
					// Hold Data
					// No Read Occures even though data might be available on RData
				end
				else // if(busy == `LOW && READ == `HIGH)
				begin
					if(BurstCount == 0)
					begin
						// Condition in this Master that marks the End of all Transactions until Enabled again.
						// Address = 0xFFFFFFFF, Control = 0x7F, Data = 0xFFFFFFFF
						if((AddressMemory[MemIndex] == 32'hFFFFFFFF) && (ControlMemory[MemIndex] == 7'b1111111) && (DataMemory[MemIndex] == 32'hFFFFFFFF))
						begin
						
							PState <= #(DELAY) `STATE_TRANSACT_LAST;
							Control[8 : 7] <= `STATUS_IDLE;
							// Do not increment Memory Index as all transactions are done!
							
						end
						else
						begin
							
							PState <= #(DELAY) `STATE_TRANSACT_SINGLE;
							Control[8 : 7] <= #(DELAY) `STATUS_START;
							
							if(ControlMemory[MemIndex][2 : 1] == `SIZE_DW)
							begin
								BurstCount <= #(DELAY) ((2 * BurstMemory[ControlMemory[MemIndex][6 : 3]]) - 1);
							end
							else
							begin
								/* Load the Burst Length and decrement it*/
								BurstCount <= #(DELAY) (BurstMemory[ControlMemory[MemIndex][6 : 3]] - 1);
							end;
							
							MemIndex <= #(DELAY) (MemIndex + 1); // Increment Memory Index		
							
						end
					end
					else // if(BurstCount > 0)			
					begin
					
						PState <= #(DELAY) `STATE_TRANSACT_MULTI;
						Control[8 : 7] <= #(DELAY) `STATUS_CONT;
						
						// Decrement BurstCount by 1 for having sent one set of address and controls
						BurstCount <= #(DELAY) (BurstCount - 1);
						MemIndex <= #(DELAY) (MemIndex + 1); // Increment Memory Index		

					end
					
					Address <= #(DELAY) AddressMemory[MemIndex];
					Control[6 : 0] <= #(DELAY) ControlMemory[MemIndex];
					WData <= #(DELAY) DataBuffer;
					
					if(ControlMemory[MemIndex][0] == `WE)
					begin
						DataBuffer <= #(DELAY) DataMemory[MemIndex];
					end
					
					if(WriteEnBuffer == `RE)
					begin
						ReadDataMemory[ReadDataMemIndex] <= RData;
						ReadDataMemIndex <= ReadDataMemIndex + 1;
					end
					
					WriteEnBuffer <= #(DELAY + CLOCKCYCLE) ControlMemory[MemIndex][0];

				end
			end
			
			`STATE_TRANSACT_LAST :
			begin
				if(Ready == `LOW)
				begin
					PState <= #(DELAY) `STATE_TRANSACT_LAST;
				end
				else
				begin
					PState <= #(DELAY) `STATE_IDLE;
					Req <= #(DELAY) `LOW;
				end
							
				WData <= #(DELAY) DataBuffer;
				
				if(WriteEnBuffer == `RE)
				begin
					ReadDataMemory[ReadDataMemIndex] <= RData;
				end
			end
		endcase
		
//		/* Post Case Assignments */
//		Control[8 : 7] <= Status;
//		Control[6 : 3] <= BurstLength;
//		Control[2 : 1] <= Size;
//		Control[0] <= WriteEn;
		
	end

endmodule
