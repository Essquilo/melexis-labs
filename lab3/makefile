list:
	@echo " task available: vending_machine, traffic_light, test_delay"

vending_machine: target=vending_machine.v
vending_machine: entity=tb_vending_machine
vending_machine: sim

traffic_light: target=traffic_light.v parametrized_delay.v
traffic_light: entity=tb_traffic_light
traffic_light: sim

test_delay: target=parametrized_delay.v
test_delay: entity=tb_delay
test_delay: sim

sim: elab $(target) $(entity)
	ncsim -message -gui worklib.verilog_snapshot:module

elab: compile $(target)
	ncelab -message -access w -neverwarn -snapshot verilog_snapshot worklib.$(entity):module

compile: libs
	ncvlog -message -work worklib -sv $(target)

libs: clean
	mkdir ./INCA_libs
	mkdir ./INCA_libs/worklib
clean:
	rm -rf core *.key *.log* *.out *.df *.dsn *.trn *.shm *.rpt .cov *.cmd* INCA_libs
.PHONY: libs clean
.IGNORE: libs
