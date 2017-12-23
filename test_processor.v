`timescale 1ns / 1ps

module test_processor;

	// Inputs
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	main_processor uut (
		.clk(clk)
	);
initial 
begin
		clk=1'b0;
end

always begin
#10;	clk = ~clk;
end
endmodule

