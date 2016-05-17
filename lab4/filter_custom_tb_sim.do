onbreak resume
onerror resume
vsim -novopt work.filter_custom_tb
add wave sim:/filter_custom_tb/u_filter/clk
add wave sim:/filter_custom_tb/u_filter/clk_enable
add wave sim:/filter_custom_tb/u_filter/reset
add wave sim:/filter_custom_tb/u_filter/filter_in
add wave sim:/filter_custom_tb/u_filter/filter_out
add wave sim:/filter_custom_tb/filter_out_ref
run -all
