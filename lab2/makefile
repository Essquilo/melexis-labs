list:
	echo "task2.1-2.2, task2.3-2.4, task2.5-2.6"

task2.5-2.6: target=task2.5-2.6
task2.5-2.6: entity=tb_multiplier
task2.5-2.6: sim

task2.3-2.4: target=task2.3-2.4
task2.3-2.4: entity=tb_substractor
task2.3-2.4: sim

task2.1-2.2: target=task2.1-2.2
task2.1-2.2: entity=tb_adder
task2.1-2.2: sim

sim: elab $(target) $(entity)
	ncsim -message -gui worklib.verilog_snapshot:module

elab: compile $(target)
	ncelab -message -access w -neverwarn -snapshot verilog_snapshot worklib.$(entity):module

compile: libs
	ncvlog -message -work worklib -v $(target).v

libs: clean
	mkdir ./INCA_libs
	mkdir ./INCA_libs/worklib
clean:
	rm -rf core *.key *.log* *.out *.df *.dsn *.trn *.shm *.rpt .cov *.cmd* INCA_libs
.PHONY: libs clean
.IGNORE: libs