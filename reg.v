`timescale 1ns / 1ps

module register(
    clk, clear, hold, in, out);
	parameter size = 32;
	input [size-1:0] in;
	input clk, clear,hold;
	output reg [size-1:0] out;
	
	always@(posedge clk)
	begin
		if(clear)
			out = {size{1'b0}};
		else if(hold)
			out = out;
		else 
			out = in;
	end
	
endmodule
