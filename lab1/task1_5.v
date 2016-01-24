`timescale 1ns / 1ps
module reg_8bit(clk, rst_n, we_n, data_in, data_out);
input clk, rst_n, we_n;
input [7:0] data_in;
output reg [7:0] data_out;
always @(posedge clk, negedge rst_n) begin
  if(!rst_n) begin
    data_out <= 0;  
  end else begin
       if(!we_n)
           data_out <= data_in;
    end
end
endmodule

`timescale 1ns / 1ps
module reg_8bit_tb;
parameter period = 4;
reg clk, rst_n, we_n;
reg [7:0] data_in;
wire [7:0] data_out;
integer i;
reg_8bit reg_inst1(.clk(clk), 
                   .rst_n(rst_n), 
		   .we_n(we_n),
                   .data_in(data_in), 
                   .data_out(data_out)
                   );
initial begin
  clk = 0;
  forever #(period/2) clk = ~clk;
end
initial begin
  rst_n = 0;
  data_in = 0; //all variables should be initialized at the beginning 
               //of simulation
  @(negedge clk) rst_n = 1;
  for (i=0; i<256; i=i+1) begin
    @(negedge clk) data_in = i;
  end
  @(negedge clk); 
  $finish;  
end
initial begin
    we_n=0;
    #(period*4) we_n = 1;
    #(period*4) we_n = 0;
end
endmodule
