`timescale 1ns/1ps

module one_digit_mux(i_addr, i_val, o_res);
parameter DATA_WIDTH = 4;
input i_addr;
input [2*DATA_WIDTH-1:0] i_val;
output [DATA_WIDTH-1:0] o_res;
wire not_addr;
not (not_addr, i_addr);
genvar i;
generate
for(i=0; i<DATA_WIDTH; i=i+1) begin: value
wire out_0;
wire out_1;
and(out_0, not_addr, i_val[i]);
and(out_1, i_addr, i_val[DATA_WIDTH+i]);
or (o_res[i], out_0, out_1);
end
endgenerate
endmodule

module mux(i_addr, i_val, o_res);
parameter DATA_WIDTH=4;
input wire [2:0] i_addr;
input wire [5*DATA_WIDTH-1:0] i_val;
output wire [DATA_WIDTH-1:0] o_res;
wire [DATA_WIDTH-1:0] res_0X, res_1X, res_0XX;

one_digit_mux #(.DATA_WIDTH(DATA_WIDTH)) mux_0X(
	.i_addr(i_addr[0]),
	.i_val(i_val[2*DATA_WIDTH-1:0]),
	.o_res(res_0X)
	);

one_digit_mux #(.DATA_WIDTH(DATA_WIDTH)) mux_1X(
	.i_addr(i_addr[0]),
	.i_val(i_val[4*DATA_WIDTH-1:2*DATA_WIDTH]),
	.o_res(res_1X)
	);

one_digit_mux #(.DATA_WIDTH(DATA_WIDTH)) mux_0XX(
	.i_addr(i_addr[1]),
	.i_val({res_1X, res_0X}),
	.o_res(res_0XX)
	);

one_digit_mux #(.DATA_WIDTH(DATA_WIDTH)) mux_1XX(
	.i_addr(i_addr[2]),
	.i_val({i_val[5*DATA_WIDTH-1:4*DATA_WIDTH], res_0XX}),
	.o_res(o_res)
	);
endmodule

module tb_mux();
parameter DATA_WIDTH = 4;
reg [2:0] addr;
reg [5*DATA_WIDTH-1:0] val;
wire [DATA_WIDTH-1:0] res;
reg [DATA_WIDTH-1:0] control_res;

integer i, error_count;
mux #(.DATA_WIDTH(DATA_WIDTH)) inst(
			  	.i_addr(addr),
			  	.i_val(val),
			  	.o_res(res)
);

initial begin
val = {4'd1, 4'd2, 4'd3, 4'd4, 4'd5};
addr = 0;
error_count = 0;
#10;
for(i=0; i<5;i=i+1) begin
		addr = i;
		if(control_res!=res) begin
			$display("Error with addr %b. Expected %b, got %b", addr, control_res, {control_res, res});
			error_count = error_count+1;
			end
		control_res = val[DATA_WIDTH*i+:DATA_WIDTH];
		#10;
end
$display("%d errors during simulation", error_count);
$finish();
end
endmodule