`timescale 1ns/1ps
module substractor(i_op1, i_op2, i_borrow, o_res, o_borrow);
parameter WIDTH = 4;
input wire [WIDTH-1:0] i_op1, i_op2;
input wire i_borrow;
output wire [WIDTH-1:0] o_res;
output wire o_borrow;

genvar i;
generate
for(i=0; i<WIDTH; i=i+1) begin : subs
	wire borrow, prev_borrow;
	if(i==0) //cause stupid ModelSim cannot compile ternary in instatiation
		assign prev_borrow = i_borrow;
	else
		assign prev_borrow = subs[i-1].borrow;
	
	wire xor_1, not_1, not_2, and_1, and_2;

 	xor (xor_1, i_op1[i], i_op2[i]);
 	xor (o_res[i], prev_borrow, xor_1);

 	and (and_1, i_op2[i], not_1);
 	and (and_2, prev_borrow, not_2);
  
 	not (not_1, i_op1[i]);
 	not (not_2, xor_1);
  
 	or (borrow, and_1, and_2);

	if(i==WIDTH-1)
		assign o_borrow = borrow;
end
endgenerate
endmodule

module tb_substractor();
parameter WIDTH = 4;
reg [WIDTH-1:0] op1, op2;
reg i_borrow;
wire[WIDTH-1:0] res;
wire o_borrow;

reg [WIDTH:0] control_res;
integer i, j, error_count;

substractor #(.WIDTH(WIDTH)) inst(.i_op1(op1),
			  .i_op2(op2),
			  .i_borrow(i_borrow), 
			  .o_res(res),
			  .o_borrow(o_borrow)
);

initial begin
op1 = 0;
op2 = 0;
i_borrow = 0;
control_res = 0;
error_count = 0;
#10;
for(i=0; i<2**WIDTH;i=i+1) begin
	op1 = i;
	for(j=0; j<2**WIDTH;j=j+1) begin
		if(control_res[WIDTH-1:0]!=res || control_res[WIDTH]!=o_borrow) begin
			$display("Error with numbers %d - %d. Expected %d, got %d", op1, op2, control_res[WIDTH-1:0], res);
			error_count = error_count+1;
			end
		op2 = j;
		control_res = i-j;
		#10;
	end
end
$display("%d errors during simulation", error_count);
$finish();
end
endmodule