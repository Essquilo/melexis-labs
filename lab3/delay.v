`timescale 1ns/1ps
module delay(clk, i_rst_n, i_count_enbl, i_module, i_set_module_enbl, o_cnt);
parameter WIDTH = 2;
input clk, i_rst_n, i_count_enbl, i_set_module_enbl;
input [WIDTH-1:0] i_module;
output reg o_cnt;
reg [WIDTH-1:0] counter;
reg [WIDTH-1:0] counting_module;

always @(posedge clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		counter <=0;
		o_cnt <=0;
		counting_module <=0;
	end
	else begin
		if (i_set_module_enbl) begin
			counting_module<=i_module;
			counter<=0;
			o_cnt<=0;
		end
		else begin
		if (i_count_enbl) begin
			if(counter==counting_module-1) begin
				counter<=0;
			end 
			else begin
				counter<=counter+1;
			end
		end
		if(counter==counting_module-1) begin
				o_cnt<=1;
			end 
			else begin
				o_cnt<=0;
			end
		end
	end
end
endmodule