`timescale 1ns/1ps
module tb_traffic_light;
parameter CLOCK_PERIOD = 20;
parameter YELLOW = 5;
parameter GREEN = 7;
parameter RED = 1;
integer i;
integer count_y, count_g, count_r;
reg clk, rst_n;
wire yellow, green, red;

traffic_light #(.YELLOW(YELLOW), .GREEN(GREEN), .RED(RED)) inst (
	.clk(clk),
	.i_rst_n(rst_n),
	.o_yellow(yellow),
	.o_green(green),
	.o_red(red)
	);

always #(CLOCK_PERIOD/2) clk = ~clk;

initial begin
	clk = 0;
	count_y = 0;
	count_r = 0;
	count_g = 0;
	rst_n = 0;
	#(CLOCK_PERIOD/2) rst_n = 1;
	//there is additional delay for every state - it's needed to set up the counting module
	for(i = 0;i < 2*(YELLOW+1) + GREEN + 1 + RED + 1 + 1; i = i+1) begin
		case (1'b1)
			yellow:
				count_y = count_y+1;
			green:
				count_g = count_g+1;
			red:
				count_r = count_r+1;
			default:;
		endcase
		#(CLOCK_PERIOD);
	end
	if(count_y!=2*(YELLOW+1))
		$display("Error, expected %d yellow ticks, got %d", 2*(YELLOW+1), count_y);
	if(count_g!=GREEN+1)
		$display("Error, expected %d green ticks, got %d", GREEN+1, count_g);
	if(count_r!=RED+1)
		$display("Error, expected %d red ticks, got %d", RED+1, count_r);
	$stop();
end
endmodule