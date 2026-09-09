SIM=iverilog
VVP=vvp
SRC=$(wildcard src/*.v)

basic:
	mkdir -p build
	$(SIM) -g2012 -s calculadora_4bits_tb_basico -o build/tb_basic $(SRC) tb/calculadora_4bits_tb_basico.sv
	$(VVP) build/tb_basic

full:
	mkdir -p build
	$(SIM) -g2012 -s calculadora_4bits_tb_completo -o build/tb_full $(SRC) tb/calculadora_4bits_tb_completo.sv
	$(VVP) build/tb_full

clean:
	rm -rf build/*.vvp build/tb_basic build/tb_full *.vcd tb/*.vcd
