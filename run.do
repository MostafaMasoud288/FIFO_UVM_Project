vlib work
vlog -f src_files.txt +cover -covercells 
vsim -voptargs=+acc work.FIFO_top -cover
add wave -position insertpoint sim:/FIFO_top/FIFO_if/*
coverage save FIFO_top.ucdb -onexit 
run -all
//quit -sim
//vcover report FIFO_top.ucdb -details -all -output coverage_rpt.txt
