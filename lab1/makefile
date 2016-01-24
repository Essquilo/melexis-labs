task1_5: clean libs
	ncvlog -message -work worklib -v task1_5.v
	ncelab -message -access w -neverwarn -snapshot verilog_snapshot worklib.reg_8bit_tb:module
	ncsim -message -gui worklib.verilog_snapshot:module
task1_7: clean libs
	ncvlog -message -work worklib -v task1_7.v
	ncelab -message -access w -neverwarn -snapshot verilog_snapshot worklib.param_shift_reg_tb:module
	ncsim -message -gui worklib.verilog_snapshot:module
libs:
	mkdir ./INCA_libs
	mkdir ./INCA_libs/worklib
clean:
	rm -rf core *.key *.log* *.out *.df *.dsn *.trn *.shm *.rpt .cov *.cmd* INCA_libs
.PHONY: libs clean
.IGNORE: libs

