vlog fifo_pkg1.sv fifo_pkg2.sv fifo_pkg3.sv fifo_shared_pkg.sv
vlog fifo.sv fifo_tb.sv fifo_interface.sv fifo_top.sv fifo_monitor.sv  +cover +define +SIM
vsim -voptargs=+acc work.FIFO_top -cover
add wave *
coverage save FIFO.ucdb -onexit
run -all

quit -sim
vcover report FIFO.ucdb -all -details -annotate -output repFIFO.txt