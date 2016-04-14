`timescale 1ns/1ps
module vending_machine(
	clk, i_rst_n,
  	i_product_code, i_product_strobe,
   	i_currency_code, i_currency_strobe, 
  	o_busy, o_change, o_change_strobe, o_no_change,
    o_product, o_give_strobe
    );

//parameters for product types, prices and width of product code
parameter INIT_VALUES = 10;
parameter PRODUCTS = 4;
parameter integer PRODUCT_PRICES [PRODUCTS-1:0] = '{100, 200, 300, 150};
localparam PRODUCT_WIDTH = $clog2(PRODUCTS);

//parameters for currency values and width of currency code and number of currency counters
parameter CURRENCIES = 8;
parameter integer CURRENCY_VALUES [CURRENCIES-1:0] = '{500, 200, 100, 50, 25, 10, 5, 1};
localparam CURRENCY_WIDTH = $clog2(CURRENCIES);

input clk, i_rst_n, i_product_strobe, i_currency_strobe;
input [PRODUCT_WIDTH-1:0] i_product_code;
input [CURRENCY_WIDTH-1:0] i_currency_code;
output reg o_busy, o_change_strobe, o_no_change, o_give_strobe;
output reg [PRODUCT_WIDTH-1:0] o_product;
output reg [CURRENCY_WIDTH-1:0] o_change;

parameter IDLE = 0;
parameter READY_TO_RECEIVE = 1;
parameter RECEIVED = 2;
parameter ENOUGH_MONEY = 3;
parameter CHANGE_NEEDED = 4;
parameter GIVE_CHANGE = 5;
parameter NO_CHANGE = 6;
parameter GIVE_PRODUCT = 7;

localparam STATE_WIDTH = 3;
reg [STATE_WIDTH-1:0] state;

integer currency_amount [CURRENCIES-1:0];
integer inserted_amount;
integer previous_amount;
integer i;
always @(posedge clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		state <= IDLE;
		o_busy<=0;
		o_product<=0;
		inserted_amount<=0;
		previous_amount<=0;
		o_change_strobe<=0;
		o_give_strobe<=0;
		o_no_change<=0;
		for(i=0; i<CURRENCIES; i=i+1)
			currency_amount[i] <= INIT_VALUES;
	end
	else begin
		o_change_strobe<=0;
		o_give_strobe<=0;
		o_no_change<=0;
		previous_amount<=inserted_amount;
		case (state)
		IDLE: begin
			if(i_product_strobe) begin
				state<=READY_TO_RECEIVE;
				o_product<=i_product_code;
				o_busy<=1;
			end
		end
		READY_TO_RECEIVE: begin
			if (i_currency_strobe) begin
				for(i = 0; i<CURRENCIES;i = i+1)
					if(i==i_currency_code) begin
						inserted_amount <= inserted_amount + CURRENCY_VALUES[i];
					end
				state<=RECEIVED;
			end
		end
		RECEIVED: begin
			if(inserted_amount>=PRODUCT_PRICES[o_product]) begin
				state<=ENOUGH_MONEY;
			end
			else begin
				state<=READY_TO_RECEIVE;
			end
		end
		ENOUGH_MONEY: begin
			if(inserted_amount==PRODUCT_PRICES[o_product]) begin
				state<=GIVE_PRODUCT;
				o_give_strobe<=1;
			end
			else begin
				state<=CHANGE_NEEDED;
			end
		end
		CHANGE_NEEDED: begin
			if (i_currency_strobe) begin
				for(i = 0; i < CURRENCIES;i = i+1)
					if(CURRENCY_VALUES[i]<=inserted_amount-PRODUCT_PRICES[o_product] && currency_amount[i]>0) begin
						inserted_amount<=inserted_amount - CURRENCY_VALUES[i];
						o_change<=i;
					end
			end
		state<=GIVE_CHANGE;
		end
		GIVE_CHANGE: begin
			if(inserted_amount<previous_amount)begin
				currency_amount[o_change]<=currency_amount[o_change] - 1;
				o_change_strobe<=1;
				state<=ENOUGH_MONEY;
			end 
			else begin
				state<=NO_CHANGE;
			end
		end
		NO_CHANGE: begin
			o_no_change<=1;
			o_give_strobe<=1;
			state<=GIVE_PRODUCT;
		end
		GIVE_PRODUCT: begin
			state<=IDLE;
			o_busy<=0;
		end
		default: begin
			state<=IDLE;
		end
		endcase
	end
end
endmodule

module tb_vending_machine;
parameter PRODUCTS = 4;
parameter CURRENCIES = 8;
wire busy, change_strobe, no_change, give_strobe;
wire [$clog2(PRODUCTS)-1:0] product;
wire [$clog2(CURRENCIES)-1:0] change; 

reg clk, rst_n, product_strobe, currency_strobe;
reg [$clog2(PRODUCTS)-1:0] product_code;
reg [$clog2(CURRENCIES)-1:0] currency_code; 
vending_machine inst (
	.clk(clk),
	.i_rst_n(rst_n),
  	.i_product_code(product_code), 
  	.i_product_strobe(product_strobe),
   	.i_currency_code(currency_code), 
   	.i_currency_strobe(currency_strobe), 
  	.o_busy(busy), 
  	.o_change(change), 
  	.o_change_strobe(change_strobe), 
  	.o_no_change(no_change),
    .o_product(product), 
    .o_give_strobe(give_strobe)
    );
integer i;

initial begin
	//initializing
	clk = 0;
	rst_n = 0;
	product_strobe = 0;
	currency_strobe = 0;
	#10 clk = 1;
	#10 clk = 0;
	rst_n=1;

	//some empty clk
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;

	//request for product
	product_code = 3;
	product_strobe = 1;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;

	//giving money
	currency_code = 4;
	currency_strobe = 1;
	#10 clk = 1;
	#10 clk = 0;
	#10 clk = 1;
	#10 clk = 0;

	//one more
	currency_code = 6;
	currency_strobe = 1;

	//to ensure that change withdrawal algorithm works
	repeat(10) begin
		#10 clk = 1;
		#10 clk = 0;
	end
end
endmodule