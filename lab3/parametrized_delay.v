`timescale 1ns/1ps
module delay(clk, i_rst, i_enbl, o_cnt);
parameter MODULE = 4;
localparam WIDTH = $clog2(MODULE);
input clk, i_rst, i_enbl;
output reg o_cnt;
reg [WIDTH-1:0] counter;

always @(posedge clk or negedge i_rst) begin
	if (!i_rst) begin
		counter <=0;
		o_cnt <=0;		
	end
	else if (i_enbl) begin
		if(counter==MODULE-1) begin
			counter<=0;
		end 
		else begin
			counter<=counter+1;
		end
	end
	if(counter==MODULE-1) begin
			o_cnt<=1;
		end 
		else begin
			o_cnt<=0;
		end
end
endmodule

module tb_delay;
parameter MODULE = 8;
integer i;
reg clk, rst, enbl;
wire o_cnt;
delay #(.MODULE(MODULE)) inst (
	.clk(clk),
	.i_rst(rst),
	.i_enbl(enbl),
	.o_cnt(o_cnt)
	);

initial begin
	clk = 0;
	enbl = 0;
	rst = 0;
	#10 rst = 1;
	enbl = 1;
	for(i = 0;i<2*MODULE; i = i+1) begin
		if(i%MODULE==0&&!o_cnt==1&&!i==0)
			$display("Error: counter = %d, flag not set.", i);
		#10 clk = 1;
		#10 clk = 0;
	end
	$finish();
end
endmodule