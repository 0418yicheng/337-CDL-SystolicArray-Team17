onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_tester/DUT/clk
add wave -noupdate /tb_tester/DUT/n_rst
add wave -noupdate /tb_tester/DUT/read
add wave -noupdate /tb_tester/DUT/start_inference
add wave -noupdate /tb_tester/DUT/write
add wave -noupdate /tb_tester/DUT/load_weights
add wave -noupdate /tb_tester/DUT/done
add wave -noupdate /tb_tester/DUT/addr_in
add wave -noupdate /tb_tester/DUT/controller_write
add wave -noupdate /tb_tester/DUT/activations
add wave -noupdate /tb_tester/DUT/buffer_occupancy
add wave -noupdate /tb_tester/DUT/load_input
add wave -noupdate /tb_tester/DUT/load_weight
add wave -noupdate /tb_tester/DUT/ready
add wave -noupdate /tb_tester/DUT/weights_loaded
add wave -noupdate /tb_tester/DUT/overrun
add wave -noupdate /tb_tester/DUT/controller_read
add wave -noupdate /tb_tester/DUT/array_in
add wave -noupdate /tb_tester/DUT/input_write
add wave -noupdate /tb_tester/DUT/weight_write
add wave -noupdate /tb_tester/DUT/output_read
add wave -noupdate /tb_tester/DUT/output_row
add wave -noupdate /tb_tester/DUT/weight_row
add wave -noupdate /tb_tester/DUT/input_row
add wave -noupdate /tb_tester/DUT/input_wdata
add wave -noupdate /tb_tester/DUT/weight_wdata
add wave -noupdate /tb_tester/DUT/input_rdata
add wave -noupdate /tb_tester/DUT/weight_rdata
add wave -noupdate /tb_tester/DUT/output_rdata
add wave -noupdate /tb_tester/DUT/input_read
add wave -noupdate /tb_tester/DUT/weight_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
