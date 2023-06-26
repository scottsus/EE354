# up_down_counter_Fall2022Quiz_tb.do 

vlib work
vlog +acc  "up_down_counter_Fall2022Quiz.v" 
vlog +acc  "up_down_counter_Fall2022Quiz_tb.v" 
vsim -novopt -t 1ps -lib work up_down_counter_Fall2022Quiz_tb

view wave 
view structure
view signals
# add wave -r /*
do up_down_counter_Fall2022Quiz_tb_wave.do 
log -r *

run 420 ns

