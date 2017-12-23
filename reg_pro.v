`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:59:27 04/02/2017 
// Design Name: 
// Module Name:    reg_pro 
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
module reg_pro(
    clk, read1, read2, data1, data2, regWrite_control, writeAddress, writeData);
	 input clk;
	 input [4:0] read1, read2;
	 output  [31:0] data1, data2;
	 input regWrite_control;
	 input [4:0] writeAddress;
	 input [31:0] writeData;
	 parameter data_m = "dm_binary.txt";
	 reg [31:0] d_mem [0:31];
		
	 initial begin
		$readmemb(data_m,d_mem,0,31);
	end	
// BY M
	assign data1 = d_mem[read1][31:0];
	assign data2 = d_mem[read2][31:0];
	 
//	 always@(posedge clk) begin
//		data1 <= d_mem[read1][31:0];
//		data2 <= d_mem[read2][31:0];
//	 end
	 always@(posedge clk)
	 begin
		if(regWrite_control==1'b1)
			d_mem[writeAddress] <= writeData;
	 end
endmodule
