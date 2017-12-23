`timescale 1ns / 1ps

module execute(
   aluOp, aluSrc_3, 
	wrData_5, aluResult_4, data1, data2, 
	clk, aluResult, zero, sign_extended,
	frwdControl_1, frwdControl_2);
	
	input [1:0] aluOp;
	input clk, aluSrc_3;
	input [1:0] frwdControl_1, frwdControl_2;
	input [31:0] sign_extended, data1, data2, wrData_5, aluResult_4;
	output [31:0] aluResult;
	wire [31:0] in2; 
	wire [31:0] in1;
	output zero;
	wire [5:0] function_code;
//	input [1:0] aluOp_3;
	assign function_code = sign_extended[5:0];
	
	wire [31:0] _in1, _in2;

//	always@(*)
//	begin
//	if(frwdControl_1==2'b01)
//		_in1 = aluResult_4;
//	else if(frwdControl_1==2'b10)
//		_in1 = wrData_5;
//	else
//		_in1 = data1;
//	end
	
//	always@(*)
//	begin
//	if(frwdControl_2==2'b01)
//		_in2 = aluResult_4;
//	else if(frwdControl_2==2'b10)
//		_in2 = wrData_5;
//	else
//		_in2 = data2;
//	end

	assign _in1 = (frwdControl_1==2'b01)?(aluResult_4):(frwdControl_1==2'b10)?wrData_5:data1;
	assign _in2 = (frwdControl_2==2'b01)?(aluResult_4):(frwdControl_2==2'b10)?wrData_5:data2;
	assign in1 = _in1;
	assign in2 = (aluSrc_3==1'b0)?_in2:sign_extended;
	
	alu a1(.aluOp(aluOp),.function_code(function_code),
			.in1(in1), .in2(in2), .result(aluResult), .zero(zero));
	
endmodule
