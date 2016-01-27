`timescale 1ns / 1ps
module edge2(clk, n_rst, in, out);
  input clk, n_rst, in;
  output out;
  reg in_reg;
  always @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
      in_reg <= 1'b0;
    end else begin
      in_reg <= in; 
    end
  end
  assign out = in & ~in_reg;
endmodule

module edge2_tb();
parameter period = 2;
reg clk, n_rst, in;
wire out;
edge2 instance(.clk(clk),
	       .n_rst(n_rst),
	       .in(in),
	       .out(out));
initial begin
    clk = 0;
    forever
    #(period/2)clk = ~clk;
end

initial begin
    n_rst = 0;
    in = 0;
    @(negedge clk) n_rst = 1;
    @(negedge clk) in = 1;
    @(negedge clk);
    @(negedge clk) in = 0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk) in = 1;
    @(negedge clk);
    @(negedge clk);
    $finish();
end
endmodule
