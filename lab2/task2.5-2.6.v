`timescale 1ns/1ps
module multiplier(i_op1, i_op2, o_res);
parameter WIDTH = 4;
input wire [WIDTH-1:0] i_op1, i_op2;
output wire [2*WIDTH-1:0] o_res;

genvar i, j;
generate
for(i=0; i<WIDTH; i=i+1) begin : stages
	//generating stages of op1, masked by digits of op2
	for(j=0; j<WIDTH; j=j+1) begin : and_stage
		wire shifted;
		and(shifted, i_op1[j], i_op2[i]);
	end

	//generating flow-like adders stages
	for (j=0; j<WIDTH; j=j+1)begin : adder_stages
		wire add_res;
		wire op2;
		wire out_carry;
		wire in_carry;

		if(j==0)
			assign in_carry = 0;
		else 
			assign in_carry = adder_stages[j-1].out_carry;	

		if(i==0) begin
			assign add_res = and_stage[j].shifted;
			assign out_carry = 0;
		end
		else begin
			if(j==WIDTH-1)
				assign op2 = stages[i-1].adder_stages[WIDTH-1].out_carry;
			else
				assign op2 = stages[i-1].adder_stages[j+1].add_res;	
			full_adder adder(
				.i_op1(and_stage[j].shifted),
				.i_op2(op2), 
				.i_carry(in_carry),
				.o_res(add_res),
				.o_carry(out_carry));
		end
	end

	//assigning result to o_res
	assign o_res[i] = adder_stages[0].add_res;
	if(i==WIDTH-1)begin
		for (j=1; j<WIDTH; j=j+1) 
			assign o_res[WIDTH-1+j] = adder_stages[j].add_res;
		assign o_res[2*WIDTH-1] = adder_stages[WIDTH-1].out_carry;
	end
end
endgenerate
endmodule

module tb_multiplier();
parameter WIDTH = 4;
reg [WIDTH-1:0] op1, op2;
wire[2*WIDTH-1:0] res;

reg [2*WIDTH-1:0] control_res;
integer i, j, error_count;

multiplier #(.WIDTH(WIDTH)) inst(
			  	.i_op1(op1),
			  	.i_op2(op2),
			  	.o_res(res)
);

initial begin
op1 = 0;
op2 = 0;
control_res = 0;
error_count = 0;
#10;
for(i=0; i<2**WIDTH;i=i+1) begin
	op1 = i;
	for(j=0; j<2**WIDTH;j=j+1) begin
		if(control_res!=res) begin
			$display("Error with numbers %b * %b. Expected %b, got %b", op1, op2, control_res, res);
			error_count = error_count+1;
			end
		op2 = j;
		control_res = i*j;
		#10;
	end
end
$display("%d errors during simulation", error_count);
$finish();
end
endmodule