`timescale 1ns / 1ps
module non_pipelined(clk, rst_n, in_a, in_b, in_c, out_q);
parameter WIDTH = 4;
input clk, rst_n;
input [WIDTH-1:0] in_a, in_b, in_c;
reg [WIDTH-1:0] buf_a, buf_b, buf_c;
output reg [WIDTH-1:0] out_q;

always @(posedge clk, negedge rst_n) begin
if(!rst_n)begin
    buf_a<=0;
    buf_b<=0;
    buf_c<=0;
    out_q<=0;
end else begin
    buf_a<=in_a;
    buf_b<=in_b;
    buf_c<=in_c;
    out_q<=(buf_a+buf_b)^buf_c;
end
end
endmodule
`timescale 1ns / 1ps
module pipelined(clk, rst_n, in_a, in_b, in_c, out_q);
parameter WIDTH = 4;
input clk, rst_n;
input [WIDTH-1:0] in_a, in_b, in_c;
reg [WIDTH-1:0] buf_a, buf_b, buf_c;
reg [WIDTH-1:0] buf_c_stage, buf_q;
output reg [WIDTH-1:0] out_q;

always @(posedge clk, negedge rst_n) begin
if(!rst_n)begin
    buf_a<=0;
    buf_b<=0;
    buf_c<=0;
    buf_c_stage<=0;
    buf_q<=0;
    out_q<=0;
end else begin
    buf_a<=in_a;
    buf_b<=in_b;
    buf_c<=in_c;
    buf_c_stage<=buf_c;
    buf_q<=buf_a+buf_b;
    out_q<=buf_q^buf_c_stage;
end
end
endmodule

`timescale 1ns / 1ps
module pipeline_tb;
parameter PERIOD = 4;
parameter WIDTH = 4;
reg clk, rst_n;
reg [WIDTH-1:0] A, B, C;
wire [WIDTH-1:0] Q, Q_pipe;
non_pipelined #(.WIDTH(WIDTH)) inst1(.clk(clk), 
                   .rst_n(rst_n), 
		   .in_a(A),
		   .in_b(B),
		   .in_c(C),
                   .out_q(Q)
                   );
pipelined #(.WIDTH(WIDTH)) inst2(.clk(clk), 
                   .rst_n(rst_n), 
                   .in_a(A),
		   .in_b(B),
		   .in_c(C),
                   .out_q(Q_pipe)
                   );
initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
end
initial begin
    rst_n = 0;
    A = 4'b0100;
    B = 4'b0100;
    C = 4'b0001;
    @(negedge clk) rst_n = 1;
    @(negedge clk); 
    A = 4'b1001;
    B = 4'b0011;
    C = 4'b1101;
    @(negedge clk); 
    A = 4'b1101;
    B = 4'b0101;
    C = 4'b0010;
    @(negedge clk); 
    A = 4'b0001;
    B = 4'b1101;
    C = 4'b0110;
    @(negedge clk); 
    A = 4'b1101;
    B = 4'b1101;
    C = 4'b1100;
    @(negedge clk); 
    A = 4'b1001;
    B = 4'b0110;
    C = 4'b0101;
    @(negedge clk); 
    A = 4'b1010;
    B = 4'b0101;
    C = 4'b0111;
    @(negedge clk); 
    A = 4'b0010;
    B = 4'b1111;
    C = 4'b0010;
    @(negedge clk); 
    A = 4'b1110;
    B = 4'b1000;
    C = 4'b0101;
    @(negedge clk); 
    A = 4'b1100;
    B = 4'b1101;
    C = 4'b1101;
    @(negedge clk); 
    A = 4'b0101;
    B = 4'b0011;
    C = 4'b1010;
    @(negedge clk); 
    A = 4'b0000;
    B = 4'b0000;
    C = 4'b1010;
    @(negedge clk); 
    A = 4'b1101;
    B = 4'b0110;
    C = 4'b0011;
    @(negedge clk); 
    A = 4'b1101;
    B = 4'b0011;
    C = 4'b1011;
    @(negedge clk); 
    $finish;  
end
endmodule