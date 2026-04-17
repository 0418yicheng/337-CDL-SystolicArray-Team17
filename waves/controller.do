onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_controller/DUT/clk
add wave -noupdate /tb_controller/DUT/n_rst
add wave -noupdate /tb_controller/DUT/state
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/read
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/start_inference
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/write
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/load_weights
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/addr_in
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/controller_write
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/input_rdata
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/weight_rdata
add wave -noupdate -expand -group inputs -color Pink /tb_controller/DUT/output_rdata
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/inference_done
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/input_write
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/weight_write
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/buffer_occupancy
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/load_input
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/load_weight
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/ready
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/weights_loaded
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/input_read
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/weight_read
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/output_read
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/overrun
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/output_row
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/weight_row
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/input_row
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/controller_read
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/input_wdata
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/array_in
add wave -noupdate -expand -group outputs -color Cyan /tb_controller/DUT/weight_wdata
add wave -noupdate -group {next state logic} /tb_controller/DUT/input_write_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/weight_write_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/input_read_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/weight_read_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/output_read_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/buffer_occupancy_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/load_input_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/load_weight_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/read_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/weights_loaded_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/overrun_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/ready_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/output_row_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/weight_row_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/input_row_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/controller_read_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/input_wdata_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/array_in_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/weight_wdata_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/input_count
add wave -noupdate -group {next state logic} /tb_controller/DUT/output_count
add wave -noupdate -group {next state logic} /tb_controller/DUT/output_count_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/input_count_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/counter_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/no_outputs_next
add wave -noupdate -group {next state logic} /tb_controller/DUT/next_state
add wave -noupdate /tb_controller/DUT/counter
add wave -noupdate /tb_controller/DUT/no_outputs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {511975 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1123500 ps}
