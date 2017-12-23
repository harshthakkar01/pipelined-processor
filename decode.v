`timescale 1ns / 1ps

module decode(
    data1, data2, memToReg, aluOp, regWrite,
	 aluSrc, jump_2, regDst, branch_eq_2, branch_ne_2, 
	 memRead, memWrite, clk, inst, pc, regWrite_5, 
	 wrRegister_5, wrData_5, opcode, rs, rt, temp_rd,
	 imm_value, shift, jump_address_2, sign_extended_2);
	input clk;
	input [31:0] inst;
	input [31:0] pc;
	input [31:0] wrData_5;
	input regWrite_5;
	input [4:0] wrRegister_5;
	
	output		regDst;
	output		branch_eq_2;
	output		branch_ne_2;
	output		memRead;
	output		memWrite;
	output		memToReg;
	output [1:0]	aluOp;
	output		regWrite;
	output		aluSrc;
	output		jump_2;
	
	output [5:0] opcode;
	output [4:0] rs, rt, temp_rd;
	output [15:0] imm_value;
	output [4:0] shift;
	output [31:0] jump_address_2;
	output [31:0] sign_extended_2;
	
// Breaking the instruction into different parts
	
	assign opcode = inst[31:26];
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign temp_rd = inst[15:11];
	assign imm_value = inst[15:0];
	assign shift = inst[10:6];
	assign jump_address_2 = {pc[31:28], inst[25:0], 2'b00};
	assign sign_extended_2 = {{16{inst[15]}}, inst[15:0]};
	
	output [31:0] data1, data2;
	
	reg_pro r1(.clk(clk), .read1(rs), 
	.read2(rt), .data1(data1), .data2(data2), 
	.regWrite_control(regWrite_5), .writeAddress(wrRegister_5), 
	.writeData(wrData_5));
	
	
// Decoding the instruction
	
	
	control c1(.clk(clk), .opcode(opcode), .regDst(regDst), .branch_eq(branch_eq_2),
	.branch_ne(branch_ne_2), .memRead(memRead), .memWrite(memWrite), 
	.memToReg(memToReg), .aluOp(aluOp), .regWrite(regWrite), .aluSrc(aluSrc), 
	.jump(jump_2));
	
endmodule
