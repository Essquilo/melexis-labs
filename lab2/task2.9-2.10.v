module bitwise_nand(i_op1, i_op2, o_res);
parameter WIDTH = 4;
input [WIDTH-1:0] i_op1, i_op2;
output [WIDTH-1:0] o_res;
generate
	genvar i;
	for(i=0; i<WIDTH; i=i+1) begin: or_bus
		nand(o_res[i], i_op1[i], i_op2[i]);
	end
endgenerate
endmodule

module tb_nand();
parameter WIDTH = 4;
reg [WIDTH-1:0] op1, op2, control_res;
wire [WIDTH-1:0] res;
bitwise_nand #(.WIDTH(WIDTH)) inst(
	.i_op1(op1),
	.i_op2(op2),
	.o_res(res)
	);

integer i, j, error_count;
initial begin
op1 = 0;
op2 = 0;
control_res = 0;
error_count = 0;
for(i=0; i<2**WIDTH; i=i+1) begin
	op1 = i;
	for(j=0; j<2**WIDTH; j=j+1)begin
		op2 = j;
		#10;
		control_res = ~(op1&op2);
		if(control_res!=res)begin
			$display("Error with %b, %b. Expected %b, got %b.", op1, op2, control_res, res);
			error_count = error_count+1;
		end
	end
end
$display("%d errors during simulation", error_count);
$finish();
end
endmodule