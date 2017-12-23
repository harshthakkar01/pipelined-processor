`timescale 1ns / 1ps

	module instruction_memory(
    clk, address, data);
	input clk;
	input [31:0] address;
	output [31:0] data;
	
	parameter imd = "im.txt";
	parameter number = 128;
	reg [31:0] mem [0:number-1];
	
	initial begin
		$readmemb(imd,mem,0,number-1);
	end
	
	assign data = mem[address[8:2]][31:0];

endmodule
