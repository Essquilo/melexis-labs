`timescale 1ns / 1ps
module reg_4bit(clk, rst_n, out);
parameter width = 4;
input clk, rst_n;
output reg [width - 1:0] out;
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out <= 4'b1000;  
    end else begin
           out <= {out[0], out[width-1:1]};
    end
end
endmodule

`timescale 1ns / 1ps
module reg_4bit_tb;
parameter period = 4;
reg clk, rst_n;
wire [3:0] out;
reg_4bit reg_inst1(.clk(clk), 
                   .rst_n(rst_n), 
                   .out(out)
                   );
initial begin
    clk = 0;
    forever #(period/2) clk = ~clk;
end
initial begin
    rst_n = 0;
    @(negedge clk);
    @(negedge clk) rst_n = 1;
    repeat (10)
    @(negedge clk); 
    $finish;  
end
endmodule
