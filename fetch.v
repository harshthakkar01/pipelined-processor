`timescale 1ns / 1ps

module fetch(
    clk, pc, inst);
	input clk;
	input [31:0] pc;
	output [31:0] inst;
	parameter IMD = "instruction_memory.txt";
	instruction_memory #(.imd(IMD), .number(1)) im1(.clk(clk), .address(pc), .data(inst));
	
endmodule
