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

module TopModuleTestBench;

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
	wire [31 : 0] RDataMemDataIndex;
	wire [31 : 0] RDataBuffer;
	wire [3 : 0] slave_en;
	
	assign RDataBuffer = uut.master1.RDataBuffer;
	assign RDataMemDataIndex = uut.master1.ReadDataMemIndex;
	assign slave_en = uut.slave_en;
	
	assign Address = uut.mux_address_out;
	assign WData = uut.mux_data_out;
	assign Control = uut.mux_control_out;
	assign RData = uut.slave_rdata_ready[31 : 0];
	assign ack = uut.arbiter_ack;
	assign req = uut.arbiter_req;
	assign ready = uut.slave_rdata_ready[32];

	

	// Instantiate the Unit Under Test (UUT)
	TopModule uut (
		.clk(clk), 	
		.reset(reset), 
		.trigger(trigger), 
		.prog(prog), 
		.progaddress(progaddress), 
		.progdata(progdata), 
		.progcontrol(progcontrol)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		
		trigger = 0; reset = 0;
		
		#10 prog = 1;
		
		// Write; burst 2; Byte; Slave 0
		#2  progaddress = 32'h00000000; 
			 progcontrol = 7'b0000001; 
			 progdata = 32'h00000045;
			 
		
		#10 progaddress = 32'h00000001; 
			 progcontrol = 7'b0000001; 
			 progdata = 32'h00000099;
		
		// Read; burst 2; HW; Slave 1
		#10 progaddress = 32'h40000002; 
			 progcontrol = 7'b0001010;
			 
		#10 progaddress = 32'h40000002; 
			 progcontrol = 7'b0001010;

		// Write; burst 4; HW; Slave 0
		#10 progaddress = 32'h00000006; 
			 progcontrol = 7'b0010010;
			 progdata = 32'h00002233;

		
		#10 progaddress = 32'h00000006; 
			 progcontrol = 7'b0010010;
			 progdata = 32'h00004455;


		#10 progaddress = 32'h00000006; 
			 progcontrol = 7'b0010010;
			 progdata = 32'h00006677;


		#10 progaddress = 32'h00000006; 
			 progcontrol = 7'b0010010;			 
			 progdata = 32'h009988;

		// Read; burst 16; W; Slave 2
		#10 progaddress = 32'h80000008;  
			 progcontrol = 7'b0100100;
			 		
		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;
	
		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;
		
		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;

 		#10 progaddress = 32'h8;  
			 progcontrol = 7'b0100100;
		
		// Write; burst 1; W
		#10 progaddress = 32'hC; 
			 progcontrol = 7'b0000101; 
			 progdata = 32'h87654321;
		
		// Write; burst 1; W
		#10 progaddress = 32'h10; 
			 progcontrol = 7'b0000101; 
			 progdata = 32'h66778899;
		
		// Read; burst 4; W; Different Slave 3
		#10 progaddress = 32'hC0000010; 
			 progcontrol = 7'b0010100; 
			 
		#10 progaddress = 32'hC0000010; 
			 progcontrol = 7'b0010100; 
			 
		 #10 progaddress = 32'hC0000010; 
			 progcontrol = 7'b0010100; 
		 
		#10 progaddress = 32'hC0000010; 
			 progcontrol = 7'b0010100; 
		
		// Write; burst 1; DW; Slave 0
		#10 progaddress = 32'h00000014; 
			 progcontrol = 7'b0000111; 
			 progdata = 32'h11111111;
		
		#10 progaddress = 32'h00000014; 
			 progcontrol = 7'b0000111; 
			 progdata = 32'h22222222;
			 
		// Read; burst 1; DW; Slave 1
		#10 progaddress = 32'h4000001C; 
			 progcontrol = 7'b0000110;
			 
		#10 progaddress = 32'h4000001C; 
			 progcontrol = 7'b0000110;
			 
		// Write; Burst 8; W; Slave 2
		#10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'h11223344;
			 
		#10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'h12341234;
			 
		#10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'hA4573126;
			 
		#10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'hDDDDDDDD;
			 
		#10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'hDEADBEEF;
			 
		#10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'hABCDABCD;
			 
	   #10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'h572A67BB;
			 
		#10 progaddress = 32'h80000014; 
			 progcontrol = 7'b0011101; 
			 progdata = 32'h0000FFFF;
		
		// Read; burst 2; DW; Slave 0
		#10 progaddress = 32'h00000001C; 
			 progcontrol = 7'b0001110;
			 
		#10 progaddress = 32'h0000001C; 
			 progcontrol = 7'b0001110;
			 
		#10 progaddress = 32'h0000001C; 
			 progcontrol = 7'b0001110;
			 
	   #10 progaddress = 32'h0000001C; 
			 progcontrol = 7'b0001110;
		
		// Read; burst 1; B; Slave 0
		#10 progaddress = 32'h00000110;
			 progcontrol = 7'b0000000;

		// End of Transactions
		#10 progaddress = 32'hFFFFFFFF; 
			 progcontrol = 7'b1111111; 
			 progdata = 32'hFFFFFFFF;
			 
			 $finish;
			
		#10 prog = 0; reset = 1; trigger = 0;
		#10 reset = 0; trigger = 1;
		#30 trigger = 0;
        
		// Add stimulus here

	end
	
	always
	begin
		#5 clk <= ~clk;
	end
      
endmodule

