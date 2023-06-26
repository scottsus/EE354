# ee254_gcd_tb_Part1.do 
vlib work                                           
vlog +acc  "ee354_GCD.v"                        # compile this file
vlog +acc  "ee354_GCD_tb_part1.v"               # compile using this testbench
vsim -t 1ps -lib work ee354_GCD_CEN_tb_v        # simulate testbench using this timescale and module name
view objects                                    # objects window
view wave                                       # show the waveforms window
do {wave.do}                                    # also execute this .do file
log -r *                                        # log the value of all the vars; they won't be shown on the waveform but saved in the backend
run 300ns                                       # run for 300ns