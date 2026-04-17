onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_systolic_array/clk
add wave -noupdate /tb_systolic_array/n_rst
add wave -noupdate -expand -group Inputs /tb_systolic_array/load_inputs
add wave -noupdate -expand -group Inputs /tb_systolic_array/load_weights
add wave -noupdate -expand -group Inputs /tb_systolic_array/inputs
add wave -noupdate /tb_systolic_array/done
add wave -noupdate -expand -group Outputs /tb_systolic_array/nan
add wave -noupdate -expand -group Outputs /tb_systolic_array/inf
add wave -noupdate -expand -group Outputs /tb_systolic_array/outputs
add wave -noupdate -expand -group Outputs /tb_systolic_array/busy
add wave -noupdate -expand -group Internal /tb_systolic_array/DUT/load_weight_vector
add wave -noupdate -expand -group Internal /tb_systolic_array/DUT/input_mat
add wave -noupdate -expand -group Internal -expand /tb_systolic_array/DUT/output_mat
add wave -noupdate -expand -group Internal /tb_systolic_array/DUT/state
add wave -noupdate -expand -group Internal /tb_systolic_array/DUT/in_count
add wave -noupdate -expand -group Internal /tb_systolic_array/DUT/out_count
add wave -noupdate -expand /tb_systolic_array/DUT/int_inputs
add wave -noupdate -expand /tb_systolic_array/DUT/int_sums
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {321791 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 152
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
WaveRestoreZoom {0 ps} {31534 ps}
