`timescale 1ns/1ps
module half_adder(i_op1, i_op2, o_res, o_carry);
input wire i_op1, i_op2;
output wire o_res, o_carry;
xor m_xor (o_res, i_op1, i_op2);
and m_and (o_carry, i_op1, i_op2);
endmodule

module full_adder(i_op1, i_op2, i_carry, o_res, o_carry);
input wire i_op1, i_op2, i_carry;
wire res_buffer, carry_buffer, carry_buffer2;
output wire o_res, o_carry;
half_adder m_hadder1 (.i_op1(i_op1),
							 .i_op2(i_op2),
							 .o_res(res_buffer),
							 .o_carry(carry_buffer));
half_adder m_hadder2 (.i_op1(res_buffer),
							 .i_op2(i_carry),
							 .o_res(o_res),
							 .o_carry(carry_buffer2));
or m_or(o_carry, carry_buffer, carry_buffer2);
endmodule

module adder(i_op1, i_op2, i_carry, o_res, o_carry);
parameter WIDTH = 4;
input wire [WIDTH-1:0] i_op1, i_op2;
input wire i_carry;
output wire [WIDTH-1:0] o_res;
output wire o_carry;

genvar i;
generate
for(i=0; i<WIDTH; i=i+1) begin : adders
wire carry_buffer;
wire carry_chooser;
if (i==0) 
	assign carry_chooser = i_carry;
else
	assign carry_chooser = adders[i-1].carry_buffer;
	
full_adder full_adder_array(.i_op1(i_op1[i]),
									 .i_op2(i_op2[i]),
									 .i_carry(adders[i].carry_chooser),
									 .o_res(o_res[i]),
									 .o_carry(carry_buffer)
									 );
if(i==WIDTH-1)
	assign o_carry = carry_buffer;
end
endgenerate
endmodule

module tb_adder();
parameter WIDTH = 4;
reg [WIDTH-1:0] op1, op2;
reg i_carry;
wire[WIDTH-1:0] res;
wire o_carry;

reg [WIDTH:0] control_res;
integer i, j, error_count;

adder #(.WIDTH(WIDTH)) inst(.i_op1(op1),
			  .i_op2(op2),
			  .i_carry(i_carry), 
			  .o_res(res),
			  .o_carry(o_carry)
);

initial begin
op1 = 0;
op2 = 0;
i_carry = 0;
control_res = 0;
error_count = 0;
#10;
for(i=0; i<2**WIDTH;i=i+1) begin
	op1 = i;
	for(j=0; j<2**WIDTH;j=j+1) begin
		if(control_res[WIDTH-1:0]!=res || control_res[WIDTH]!=o_carry) begin
			$display("Error with numbers %d + %d. Expected %d, got %d", op1, op2, control_res, res);
			error_count = error_count+1;
			end
		op2 = j;
		control_res = op1+op2;
		#10;
	end
end
$display("%d errors during simulation", error_count);
$finish();
end
endmodule