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
 * 	Address[32 : 31] - Chip Select
 *	Address[9  :  0] - Address in Slave
 *
 *	The Control Line is 9 - bit wide :
 *	Control[8 : 7] - Status
 * 	Control[6 : 3] - Burst Length
 * 	Control[2 : 1] - Size
 * 	Control[  0  ] - Read/Write Enable
 *
 * The Master is implemented as a state machine with 4 states.
 * State 1 - Idle State - 
 *		Master Waits for an 'en' signel. 
 *		This signal is raised high for 1 clock cycle to enable the state machine. 
 *		Prior to enabling 'en', the Address, Control and Data Memories of the Master are to be programmed as per the transactions to be carried out
 * State 2 - Bus Acquisiton State -
 * 		The Master raises his 'Req' line HIGH and waits for an Ack from the Bus Arbiter.
 *		Once the master has been Ack'd, it transmits the Address and Control of the first transaction.
 * State - 3 - Transact State -
 * 		All the transactions are performed in this state. 
 *		If master goes busy or the ready signal is pulled LOW by the slave, the address, control and data signals are all held in the same state.
 *		The master transacts over the bus as per the uni-directional bus protocol.
 * State - 4 - Last Transaction State - 
 *  	In the current implementation of the master, a particular address, control and data value coded into its programmable 
 * 	    memory will trigger the master
 *		into the Last Transaction State. No more transactions are now pending. Final reads/writes will be performed here.
 *		On completing pending read/writes, the master goes to the IDLE state and waits for the next 'en' pulse.
 */


`define STATE_IDLE 		        3'b00
`define STATE_REQUEST_BUS       3'b01
`define STATE_TRANSACT  		  3'b10
`define STATE_TRANSACT_LAST     3'b11

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

// Defines used to Index into the Control Memory
`define INDEX_READ_WRITE_ENABLE 0
`define INDEX_SIZE 2 : 1
`define INDEX_BURST_LENGTH 6 : 3

`define WE 1'b1
`define RE 1'b0

`define STATUS_START 2'b00
`define STATUS_CONT  2'b01
`define STATUS_IDLE  2'b10
`define STATUS_BUSY  2'b11

`define CHIP_SEL_MASK 31 : 30

module Master(
	clk,
	en,
	reset,
	EControl, /* Control Signal consisting of Status, Burst Length, Size and Write Enable */
	EAddress, /* Address provided to the slave */
	EWData,	/* Data to be written to the slave */
	Req,		/* Request Line to the arbiter to request for the ownership of the bus */
	Ready,	/* Ready Signal from Slave */
	RData, 	/* Data from Slave */
	Ack,		/* Acknowledgement Signal from Arbiter */
	ProgAddress, /* Input Port used to Program Address in MasterAddressMemory*/
	ProgData, /* Input Port usd to Program Data in MasterDataMemory */
	ProgControl, /* Input Port used to Program 7 bit Data in MasterControlMemory */
	Prog     /* Program the Address, Control and Data Memories */
    );

	parameter DELAY = 2;
	parameter MEMORY_DEPTH = 50;
	parameter CLOCKCYCLE = 10;
	
	output [8  : 0] EControl;
	output [31 : 0] EAddress; 
	output [31 : 0] EWData;
	
	reg [8  : 0] Control;
	reg [31 : 0] Address; 
	reg [31 : 0] WData;
	
	output reg Req;
	
	assign EControl = Control;
	assign EAddress = Address;
	assign EWData = WData;
	
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
	reg [6  : 0] ControlMemory [MEMORY_DEPTH - 1 : 0];
	reg [31 : 0] DataMemory [MEMORY_DEPTH - 1 : 0];
	reg [31 : 0] ReadDataMemory [MEMORY_DEPTH - 1 : 0];
	reg [31 : 0] ReadAddressMemory [MEMORY_DEPTH - 1 : 0];
	
//	/* Wires used for Control Signals */
	reg [1 : 0] Status;
	reg [3 : 0] BurstLength;
	reg [1 : 0] Size;
	reg WriteEn;
		
	reg [15 : 0] BurstMemory[15 : 0]; /* Lookup Table for the Burst Count */
	reg [2 : 0] SizeMemory[3 : 0]; /* Lookup Table for Size */
	
	integer MemIndex;
	integer ReadDataMemIndex;
	integer ReadAddressMemIndex;
	integer i;
	
	reg [31 : 0] DataBuffer;
	reg WriteEnBuffer;
	reg [15 : 0] BurstCount;
	reg [31 : 0] AddressBuffer;
	reg slaveShift;

	/* The busy condition in this pseudo-master module is generated when a write is followed by a read
    * The 'busy' register is set to '1' when this condition occures, forcing the module to go into the busy state
 	 */
	reg busy;
	
	/* The Master Module is a state machine with 5 states
	 * Write State Machine Details Here 
	*/
	
	reg [1 : 0]PState;
	
	/* RDataBuffer : Used to ensure no data loss occures while master reads from multiple slaves one after another*/

	reg [31 : 0] RDataBuffer;
	reg RDataBufferRead;
		
	initial
	begin 
		MemIndex = 0;
		PState = `STATE_IDLE;
		
		// Loading Burst Count in Lookup table
		for(i = 0; i <= 15; i = i + 1)
		begin
			BurstMemory[i] = (2 ** i);
		end
		
		// Loading Size Counts in Loopup Table
		SizeMemory[0] = 3'b001;
		SizeMemory[1] = 3'b010;
		SizeMemory[2] = 3'b100;
		SizeMemory[3] = 3'b100;
		
	end
	
	always@(posedge reset)
	begin
		PState = `STATE_IDLE;
		busy = `LOW;

		MemIndex = 0;
		ReadDataMemIndex = 0;
		ReadAddressMemIndex = 0;
		slaveShift = 0;
		RDataBufferRead = 0;
	end
	
	/* Simulating a Master Busy Condition when a read follows a write */
	always@(*)
	begin
		if((Control[0] == `RE) && (WriteEnBuffer == `WE))
		begin
			busy = `HIGH;
		end
	end
	
	always@(*)
	begin
		if(busy  == `HIGH)
		begin	
			busy = #(CLOCKCYCLE) `LOW;
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
					Address <= 32'bz;
					WData <= 32'bz;
					Control <= 9'bz;
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
						PState <= #(DELAY) `STATE_TRANSACT;	

						if(ControlMemory[MemIndex][2 : 1] == `SIZE_DW)
						begin
							BurstCount <= #(DELAY) ((2 * BurstMemory[ControlMemory[MemIndex][`INDEX_BURST_LENGTH]]) - 1);
						end
						else
						begin
							/* Load the Burst Length and decrement it*/
							BurstCount <= #(DELAY) (BurstMemory[ControlMemory[MemIndex][`INDEX_BURST_LENGTH]] - 1);
						end
						
						Control[8 : 7] <= #(DELAY) `STATUS_START;
						Control[6 : 0] <= #(DELAY) ControlMemory[MemIndex];
						//Status <= #(DELAY) `STATUS_START;
						
						Address <= #(DELAY) AddressMemory[MemIndex];
						WData <= #(DELAY) DataBuffer;
						
						if(ControlMemory[MemIndex][`INDEX_READ_WRITE_ENABLE] == `WE)
						begin
							DataBuffer <= #(DELAY) DataMemory[MemIndex];
						end
						
						// Storing Read Address in Read Address Memory
						if(ControlMemory[MemIndex][`INDEX_READ_WRITE_ENABLE] == `RE)
						begin
							ReadAddressMemory[ReadAddressMemIndex] <= AddressMemory[MemIndex];
							ReadAddressMemIndex <= ReadAddressMemIndex + 1;
						end
						
						WriteEnBuffer <= #(CLOCKCYCLE) ControlMemory[MemIndex][`INDEX_READ_WRITE_ENABLE];
						
						MemIndex = #(DELAY) MemIndex + 1; // Increment Memory Index						
					end
					
					`ACK_LOW :
					begin
						PState <= #(DELAY) `STATE_REQUEST_BUS;
						Req <= #(DELAY) `BUS_HIGH;
					end
				endcase
			end
			
			`STATE_TRANSACT:
			begin
				 
				if((busy == `HIGH) || (Ready == `LOW))
				begin
					PState <= #(DELAY) `STATE_TRANSACT;
					if(busy == `HIGH)
					begin
						Control[8 : 7] <= #(DELAY) `STATUS_BUSY;
					end
					else if(Ready == `LOW)
					begin
						Control[8 : 7] <= #(DELAY) `STATUS_CONT;
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
						// New Condition Added : Master should go into pseudo 'BUSY' if a new transaction is done to a different slave
						// while a read is issued.
						
						if(((Address[`CHIP_SEL_MASK]) != (AddressMemory[MemIndex][`CHIP_SEL_MASK]) 
							&& (Control[`INDEX_READ_WRITE_ENABLE] == `RE)) 
							&& (slaveShift == `LOW))
						begin
							// Go to Busy State
							PState <= #(DELAY) `STATE_TRANSACT;
							Control[8 : 7] <= #(DELAY) `STATUS_BUSY;
							slaveShift <= #(DELAY) `HIGH;
													
						end
						else
						begin
							// New Condition : Setting slaveShift `LOW in the next state cycle.
							if(slaveShift == `HIGH)
							begin
								slaveShift <= #(DELAY) `LOW;
								RDataBufferRead <= #(DELAY) `HIGH;
							end
							
							// Lower RDataBufferRead Signal as the Buffered RData has been read
							if(RDataBufferRead == `HIGH)
							begin
								RDataBufferRead <= #(DELAY) `LOW;
							end
							
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
								PState <= #(DELAY) `STATE_TRANSACT;

								// Burst Count is 0 and the termination condition has still not yet arrived.
								// Generate the start address and controls for the the next transaction 
								Address <= #(DELAY) AddressMemory[MemIndex];
								Control[8 : 7] <= #(DELAY) `STATUS_START;
								Control[6 : 0] <= #(DELAY) ControlMemory[MemIndex];
								
								// Load the first Data into the DataBuffer
								if(ControlMemory[MemIndex][`INDEX_READ_WRITE_ENABLE] == `WE)
								begin
									DataBuffer <= #(DELAY) DataMemory[MemIndex];
								end

								if(ControlMemory[MemIndex][`INDEX_SIZE] == `SIZE_DW)
								begin
									BurstCount <= #(DELAY) ((2 * BurstMemory[ControlMemory[MemIndex][`INDEX_BURST_LENGTH]]) - 1);
								end
								else
								begin
									/* Load the Burst Length and decrement it by 1 */
									BurstCount <= #(DELAY) (BurstMemory[ControlMemory[MemIndex][`INDEX_BURST_LENGTH]] - 1);
								end	
								
								if(ControlMemory[MemIndex][`INDEX_READ_WRITE_ENABLE] == `RE)
								begin
									ReadAddressMemory[ReadAddressMemIndex] <= AddressMemory[MemIndex];
									ReadAddressMemIndex <= #(DELAY) ReadAddressMemIndex + 1;
								end
								
								MemIndex <= #(DELAY) (MemIndex + 1); // Increment Memory Index
								
								WriteEnBuffer <= #(CLOCKCYCLE) ControlMemory[MemIndex][`INDEX_READ_WRITE_ENABLE];
								
							end
							
							// Read Data on RData Line
							if(WriteEnBuffer == `RE)
							begin
								RDataBuffer <= #(DELAY) RData;
								
								if(RDataBufferRead == `HIGH)
								begin
									ReadDataMemory[ReadDataMemIndex] <= RDataBuffer;
								end
								else
								begin
									ReadDataMemory[ReadDataMemIndex] <= RData;
								end
								
								ReadDataMemIndex <= #(DELAY) ReadDataMemIndex + 1;
							end		
							
						end
					end
					else // (BurstCount > 0) ; For Busts of 4 or 8 etc
					begin
						PState <= #(DELAY) `STATE_TRANSACT;
						
						// Increment address based on the packet size - using the Size Loopup Table
						Address <= #(DELAY) ( Address + SizeMemory[Control[`INDEX_SIZE]] );

						Control[8 : 7] <= #(DELAY) `STATUS_CONT;
						// Retain rest of the Control Signal
						
						if(Control[`INDEX_READ_WRITE_ENABLE] == `WE)
						begin
							DataBuffer <= #(DELAY) DataMemory[MemIndex];
						end
						
						if(Control[`INDEX_READ_WRITE_ENABLE] == `RE)
						begin
							ReadAddressMemory[ReadAddressMemIndex] <= (Address + SizeMemory[Control[`INDEX_SIZE]]);
							ReadAddressMemIndex <= #(DELAY) ReadAddressMemIndex + 1;
						end

						// Decrement BurstCount by 1 for having sent one set of address and controls
						BurstCount <= #(DELAY) (BurstCount - 1);
						MemIndex <= #(DELAY) (MemIndex + 1); // Increment Memory Index
						
						// Read Data on RData Line
						if(WriteEnBuffer == `RE)
						begin
							RDataBuffer <= #(DELAY) RData;
							
							if(RDataBufferRead == `HIGH)
							begin
								ReadDataMemory[ReadDataMemIndex] <= RDataBuffer;
							end
							else
							begin
								ReadDataMemory[ReadDataMemIndex] <= RData;
							end
							
							ReadDataMemIndex <= #(DELAY) ReadDataMemIndex + 1;
						end
						
						// Lower RDataBufferRead Signal as the Buffered RData has been read
						if(RDataBufferRead == `HIGH)
						begin
							RDataBufferRead <= #(DELAY) `LOW;
						end
							

					end
										
					WData <= #(DELAY) DataBuffer;
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
	end

endmodule
