`timescale 1ns / 1ps
module control(
    clk, opcode, regDst, branch_eq, 
	 branch_ne, aluOp, memRead, memWrite, 
	 memToReg, regWrite, aluSrc, jump);
	 
	 input clk;
	 input [5:0] opcode;
	 output reg regDst, branch_eq, branch_ne, memRead, memWrite, memToReg, regWrite, aluSrc, jump;
	 output reg [1:0] aluOp;
	 
	 always@(*)
	 begin
		// Initial value:
		aluOp[1:0]	<= 2'b10;
		aluSrc		<= 1'b0;
		branch_eq	<= 1'b0;
		branch_ne	<= 1'b0;
		memRead		<= 1'b0;
		memToReg	<= 1'b0;
		memWrite	<= 1'b0;
		regDst		<= 1'b1;
		regWrite	<= 1'b1;
		jump		<= 1'b0;
		case (opcode)
			6'b100011: 
			begin	/* lw */
				memRead  <= 1'b1;
				regDst   <= 1'b0;
				memToReg <= 1'b1;
				aluOp[1] <= 1'b0;
				aluSrc   <= 1'b1;
			end
			
			6'b001001: 
			begin	/* addi */
				regDst   <= 1'b0;
				aluOp[1] <= 1'b0;
				aluSrc   <= 1'b1;
			end
			
			6'b000100: 
			begin	/* beq */
				aluOp[0]  <= 1'b1;
				aluOp[1]  <= 1'b0;
				branch_eq <= 1'b1;
				regWrite  <= 1'b0;
			end
			
			6'b101011: 
			begin	/* sw */
				memWrite <= 1'b1;
				aluOp[1] <= 1'b0;
				aluSrc   <= 1'b1;
				regWrite <= 1'b0;
			end
			
			6'b000101: 
			begin	/* bne */
				aluOp[0]  <= 1'b1;
				aluOp[1]  <= 1'b0;
				branch_ne <= 1'b1;
				regWrite  <= 1'b0;
			end
			
			6'b000000: 
			begin	/* add */
			end
			
			6'b000010: 
			begin	/* j jump */
				jump <= 1'b1;
			end
		endcase
	 end
endmodule
