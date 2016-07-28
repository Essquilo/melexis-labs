`timescale 1ns/1ps
module tb_vending_machine;
parameter reg DEBUG = 1;
parameter CLOCK_PERIOD = 20;
parameter PRODUCTS = 4;
parameter CURRENCIES = 8;
parameter INIT_CURRENCIES_AMOUNT = 100;
wire busy, ready_to_receive, change_strobe, no_change, give_strobe;
wire [$clog2(PRODUCTS)-1:0] product;
wire [$clog2(CURRENCIES)-1:0] change; 

reg clk, rst_n, product_strobe, currency_strobe;
reg [$clog2(PRODUCTS)-1:0] product_code;
reg [$clog2(CURRENCIES)-1:0] currency_code; 
vending_machine #(.INIT_CURRENCIES_AMOUNT(INIT_CURRENCIES_AMOUNT)) inst (
	.clk(clk),
	.i_rst_n(rst_n),
  	.i_product_code(product_code), 
  	.i_product_strobe(product_strobe),
    .i_currency_code(currency_code), 
    .i_currency_strobe(currency_strobe), 
  	.o_busy(busy), 
	.o_ready_to_receive(ready_to_receive), 
  	.o_change(change), 
  	.o_change_strobe(change_strobe), 
  	.o_no_change(no_change),
    .o_product(product), 
    .o_give_strobe(give_strobe)
    );
integer i;

integer test_count;
integer error_count;
integer total_money_given;
integer total_money_received;
integer price;
reg error_flag;

initial begin
test_count = 0;
error_count = 0;
clk = 0;
rst_n = 0;
#(CLOCK_PERIOD/2) rst_n = 1;
repeat (100) begin
	test_count = test_count+1;
	imitate_user();
end
$display("===============TEST SUMMARY===============");
$display("Test executed: %d; passed: %d; failed: %d.", test_count, test_count-error_count, error_count);
$display("===============END  SUMMARY===============");
$stop();
end

always #(CLOCK_PERIOD/2) clk = ~clk;

task imitate_user();
begin
	$display("===============TEST#%d START==============", test_count);
	currency_strobe = 0;
	product_strobe = 0;
	total_money_given = 0;
	total_money_received = 0;
	error_flag = 0;
	
	@(negedge clk);
	//requesting product
	product_code = $urandom_range(inst.PRODUCTS, 0);
	price = inst.PRODUCT_PRICES[product_code];
	if(DEBUG) begin
		$display("Requesting product for %dkop", price);
		end
	product_strobe = 1;
	
	@(negedge clk);
	//checking if it is actually busy
	if(!busy)
		$display("Error, the FSM hasn't switched");
	product_strobe = 0;	
	while(total_money_given<price) begin	
		@(negedge clk);
		if(ready_to_receive) begin
		//loading 1 currency
			currency_code = $urandom_range(inst.CURRENCIES, 0);
			currency_strobe = 1;
			total_money_given = total_money_given + inst.CURRENCY_VALUES[currency_code];
			if(DEBUG)
				$display("Giving %dkop, %dkop total", inst.CURRENCY_VALUES[currency_code], total_money_given);
		end
		else begin
			//processing previous
			currency_strobe = 0;
		end
	end
	
	@(negedge clk);
	if(give_strobe) begin
	//machine assumes that the price was exact, checking if it's right
		if(!total_money_given==price)
			$display("Error, the price was not exact, expected %dkop given", total_money_given-price);
		else 
			$display("The price is equal with the money given");
	end 
	else begin
	//we receive change until we have the product
		while(!give_strobe) begin	
			@(negedge clk);
			//getting change
			if(change_strobe) begin
				total_money_received = total_money_received + inst.CURRENCY_VALUES[change];
				if(DEBUG)
					$display("Received %dkop, %dkop total", inst.CURRENCY_VALUES[change], total_money_received);
			end
		end
		if(total_money_received!=total_money_given-price)
			if(!no_change)
				$display("Error, the change is not exact, expected %dkop given, actually %dkop given", total_money_given-price, total_money_received);
			else
				$display("The machine does not have enough change");
	end
	
	@(negedge clk);
	if(busy)
		$display("Error, the FSM hasn't switched off");
	if(error_flag) begin
		error_count = error_count + 1;
		$display("TEST#%d EXECUTED WITH ERROR", test_count);
	end
	$display("===============TEST#%d END==============", test_count);
end
endtask
endmodule