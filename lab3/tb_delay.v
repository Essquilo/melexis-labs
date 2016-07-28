`timescale 1ns/1ps
module tb_delay;
parameter CLOCK_PERIOD = 20;
parameter WIDTH = 4;
integer i;
reg clk, rst, enbl, set_module_enbl;
reg [WIDTH-1:0] count_module;
wire o_cnt;
delay #(.WIDTH(WIDTH)) inst (
	.clk(clk),
	.i_rst_n(rst),
	.i_count_enbl(enbl),
	.i_module(count_module),
	.i_set_module_enbl(set_module_enbl),
	.o_cnt(o_cnt)
	);

always #(CLOCK_PERIOD/2) clk = ~clk;

initial begin
	clk = 0;
	enbl = 0;
	rst = 0;
	#(CLOCK_PERIOD/2);
	rst = 1;
	for (count_module = 1; count_module>0 && count_module<=15; count_module = count_module+1) begin
		set_module_enbl = 1;
		#CLOCK_PERIOD;
		set_module_enbl = 0;
		enbl = 1;	
		for(i = 0;i<2*count_module; i = i+1) begin
			if(i%count_module==0&&!o_cnt==1&&!i==0)
				$display("Error: counter = %d, module = %d, flag not set.", i, count_module);
		#CLOCK_PERIOD;
		end
	end
	$finish();
end
endmodule