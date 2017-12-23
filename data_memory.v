`timescale 1ns / 1ps
module data_memory(clk, read_data, write_data, address, read_e, write_e
    );
	input clk, read_e, write_e;
	input [6:0] address;
	input [31:0] write_data;
	output [31:0] read_data;
	
	reg [31:0] mem [0:127];
	
	always@(posedge clk) begin
		if(write_e) begin
			mem[address] = write_data;
		end
	end
	
	// Avoid one cycle delay from write Operation
	
	assign read_data = write_e ? write_data : mem[address][31:0];

endmodule
