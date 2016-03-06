`timescale 1ns/1ps
module adder_subs(i_op1, i_op2, i_carry_borrow, o_res, o_carry_borrow);
parameter WIDTH = 4;
parameter MODE = 0;
input wire [WIDTH-1:0] i_op1, i_op2;
input wire i_carry_borrow;
output wire [WIDTH-1:0] o_res;
output wire o_carry_borrow;
generate	
	if(MODE)
	adder #(.WIDTH(WIDTH)) inst(
		.i_op1(i_op1),
		.i_op2(i_op2),
		.i_carry(i_carry_borrow),
		.o_res(o_res),
		.o_carry(o_carry_borrow)
		);
else
	substractor #(.WIDTH(WIDTH)) inst(
			.i_op1(i_op1),
			.i_op2(i_op2),
			.i_borrow(i_carry_borrow),
			.o_res(o_res),
			.o_borrow(o_carry_borrow)
			);
endgenerate
endmodule