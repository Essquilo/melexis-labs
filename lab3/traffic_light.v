`timescale 1ns/1ps
module traffic_light(clk, i_rst, o_yellow, o_green, o_red);
parameter YELLOW = 5;
parameter GREEN = 7;
parameter RED = 3;
input clk, i_rst;
wire i_yellow_cnt, i_green_cnt, i_red_cnt;
output reg o_yellow, o_green, o_red;

delay #(.MODULE(YELLOW)) yellow_delay(
	.clk(clk),
	.i_rst(i_rst),
	.i_enbl(o_yellow),
	.o_cnt(i_yellow_cnt)
	);

delay #(.MODULE(GREEN)) green_delay(
	.clk(clk),
	.i_rst(i_rst),
	.i_enbl(o_green),
	.o_cnt(i_green_cnt)
	);

delay #(.MODULE(RED)) red_delay(
	.clk(clk),
	.i_rst(i_rst),
	.i_enbl(o_red),
	.o_cnt(i_red_cnt)
	);
parameter st_red = 0, st_yellow1 = 1, st_green = 2, st_yellow2 = 3;
reg [1:0] state;

always @(state) begin
	o_yellow = 0;
	o_green =0;
	o_red = 0;
	case(state)
	st_red: o_red = 1;
	st_yellow1, st_yellow2: o_yellow = 1;
	st_green: o_green = 1;
	endcase
end

always @(posedge clk or negedge i_rst) begin
	if (!i_rst) begin
		state <= st_red;
	end
	else begin
		case(state)
		st_red: 
			if(i_red_cnt)
				state <= st_yellow1;
		st_yellow1: 
			if(i_yellow_cnt)
				state <= st_green;
		st_green: 
			if(i_green_cnt)
				state <= st_yellow2;
		st_yellow2: 
			if(i_yellow_cnt)
				state <= st_red;
		endcase
	end
end
endmodule

module tb_traffic_light;
integer i;
reg clk, rst;
wire yellow, green, red;

traffic_light inst (
	.clk(clk),
	.i_rst(rst),
	.o_yellow(yellow),
	.o_green(green),
	.o_red(red)
	);

initial begin
	clk = 0;
	rst = 0;
	#10 rst = 1;
	for(i = 0;i<100; i = i+1) begin
		#10 clk = 1;
		#10 clk = 0;
	end
	$finish();
end
endmodule