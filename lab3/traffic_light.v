`timescale 1ns/1ps
module traffic_light(clk, i_rst_n, o_yellow, o_green, o_red);
parameter YELLOW = 5;
parameter GREEN = 7;
parameter RED = 1;
//max of three
localparam DELAY_WIDTH = $clog2((YELLOW>GREEN?(YELLOW>RED?YELLOW:RED):(GREEN>RED?GREEN:RED)));
input clk, i_rst_n;
wire enable_module_set,  count;
reg enable_count;
output reg o_yellow, o_green, o_red;
reg [DELAY_WIDTH-1: 0] delay_module;

delay #(.WIDTH(DELAY_WIDTH)) _delay(
	.clk(clk),
	.i_rst_n(i_rst_n),
	.i_count_enbl(enable_count),
	.i_module(delay_module),
	.i_set_module_enbl(enable_module_set),
	.o_cnt(count)
	);
	
parameter IDLE = 0, ST_RED = 1, ST_YELLOW1 = 2,  ST_GREEN = 3, ST_YELLOW2 = 4;
reg [2:0] state;
assign enable_module_set = count | (state==IDLE);
always @(state) begin
	o_yellow = 0;
	o_green = 0;
	o_red = 0;
	case(state)
	ST_RED: begin 
	o_red = 1;
	delay_module = YELLOW;
	end
	ST_YELLOW1: begin 
	o_yellow = 1;
	delay_module = GREEN;
	end
	ST_YELLOW2: begin
	o_yellow = 1;
	delay_module = RED;
	end
	ST_GREEN: begin
	o_green = 1;
	delay_module = YELLOW;
	end
	default:
		delay_module = RED;
	endcase
end

always @(posedge clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		state <= IDLE;
		enable_count<=1;
	end
	else begin
		case(state)
		IDLE: begin
			state<=ST_RED;
		end
		ST_RED: 
			if(count) begin
				state <= ST_YELLOW1;
			end
		ST_YELLOW1: 
			if(count) begin
				state <= ST_GREEN;
			end
		ST_GREEN: 
			if(count) begin
				state <= ST_YELLOW2;
			end
		ST_YELLOW2:
			if(count) begin
				state <= ST_RED;
			end
		endcase
	end
end
endmodule