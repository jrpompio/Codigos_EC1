all: plan1 # escoger opción default

# Esta regla copila el programa, crea los vcd y ejecuta en gtkwave

plan1: testbench.v tester.v # Archivos necesarios para correr esta orden.
		iverilog -o salida.vvp testbench.v tester.v 
		vvp salida.vvp 
		gtkwave ondas.gtkw

plan2: testbench.v tester2.v 
		iverilog -o salida.vvp testbench.v tester2.v && vvp salida.vvp && gtkwave ondas.gtkw

plan3: testbench.v tester3.v 
		iverilog -o salida.vvp testbench.v tester3.v && vvp salida.vvp && gtkwave ondas.gtkw

plan4: testbench.v tester4.v 
		iverilog -o salida.vvp testbench.v tester4.v && vvp salida.vvp && gtkwave ondas.gtkw

