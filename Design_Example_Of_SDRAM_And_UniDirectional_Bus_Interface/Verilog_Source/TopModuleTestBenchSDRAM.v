`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:38:43 10/19/2015
// Design Name:   TopModule
// Module Name:   /media/akshayvijaykumar/Softwares/Xilinx/CMPE240/Project2/TopModuleTestBench.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TopModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`define HIGH 1'b1
`define LOW 1'b0

`define SIZE_B 2'b00
`define SIZE_HW 2'b01
`define SIZE_W 2'b10
`define SIZE_DW 2'b11

`define BURST1 3'b000
`define BURST2 3'b001
`define BURST4 3'b010
`define BURST8 3'b011
`define BURST16 3'b100
`define BURST32 3'b101
`define BURST64 3'b110
`define BURSTPAGE	3'b111

`define READ 1'b0
`define WRITE 1'b1

`define S_START 2'b00
`define S_CONT 2'b01
`define S_IDLE 2'b10
`define S_BUSY 2'b11

`define PROGRAM_ADDRESS_SEQUENCE 32'h3FFFFFFF
 
module TopModuleTestBenchSDRAM;

	parameter CLOCK_CYCLE = 30;

	// Inputs
	reg clk;
	reg reset;
	reg trigger;
	reg prog;
	reg [31:0] progaddress;
	reg [31:0] progdata;
	reg [6:0] progcontrol;
	
	wire ready;	
	wire [31 : 0] RData;

	wire [31 : 0] Address;
	wire [31 : 0] WData;
	wire [8 : 0] Control;
	wire [1 : 0] ack;
	wire [1 : 0] req;
	wire Ready;
	
	assign Address = uut.mux_address_out;
	assign WData = uut.mux_data_out;
	assign Control = uut.mux_control_out;
	assign RData = uut.slave_rdata_ready[31 : 0];
	assign ack = uut.arbiter_ack;
	assign req = uut.arbiter_req;
	assign Ready = uut.SDRAMSlave.Ready;
	
	/* Wires for RegFile */
	wire [2:0] tburst;			// Burst length
	wire addr_mode;				// Addressing mode - sequential or linear
	wire [3:0] tlat;			// Read latency
	wire [7:0] tpre;			// Wait period after a precharge
	wire [7:0] twait;			// Precharge wait period after a transaction
	wire [7:0] tcas;			// Cas period
	wire prog_mode;				// A high indicates that the register file has entered programming mode
	
	assign tburst = uut.SDRAMSlave.BusInsterfaceUnitInstance.bus_interface_controller.regfile.tburst;
	assign addr_mode = uut.SDRAMSlave.BusInsterfaceUnitInstance.bus_interface_controller.regfile.addr_mode;
	assign tlat = uut.SDRAMSlave.BusInsterfaceUnitInstance.bus_interface_controller.regfile.tlat;
	assign tpre = uut.SDRAMSlave.BusInsterfaceUnitInstance.bus_interface_controller.regfile.tpre;
	assign twait = uut.SDRAMSlave.BusInsterfaceUnitInstance.bus_interface_controller.regfile.twait;
	assign tcas = uut.SDRAMSlave.BusInsterfaceUnitInstance.bus_interface_controller.regfile.tcas;
	assign prog_mode = uut.SDRAMSlave.BusInsterfaceUnitInstance.bus_interface_controller.regfile.prog_mode;

	// Instantiate the Unit Under Test (UUT)
	TopModule_v2 uut (
		.clk(clk), 	
		.reset(reset), 
		.trigger(trigger), 
		.prog(prog), 
		.progaddress(progaddress), 
		.progdata(progdata), 
		.progcontrol(progcontrol)
	);
	
	integer myfile;
	integer TRANSACTION_ID;
	integer CLOCK_PERIOD;

	initial begin
	
		TRANSACTION_ID = 0;
		CLOCK_PERIOD = 0;
		myfile = $fopen("./TestingResults/TestBench_TopModule.txt", "w");
		$fdisplay(myfile, "Transaction ID, Clock Period, reset, Address, Control, WData, RData, Busy\n");
		
		// Initialize Inputs
		clk = 0;
		
		trigger = `LOW; reset = `LOW;
		
		#(CLOCK_CYCLE) 
			prog = `HIGH;
		
		/** PROGRAMMING **/
		#(CLOCK_CYCLE / 2)  
		
			// Initialize Inputs
			/* Control Signals */
			// Control[8 : 7] - Status
			// Control[6 : 3] - Burst
			// Control[2 : 1] - Size
			// Control[0]     - WE
			
			// Program SDRAM
			progaddress = `PROGRAM_ADDRESS_SEQUENCE;
			progcontrol = {{1'b0},{`BURST1},{`SIZE_W},{`WRITE}};
			progdata = 32'h0504053A;
		
		/** WRITE; BURST 4; W; Bank 0 **/
		#(CLOCK_CYCLE)
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`WRITE}}; 
			progdata = 32'h11223344;
			
		#(CLOCK_CYCLE)
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`WRITE}}; 
			progdata = 32'h22222222;
		
		#(CLOCK_CYCLE)
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`WRITE}}; 
			progdata = 32'h33333333;
		
		#(CLOCK_CYCLE)
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`WRITE}}; 
			progdata = 32'h44444444;
			
		/** WRITE; BURST 4; HW; Bank 1 **/
		#(CLOCK_CYCLE) 

			progaddress = 32'h00014AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_HW},{`WRITE}};
			progdata = 32'hAABBAABB;
			 
		#(CLOCK_CYCLE) 
			progaddress = 32'h00014AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`WRITE}};
			progdata = 32'hCCDDCCDD;
		
		#(CLOCK_CYCLE) 
			progaddress = 32'h00014AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`WRITE}};
			progdata = 32'hABABABAB;

		#(CLOCK_CYCLE) 
			progaddress = 32'h00014AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`WRITE}};
			progdata = 32'hAABBFFDD;
			
		/** READ; BURST 4; B; Bank 0 **/
		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_B},{`READ}};
			 
		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_B},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_B},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_B},{`READ}};		
			
		/** READ; BURST 4; W; Bank 1 */
		#(CLOCK_CYCLE)		
			progaddress = 32'h00014AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`READ}};
			 
		#(CLOCK_CYCLE) 
			progaddress = 32'h00014AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00014AD0;  
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00014AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_W},{`READ}};	
			
		/** READ; BURST 4; HW; Bank 0 */
		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_HW},{`READ}};
			 
		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_HW},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_HW},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST4},{`SIZE_HW},{`READ}};	

		// Program SDRAM - Burst 8
		#(CLOCK_CYCLE) 
			progaddress = `PROGRAM_ADDRESS_SEQUENCE;
			progcontrol = {{1'b0},{`BURST1},{`SIZE_W},{`WRITE}};
			progdata = 32'h05040533;			
			
			// Program SDRAM - Burst 8
		#(CLOCK_CYCLE) 
			progaddress = `PROGRAM_ADDRESS_SEQUENCE;
			progcontrol = {{1'b0},{`BURST1},{`SIZE_W},{`WRITE}};
			progdata = 32'h05040533;			
			
			
		/** WRITE; BURST 8; HW; Bank 3 **/
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h11112222;
			
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h33334444;
		
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h55556666;
		
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h77778888;
			
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h11112222;
			
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h33334444;
		
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h55556666;
		
		#(CLOCK_CYCLE)
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h77778888;
		
		/** READ; BURST 8; B; Bank 3 */
		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};
			 
		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0;  
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};	
			
		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};
			 
		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0;  
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};

		#(CLOCK_CYCLE) 
			progaddress = 32'h00024AD0; 
			progcontrol = {{1'b0},{`BURST8},{`SIZE_B},{`READ}};

		// Program SDRAM - Burst 1
		#(CLOCK_CYCLE) 
			progaddress = `PROGRAM_ADDRESS_SEQUENCE;
			progcontrol = {{1'b0},{`BURST1},{`SIZE_W},{`WRITE}};
			progdata = 32'h05040538;	
			
		// Program SDRAM - Burst 1
		#(CLOCK_CYCLE) 
			progaddress = `PROGRAM_ADDRESS_SEQUENCE;
			progcontrol = {{1'b0},{`BURST1},{`SIZE_W},{`WRITE}};
			progdata = 32'h05040538;	
			
		/** WRITE; BURST 1; HW; Bank 0 **/
		#(CLOCK_CYCLE)
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST1},{`SIZE_HW},{`WRITE}}; 
			progdata = 32'h456ABC45;
			
		/** READ; BURST 1; W; Bank 0 */
		#(CLOCK_CYCLE) 
			progaddress = 32'h00004AD0; 
			progcontrol = {{1'b0},{`BURST1},{`SIZE_W},{`READ}};
			
		// Program SDRAM - Burst 2
		#(CLOCK_CYCLE) 
			progaddress = `PROGRAM_ADDRESS_SEQUENCE;
			progcontrol = {{1'b0},{`BURST2},{`SIZE_W},{`WRITE}};
			progdata = 32'h05040538;	
			
		// Program SDRAM - Burst 2
		#(CLOCK_CYCLE) 
			progaddress = `PROGRAM_ADDRESS_SEQUENCE;
			progcontrol = {{1'b0},{`BURST2},{`SIZE_W},{`WRITE}};
			progdata = 32'h05040538;	
			
		#(CLOCK_CYCLE) 
			progaddress = 32'hFFFFFFFF; 
			progcontrol = 7'b1111111; 
			progdata = 32'hFFFFFFFF;
			
		#(CLOCK_CYCLE - 5) prog = 0; reset = 1; trigger = 0;
		#(CLOCK_CYCLE) reset = 0; trigger = 1;
		#(CLOCK_CYCLE) trigger = 0;
		
		#(6900)
		$fclose(myfile);
		$finish;

	end
	
	always
	begin
		#(CLOCK_CYCLE / 2	) clk <= ~clk;
		
		if(clk == `HIGH)
		begin
			if(prog == `LOW)
			begin
				if(Control[8:7] == 2'b00)
				begin
					TRANSACTION_ID = TRANSACTION_ID + 1;
				end
			
				$fdisplay(myfile, "%3d, %3d, %1d, 0x%x, 9'b%b, 0x%x, 0x%x, %1d", TRANSACTION_ID, CLOCK_PERIOD, reset, Address, Control, WData, RData, Ready);
				
				CLOCK_PERIOD = CLOCK_PERIOD + 1;
			end
		end
	end
      
endmodule

