`timescale 1ns / 1ps
module johnson_latch(clk, rst_n, out);
parameter WIDTH = 4;
input clk, rst_n;
output reg [WIDTH - 1:0] out;
always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        out <= 4'b0000;  
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
module complex_latch (clk, rst_n, data_in, data_out);
parameter WIDTH = 4;
input clk, rst_n;
input [WIDTH-1:0] data_in;
wire [WIDTH-1:0] jcnt_out;
output reg [WIDTH-1:0] data_out;
johnson_latch #(.WIDTH(WIDTH)) reg_inst1(.clk(clk), 
                   .rst_n(rst_n), 
                   .out(jcnt_out)
                   );

always @(rst_n, data_in, jcnt_out) begin
if(!rst_n) begin
    data_out<=0;
end else begin
    if(!(jcnt_out[0]^jcnt_out[WIDTH-1])) begin
	data_out <= data_in;
    end
    end
end

endmodule

`timescale 1ns / 1ps
module complex_latch_tb;
parameter period = 4;
parameter WIDTH = 4;
reg clk, rst_n;
reg [WIDTH-1:0] in;
wire [WIDTH-1:0] out;
complex_latch  #(.WIDTH(WIDTH)) instance(.clk(clk), 
		   .data_in(in),
                   .rst_n(rst_n), 
                   .data_out(out)
                   );
initial begin
    clk = 0;
    forever #(period/2) clk = ~clk;
end
initial begin
    rst_n = 0;
    in = 4;
    @(negedge clk) rst_n = 1;
    @(negedge clk);
    @(negedge clk); 
    in = 1;
    @(negedge clk); 
    in=9;
    @(negedge clk);
    in=3; 
    @(negedge clk); 
    in=13;
    @(negedge clk); 
    @(negedge clk); 
    in=5;
    @(negedge clk); 
    in = 2;
    $finish;  
end
endmodule
