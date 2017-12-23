`timescale 1ns / 1ps

module alu(
    function_code, in1, in2, result, zero, aluOp);
	input [31:0] in1, in2;
	input [1:0] aluOp;
	input [5:0] function_code;
	output reg [31:0] result;
	output zero;
	
	assign zero = (result==0);	
	wire [3:0] aluControl;
	
	alu_control alu_c_1(.function_code(function_code), .aluOp(aluOp), .aluControl(aluControl));
	
	wire [31:0] add, sub;
	wire x,y;
	assign add = in1+in2;
	assign sub = in1-in2;
	assign x = ((in1[31] == in2[31] && add[31]) != in1[31]) ? 1 : 0;
	assign y = ((in1[31] == in2[31] && sub[31]) != in1[31]) ? 1 : 0;

	assign oflow = (aluControl == 4'b0010) ? x : y;

	// set if less than, 2s compliment 32-bit numbers
	assign slt = y ? ~(in1[31]) : in1[31];


	always @(*) begin
		case (aluControl)
			4'd2:  result = in1+in2;				/* add */
			4'd0:  result = in1 & in2;				/* and */
			4'd12: result = ~(in1 | in2);			/* nor */
			4'd1:  result = in1 | in2;				/* or */
			4'd7:  result = {{31{1'b0}}, slt};	/* slt */
			4'd6:  result = in1 - in2;				/* sub */
			4'd13: result = in1 ^ in2;				/* xor */
			default: result = 0;
		endcase
	end
	
endmodule
