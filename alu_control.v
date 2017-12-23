`timescale 1ns / 1ps

module alu_control(
    function_code, aluOp, aluControl);
	input [5:0] function_code;
	input [1:0] aluOp;
	output reg [3:0] aluControl;
	
	reg [3:0] _funct;

	always @(*) begin
		case(function_code[3:0])
			4'd0:  _funct = 4'd2;	/* add */
			4'd2:  _funct = 4'd6;	/* sub */
			4'd5:  _funct = 4'd1;	/* or */
			4'd6:  _funct = 4'd13;	/* xor */
			4'd7:  _funct = 4'd12;	/* nor */
			4'd10: _funct = 4'd7;	/* slt */
			default: _funct = 4'd0;
		endcase
	end

	always @(*) begin
		case(aluOp)
			2'd0: aluControl = 4'd2;	/* add */
			2'd1: aluControl = 4'd6;	/* sub */
			2'd2: aluControl = _funct;
			2'd3: aluControl = 4'd2;	/* add */
			default: aluControl = 0;
		endcase
	end
endmodule
