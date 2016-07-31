	`timescale 1 ns / 1 ns

module filter_custom
               (
                clk,
                clk_enable,
                i_rst_n,
                i_data,
					 o_result_ready,
                o_data
                );
  input   clk; 
  input   clk_enable; 
  input   i_rst_n; 
  input   signed [17:0] i_data;
  output reg o_result_ready;
  output reg signed [17:0] o_data;
  reg signed [17:0] data_pipe [10:0];
  reg [3:0] step_counter;
  reg signed [21:0] shifted_data;
  reg signed [21:0] data_to_add;
  reg signed [24:0] accumulator;
  wire signed [24:0] addition_result;
  assign addition_result = accumulator+data_to_add;
  integer i;
  
always @(posedge clk or negedge i_rst_n) begin
	if(!i_rst_n) begin
		o_data <=0;
		step_counter<=0;
		o_result_ready<=0;
		accumulator<=0;
		for(i=0; i<11;i=i+1)
			data_pipe[i]<=0;
	end else begin
		if(clk_enable) begin
			if(step_counter==0) begin
				step_counter<=step_counter+1;
				o_result_ready<=0;
				data_pipe[0]<=i_data;
				for(i=1; i<11;i=i+1)
					data_pipe[i]<=data_pipe[i-1];
				accumulator <= data_to_add;
			end else if(step_counter==14) begin
				step_counter<=0;
				o_result_ready<=1;
				if(addition_result[24]==addition_result[23] && addition_result[24]==addition_result[22])
					//testbench values assume some rounding, so there it is.
					o_data<=(addition_result[24:0] + {addition_result[5], {4{~addition_result[5]}}})>>>5;
				else
					if(addition_result[24])
						o_data <= 18'b100000000000000000;
					else
						o_data <= 18'b011111111111111111;
			end else begin
				step_counter<=step_counter+1;
				o_result_ready<=0;
				accumulator<=addition_result;
			end
		end
	end
end
  
always @(step_counter or data_pipe or i_data) begin
	//synopsys full_case parallel_case
	case(step_counter)
		 0:shifted_data = i_data;
		//we already pushed the i_data to data_pipe, so using the pushed value
		 1: shifted_data = data_pipe[0]<<1;
		 2: shifted_data = data_pipe[1]<<3;
		 3: shifted_data = data_pipe[2]<<3;
		 4: shifted_data = data_pipe[4]<<3;
		 5: shifted_data = data_pipe[4]<<1;
		 6: shifted_data = data_pipe[4];
		 7: shifted_data = data_pipe[5]<<4;
		 8: shifted_data = data_pipe[6]<<3;
		 9: shifted_data = data_pipe[6]<<1;
		10: shifted_data = data_pipe[6];
		11: shifted_data = data_pipe[8]<<3;
		12: shifted_data = data_pipe[9]<<3;
		13: shifted_data = data_pipe[10];
		14: shifted_data = data_pipe[10]<<1;
	endcase
	//less adders is better
	if(step_counter>=0 && step_counter<4 || step_counter>=11 && step_counter<15) begin
		data_to_add = -shifted_data;
	end else begin
		data_to_add = shifted_data;
	end
end

endmodule  // filter
