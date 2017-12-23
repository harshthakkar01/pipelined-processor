`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Harsh Thakkar
// 201401225
// 5 stage pipeline processor
// Digital System Architecture
// Prof. Amit Bhatt
//////////////////////////////////////////////////////////////////////////////////

module main_processor(
    clk);
	
	input clk;
	wire [31:0] pc4;
	wire [31:0] inst;	
	wire [31:0] inst_2;
	wire [31:0] pc4_2;
	wire [31:0] aluResult_4;
	wire zero_4;
	wire [31:0] data1_4, data2_4;
	wire [31:0] branch_address_4;
	wire branch_eq_4, branch_ne_4;
	wire [31:0] jump_address_4;
	wire jump_4;
	wire [4:0]	wrRegister;
	wire [4:0]	wrRegister_4;
	wire regWrite_5, memToReg_5;	
	wire [31:0] read_data_4;
	wire [31:0] read_data_5;
	wire [31:0] aluResult_5;
	wire [4:0] wrRegister_5;
	reg pcsrc;
	wire [31:0] wrData_5;
	reg [1:0] frwdControl_1;
	reg [1:0] frwdControl_2;
	reg stall_1_2;
	reg flush_1,flush_2,flush_3,flush_4;
	
	

//******** STAGE 1 --> FETCH STAGE ********//	
// Initial value of PC 	
	reg [31:0] pc;
	
	initial begin
		pc = 32'd0;
	end
	
	assign pc4 = pc+4;
	
//	 Update the value of PC at each clock edge and assign the value 
//	 According to logic generated from different stages

// IF Stall is generated --> Reason : RAW hazards with Memory Access : PC should not change the value 
// IF pc_src is 1 ---> Reason : Branch address is generated and Branch has to be taken
// IF jump instruction ---> Reason : jump to the specified address which is calculated in stage 4
 
	always@(posedge clk)
	begin
		if(stall_1_2)
			pc <= pc;
		else if(pcsrc)
			pc <= branch_address_4;
		else if(jump_4)
			pc <= jump_address_4;
		else 
			pc <= pc4;
	end

// fetching instruction for the every PC value at every clock
	fetch #(.IMD("im_binary.txt")) f1(.clk(clk), .pc(pc), .inst(inst));
	
// Moving Instruction to Second Stage

	register #(.size(32)) reg_inst_2(.clk(clk), .clear(flush_1), .hold(stall_1_2), .in(inst), .out(inst_2));
	
// Transfer pc4 to stage 2

	register #(.size(32)) reg_pc4_2(.clk(clk), .clear(flush_1), .hold(stall_1_2), .in(pc4), .out(pc4_2));
	
//******** STAGE 2 --> DECODE STAGE ********//	
	
	wire [5:0] opcode;
	wire [4:0] rs, rt, temp_rd;
	wire [31:0] data1_2, data2_2;
	wire [15:0] imm_value;
	wire [4:0] shift;
	wire [31:0] jump_address_2;
	wire [31:0] sign_extended_2;
	
	wire		regDst;
	wire		branch_eq_2;
	wire		branch_ne_2;
	wire		memRead;
	wire		memWrite;
	wire		memToReg;
	wire [1:0]	aluOp;
	wire		regWrite;
	wire		aluSrc;
	wire		jump_2;
	
	decode d1(.data1(data1_2), .data2(data2_2), .pc(pc), 
			.inst(inst_2), .wrData_5(wrData_5), .regWrite_5(regWrite_5), 
			.wrRegister_5(wrRegister_5), .jump_2(jump_2), .aluSrc(aluSrc),
			.regWrite(regWrite),.memRead(memRead), .memWrite(memWrite), 
			.memToReg(memToReg), .aluOp(aluOp), .regDst(regDst), 
			.branch_eq_2(branch_eq_2), .branch_ne_2(branch_ne_2), .clk(clk),
			.shift(shift), .jump_address_2(jump_address_2), 
			.sign_extended_2(sign_extended_2), .opcode(opcode), .rs(rs), 
			.rt(rt), .temp_rd(temp_rd), .imm_value(imm_value));

// Calculate branch_address
	wire [31:0] shift_extended_2;
	assign shift_extended_2 = {sign_extended_2[29:0],2'b00};
	wire [31:0] branch_address_2;
	assign branch_address_2 = pc4_2 + shift_extended_2;
	
// ---> Transfer all values to next stage

// Transfer rs, rt, rd for calculating forwarding condition
	wire [4:0] rs_3, rt_3, rd_3;
	register #(.size(5)) reg_rs_3(.clk(clk), .clear(1'b0), .hold(stall_1_2), .in(rs), .out(rs_3));
	register #(.size(5)) reg_rt_3(.clk(clk), .clear(flush_2), .hold(stall_1_2), .in(rt), .out(rt_3));
	register #(.size(5)) reg_rd_3(.clk(clk), .clear(flush_2), .hold(stall_1_2), .in(temp_rd), .out(rd_3));
	
// Transfer data1, data2
	wire [31:0] data1_3, data2_3;
	register #(.size(32)) reg_data1_3(.clk(clk), .clear(flush_2), .hold(stall_1_2), .in(data1_2), .out(data1_3));
	register #(.size(32)) reg_data2_3(.clk(clk), .clear(flush_2), .hold(stall_1_2), .in(data2_2), .out(data2_3));
	
// Transfer branch address, jump address, sign extended
	wire [31:0] branch_address_3, jump_address_3, sign_extended_3;
	register #(.size(32)) reg_branch_address_3(.clk(clk), .clear(flush_2), .hold(stall_1_2), .in(branch_address_2), .out(branch_address_3));
	register #(.size(32)) reg_jump_address_3(.clk(clk), .clear(flush_2), .hold(stall_1_2), .in(jump_address_2), .out(jump_address_3));
	register #(.size(32)) reg_sign_extended_3(.clk(clk), .clear(flush_2), .hold(stall_1_2), .in(sign_extended_2), .out(sign_extended_3));
	
// Transfer pc4 address
	wire [31:0] pc4_3;
	register #(.size(32)) reg_pc4_3(.clk(clk), .clear(1'b0), .hold(stall_1_2), .in(pc4_2), .out(pc4_3));

// passing all control signls
	wire		regDst_3;
	wire		memRead_3;
	wire		memWrite_3;
	wire		memToReg_3;
	wire [1:0]	aluOp_3;
	wire		regWrite_3;
	wire		aluSrc_3;
	
	register #(.size(8)) reg_control_3(.clk(clk), 
		.clear(stall_1_2), .hold(1'b0), 
		.in({regDst,memRead,memWrite,memToReg,aluOp,regWrite,aluSrc}), 
		.out({regDst_3, memRead_3, memWrite_3, memToReg_3, aluOp_3, regWrite_3, aluSrc_3}));
	
	
// Transfer branch and branch address
	wire branch_eq_3, branch_ne_3,jump_3;
	register #(.size(3)) reg_branch_3(.clk(clk), .clear(flush_2), .hold(1'b0), 
		.in({branch_eq_2,branch_ne_2,jump_2}), .out({branch_eq_3,branch_ne_3,jump_3}));
	


//******** STAGE 3 --> EXECUTE STAGE ********//	
	
	wire zero_3;
	wire [31:0] aluResult_3;
	register #(.size(32)) reg_aluResult_4(.clk(clk), .clear(flush_3), 
						.hold(1'b0), .in(aluResult_3), .out(aluResult_4));
	register #(.size(1)) reg_zero_4(.clk(clk), .clear(1'b0),
						.hold(1'b0), .in(zero_3), .out(zero_4));

	
	execute e1(.aluOp(aluOp_3), .aluSrc_3(aluSrc_3),
				.wrData_5(wrData_5), .aluResult_4(aluResult_4),
				.data1(data1_3), .data2(data2_3), .frwdControl_1(frwdControl_1),
				.frwdControl_2(frwdControl_2), .clk(clk), .zero(zero_3), 
				.aluResult(aluResult_3), .sign_extended(sign_extended_3));
	

// Passing result to next stage
		
	
// Transfer control values to next stage 
	
	wire regWrite_s4;
	wire memToReg_s4;
	wire memRead_s4;
	wire memWrite_s4;
	
	register #(.size(4)) reg_control_4(.clk(clk), .clear(flush_3), 
					.hold(1'b0), .in({regWrite_3, memToReg_3, memRead_3,memWrite_3}),
					.out({regWrite_4, memToReg_4, memRead_4,memWrite_4}));
	
// Transfer data1 and data2 to stage 4
	register #(.size(32)) reg_data1_4(.clk(clk), 
			.clear(flush_3), .hold(1'b0), .in(data1_3), .out(data1_4));
	register #(.size(32)) reg_data2_4(.clk(clk), 
			.clear(flush_3), .hold(1'b0), .in(data2_3), .out(data2_4));

// Transfer branch and branch address

	register #(.size(32)) reg_branch_address_4(.clk(clk), .clear(flush_3),
			.hold(1'b0), .in(branch_address_3), .out(branch_address_4));
	register #(.size(2)) reg_branch_e_n_4(.clk(clk), .clear(flush_3), 
			.hold(1'b0), .in({branch_eq_3, branch_ne_3}), .out({branch_eq_4, branch_ne_4}));
	
// Jump Transfer
	
	register #(.size(32)) reg_jump_address_4(.clk(clk), .clear(flush_3), 
			.hold(1'b0), .in(jump_address_3), .out(jump_address_4));
	register #(.size(1)) reg_jump_4(.clk(clk), .clear(flush_3), 
			.hold(1'b0), .in(jump_3), .out(jump_4));
	
	// write register
	assign wrRegister = (regDst_3) ? rd_3 : rt_3;
	
	// pass to stage 4
	register #(.size(5)) reg_wrReg(.clk(clk), .clear(flush_3), .hold(1'b0),
				.in(wrRegister), .out(wrRegister_4));

	
//******** STAGE 4 --> MEMORY ACCESS STAGE ********//	
	
// Transfer data to next stage
	
	
	register #(.size(2)) reg_control_5(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in({regWrite_4, memToReg_4}),
				.out({regWrite_5, memToReg_5}));
	
	// Data Memory Access
	data_memory dm(.clk(clk), .address(aluResult_4[8:2]), 
		.read_e(memRead_4), .write_e(memWrite_4), .read_data(read_data_4), .write_data(data2_4));
	
	// Pass read data to 5;
	register #(.size(32)) reg_readData_5(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in(read_data_4),
				.out(read_data_5));
	
	// Pass ALU result to 5
	register #(.size(32)) reg_aluResult_5(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in(aluResult_4),
				.out(aluResult_5));
	
	register #(.size(5)) reg_wrReg_5(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in(wrRegister_4),
				.out(wrRegister_5));

	// branch
	always @(*) begin
		case (1'b1)
			branch_eq_4: pcsrc <= zero_4;
			branch_ne_4: pcsrc <= ~(zero_4);
			default: pcsrc <= 1'b0;
		endcase
	end

//******** STAGE 5 --> WRITE BACK STAGE ********//	

	assign wrData_5 = memToReg_5 ? read_data_5 : aluResult_5;
	
	//	Flush signals to be initialized and stages should be flushed if branch or jump is executed	
	
	always@(*)
	begin
		flush_1 = 1'b0;
		flush_2 = 1'b0;
		flush_3 = 1'b0;
		if((pcsrc==1'b1)||(jump_4))
		begin
			flush_1 = 1'b1;
			flush_2 = 1'b1;
			flush_3 = 1'b1;	
		end
	end

// Forwarding

	always@(*)
	begin
		if ((regWrite_4 == 1'b1) && (wrRegister_4 == rs_3)) 
		begin
			frwdControl_1 <= 2'd1;  // stage 4
		end 
		else if ((regWrite_5 == 1'b1) && (wrRegister_5 == rs_3)) 
		begin
			frwdControl_1 <= 2'd2;  // stage 5
		end 
		else
			frwdControl_1 <= 2'd0;  // no forwarding

		// data2 input to ALU
		if ((regWrite_4 == 1'b1) & (wrRegister_4 == rt_3)) 
		begin
			frwdControl_2 <= 2'd1;  // stage 5
		end 
		else if ((regWrite_5 == 1'b1) && (wrRegister_5 == rt_3))
		begin
			frwdControl_2 <= 2'd2;  // stage 5
		end
		else
			frwdControl_2 <= 2'd0;  // no forwarding
	end

// To perform stall

	always@(*) begin
		if (memRead_3 == 1'b1 && ((rt == rt_3) || (rs == rt_3)) ) begin
			stall_1_2 <= 1'b1;  // perform a stall
		end else
			stall_1_2 <= 1'b0;  // no stall
	end

endmodule

