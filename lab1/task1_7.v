`timescale 1ns / 1ps
module param_shift_reg(clk, rst_n, mode, data_in, data_out);
parameter width = 8;
input clk, rst_n;
input [1:0] mode;    /*00 - store, 01 -load, 10 - left shift, 11 - right shift*/
input [width-1:0] data_in;     /*parallel loading*/
output reg [width-1:0] data_out;
always @(posedge clk, negedge rst_n) begin
  if(!rst_n) begin
    data_out <= 0;  
  end else
	case (mode)
	    2'b01: data_out <= data_in;
	    2'b10: data_out <= {data_out[width-2:0], 1'b0};
	    2'b11: data_out <= {1'b0, data_out[width-1:1]};
	endcase
end
endmodule

`timescale 1ns / 1ps
module param_shift_reg_tb;
parameter period = 4;
parameter width = 8;
reg clk, rst_n;
reg [1:0] mode;
reg [width-1:0] data_in;
wire [width-1:0] data_out;
param_shift_reg #(.width(width)) reg_inst1(.clk(clk), 
                                           .rst_n(rst_n), 
					   .mode(mode),
                                           .data_in(data_in), 
                                           .data_out(data_out) );
initial begin
  clk = 0;
  repeat (20) begin
  #(period/2) clk = ~clk;
  end
end

initial begin
  rst_n = 0;
  data_in = 0;
  mode = 2'b00; 
  @(negedge clk) rst_n = 1;
  mode = 2'b01;
  data_in = 8'b01010001;
  @(negedge clk); 
  mode = 2'b10;
  repeat(3) @(negedge clk);
  mode = 2'b11;
  repeat(7) @(negedge clk);
  $finish();  
end  
endmodule

