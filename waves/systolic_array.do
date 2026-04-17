onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_systolic_array/clk
add wave -noupdate /tb_systolic_array/n_rst
add wave -noupdate /tb_systolic_array/load_inputs
add wave -noupdate /tb_systolic_array/load_weights
add wave -noupdate /tb_systolic_array/inputs
add wave -noupdate /tb_systolic_array/nan
add wave -noupdate /tb_systolic_array/inf
add wave -noupdate /tb_systolic_array/outputs
add wave -noupdate /tb_systolic_array/busy
add wave -noupdate /tb_systolic_array/done
add wave -noupdate /tb_systolic_array/DUT/load_weights
add wave -noupdate -radix binary /tb_systolic_array/DUT/load_weight_vector
add wave -noupdate -expand /tb_systolic_array/DUT/weights
add wave -noupdate /tb_systolic_array/DUT/state
add wave -noupdate /tb_systolic_array/DUT/p_tl/load_weight
add wave -noupdate /tb_systolic_array/DUT/p_tl/in_weight
add wave -noupdate /tb_systolic_array/DUT/p_tl/n_weight
add wave -noupdate /tb_systolic_array/DUT/p_tl/weight
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45126 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 101
configure wave -valuecolwidth 306
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
WaveRestoreZoom {0 ps} {10910 ps}
