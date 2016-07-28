`timescale 1ns/1ps
module vending_machine(
	clk,
	i_rst_n,
  	i_product_code,
	i_product_strobe,
   i_currency_code, 
	i_currency_strobe, 
  	o_busy,
	o_ready_to_receive,
	o_change,
	o_change_strobe, 
	o_no_change,
   o_product,
	o_give_strobe
   );

//parameters for initial load of money
parameter INIT_CURRENCIES_AMOUNT = 100;

//must be bigger than 9 to fit max currency value
parameter WIDTH_OF_MONEY = 16;

localparam PRODUCTS = 4;
localparam reg signed [WIDTH_OF_MONEY-1:0] PRODUCT_PRICES [PRODUCTS-1:0] = '{100, 200, 300, 150};
localparam PRODUCT_WIDTH = $clog2(PRODUCTS);
	
//parameters for currency values and width of currency code and number of currency counters
localparam CURRENCIES = 8;
localparam reg signed [WIDTH_OF_MONEY-1:0] CURRENCY_VALUES [CURRENCIES-1:0] = '{500, 200, 100, 50, 25, 10, 5, 1};
localparam CURRENCY_WIDTH = $clog2(CURRENCIES);

input clk, i_rst_n, i_product_strobe, i_currency_strobe;
input [PRODUCT_WIDTH-1:0] i_product_code;
input [CURRENCY_WIDTH-1:0] i_currency_code;
output reg o_busy, o_change_strobe, o_no_change, o_give_strobe, o_ready_to_receive;
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

localparam STATE_WIDTH = 4;
reg [STATE_WIDTH-1:0] state;

reg signed [WIDTH_OF_MONEY-1:0] currency_amount [CURRENCIES-1:0];
reg signed [WIDTH_OF_MONEY-1:0] inserted_amount;
reg signed [WIDTH_OF_MONEY-1:0] previous_amount;
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
			currency_amount[i] <= INIT_CURRENCIES_AMOUNT;
	end
	else begin
		o_change_strobe<=0;
		o_give_strobe<=0;
		o_no_change<=0;
		previous_amount<=inserted_amount;
		case (state)
		IDLE: begin
			inserted_amount<=0;
			previous_amount<=0;
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

always @(state) begin
	o_ready_to_receive = state==READY_TO_RECEIVE;
end
endmodule