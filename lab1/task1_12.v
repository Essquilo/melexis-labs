`timescale 1ns / 1ps
module johnson_latch(clk, rst_n, out);
parameter WIDTH = 4;
input clk, rst_n;
output reg [WIDTH - 1:0] out;
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out <= 0;  
    end else begin
	if(out[0]==0) begin
	    out <= {1'b1, out[WIDTH-1:1]};
	end else begin
	    out <= {1'b0, out[WIDTH-1:1]};
	end
    end
end
endmodule

`timescale 1ns / 1ps
module johnson_latch_tb;
parameter PERIOD = 4;
parameter WIDTH = 4;
reg clk, rst_n;
wire [WIDTH-1:0] out;
johnson_latch #(.WIDTH(WIDTH)) reg_inst1(.clk(clk), 
                   .rst_n(rst_n), 
                   .out(out)
                   );
initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
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
