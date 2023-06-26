onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/CLK_tb
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/S_RST_tb
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/EN_tb
add wave -noupdate -radix unsigned -radixshowbase 0 /up_down_counter_Fall2022Quiz_tb/M_tb
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/UP_tb
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/REPEATED_tb
add wave -noupdate -radix unsigned -radixshowbase 0 /up_down_counter_Fall2022Quiz_tb/CLK_cnt
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/UUT/CLK
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/UUT/EN
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/UUT/S_RST
add wave -noupdate -radix unsigned -radixshowbase 0 /up_down_counter_Fall2022Quiz_tb/UUT/M
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/UUT/UP
add wave -noupdate /up_down_counter_Fall2022Quiz_tb/UUT/REPEATED
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {220000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {429837 ps}
