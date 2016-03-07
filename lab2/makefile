list:
	@echo "tasks available: task2.1-2.2, task2.3-2.4, task2.5-2.6, task2.7-2.8, task2.9-2.10, task2.11-2.12, task2.13-2.15, task2.16, task2.17"

task2.17: target=task2.17.v task2.1-2.2.v task2.3-2.4.v
task2.17: entity=adder_subs
task2.17: elab

task2.16: target=task2.16.v task2.1-2.2.v task2.3-2.4.v
task2.16: entity=adder_subs
task2.16: elab

task2.13-2.15: target=task2.13-2.15.v task2.1-2.2.v task2.3-2.4.v task2.5-2.6.v task2.7-2.8.v task2.9-2.10.v task2.11-2.12.v
task2.13-2.15: entity=tb_alu
task2.13-2.15: sim

task2.11-2.12: target=task2.11-2.12.v
task2.11-2.12: entity=tb_nor
task2.11-2.12: sim

task2.9-2.10: target=task2.9-2.10.v
task2.9-2.10: entity=tb_nand
task2.9-2.10: sim

task2.7-2.8: target=task2.7-2.8.v
task2.7-2.8: entity=tb_mux
task2.7-2.8: sim

task2.5-2.6: target=task2.5-2.6.v task2.1-2.2.v
task2.5-2.6: entity=tb_multiplier
task2.5-2.6: sim

task2.3-2.4: target=task2.3-2.4.v
task2.3-2.4: entity=tb_substractor
task2.3-2.4: sim

task2.1-2.2: target=task2.1-2.2.v
task2.1-2.2: entity=tb_adder
task2.1-2.2: sim

sim: elab $(target) $(entity)
	ncsim -message -gui worklib.verilog_snapshot:module

elab: compile $(target)
	ncelab -message -access w -neverwarn -snapshot verilog_snapshot worklib.$(entity):module

compile: libs
	ncvlog -message -work worklib -v $(target)

libs: clean
	mkdir ./INCA_libs
	mkdir ./INCA_libs/worklib
clean:
	rm -rf core *.key *.log* *.out *.df *.dsn *.trn *.shm *.rpt .cov *.cmd* INCA_libs
.PHONY: libs clean
.IGNORE: libs
