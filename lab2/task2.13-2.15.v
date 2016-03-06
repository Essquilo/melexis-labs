module gate_level_alu(i_op1, i_op2, i_command, o_res);
parameter WIDTH = 4;
input [WIDTH-1:0] i_op1, i_op2;
input [2:0] i_command; //0: add, 1: substract, 2: nand, 3: nor, 4-7:multiply
output [2*WIDTH-1:0] o_res;
wire [WIDTH-1:0] add_res, sub_res, nand_res, nor_res;
wire [2*WIDTH-1:0] mult_res;
adder #(.WIDTH(WIDTH)) adder_inst(
	.i_op1(i_op1),
	.i_op2(i_op2),
	.i_carry(1'b0),
	.o_res(add_res)
	);

substractor #(.WIDTH(WIDTH)) substractor_inst(
	.i_op1(i_op1),
	.i_op2(i_op2),
	.i_borrow(1'b0),
	.o_res(sub_res)
	);

bitwise_nand #(.WIDTH(WIDTH)) nand_inst(
	.i_op1(i_op1),
	.i_op2(i_op2),
	.o_res(nand_res)
	);

bitwise_nor #(.WIDTH(WIDTH)) nor_inst(
	.i_op1(i_op1),
	.i_op2(i_op2),
	.o_res(add_res)
	);

multiplier #(.WIDTH(2*WIDTH)) mult_inst(
	.i_op1(i_op1),
	.i_op2(i_op2),
	.o_res(mult_res)
	);

mux #(.WIDTH(WIDTH)) mux_inst(
	.i_val({mult_res[WIDTH-1:0], nor_res, nand_res, sub_res, add_res}),
	.i_addr(i_command),
	.o_res(o_res[WIDTH-1:0])
	);
generate
	genvar i;
	for (i = 0; i < WIDTH; i = i + 1)
	begin
		and(o_res[WIDTH+i], i_command[2], mult_res[WIDTH+i]);
	end
endgenerate
endmodule

module behavioral_alu(i_op1, i_op2, i_command, o_res);
parameter WIDTH = 4;
input [WIDTH-1:0] i_op1, i_op2;
input [2:0] i_command; //0: add, 1: substract, 2: nand, 3: nor, 4-7:multiply
output reg [2*WIDTH-1:0] o_res;

always @(i_op1, i_op2, i_command) begin
	o_res = i_op1*i_op2;

	//synopsis full_case parallel_case
	case (i_command)
		0: o_res = { {WIDTH{1'b0}}, i_op1+i_op2};
		1: o_res = { {WIDTH{1'b0}}, i_op1-i_op2};
		2: o_res = { {WIDTH{1'b0}}, ~(i_op1&i_op2)};
		3: o_res = { {WIDTH{1'b0}}, ~(i_op1|i_op2)};
	endcase
end
endmodule

module tb_alu();
parameter WIDTH = 4;
reg [WIDTH-1:0] op1, op2;
reg [2:0] command;
wire [2*WIDTH-1:0] res, control_res;

gate_level_alu #(.WIDTH(WIDTH)) inst(
	.i_op1(op1),
	.i_op2(op2),
	.i_command(command),
	.o_res(res)
	);

behavioral_alu #(.WIDTH(WIDTH)) control(
	.i_op1(op1),
	.i_op2(op2),
	.i_command(command),
	.o_res(control_res)
	);

integer c, i, j, error_count, test_count;
initial begin
op1 = 0;
op2 = 0;
error_count = 0;
test_count = 0;
for(c = 0; c<8; c = c+1) begin
	command = c;	
	for(i=0; i<2**WIDTH; i=i+1) begin
		op1 = i;
		for(j=0; j<2**WIDTH; j=j+1)begin
			op2 = j;
			#10;
			if(control_res!=res)begin
				$display("Error with %b, %b, command=%d. Expected %b, got %b.", op1, op2, command,  control_res, res);
				error_count = error_count+1;
			end
			test_count = test_count+1;
		end
	end
end

$display("Combinations tested: %d. %d errors during simulation", test_count, error_count);
$finish();
end
endmodule