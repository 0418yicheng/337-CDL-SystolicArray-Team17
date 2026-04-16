onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_data_buffer/DUT/clk
add wave -noupdate /tb_data_buffer/DUT/n_rst
add wave -noupdate -group {signals for input srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/input_wdata
add wave -noupdate -group {signals for input srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/input_row
add wave -noupdate -group {signals for input srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/input_read
add wave -noupdate -group {signals for input srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/input_write
add wave -noupdate -group {signals for input srams} -expand -group output -color Cyan /tb_data_buffer/DUT/input_rdata
add wave -noupdate -group {signals for input srams} -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/start_input0
add wave -noupdate -group {signals for input srams} -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/start_input1
add wave -noupdate -group {signals for input srams} -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/addr_input0
add wave -noupdate -group {signals for input srams} -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/addr_input1
add wave -noupdate -group {signals for input srams} -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/input0_in
add wave -noupdate -group {signals for input srams} -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/input1_in
add wave -noupdate -group {signals for input srams} -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/input1_out
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/start_weight0
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/start_weight1
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/read_write_weight0
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/read_write_weight1
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/addr_weight0
add wave -noupdate -group {signals for weight srams} -color Pink /tb_data_buffer/DUT/weight_wdata
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/addr_weight1
add wave -noupdate -group {signals for weight srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/weight_row
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/weight0_in
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/weight1_in
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/weight0_out
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/weight1_out
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/weight0_done
add wave -noupdate -group {signals for weight srams} -color {Violet Red} /tb_data_buffer/DUT/weight1_done
add wave -noupdate -group {signals for weight srams} /tb_data_buffer/DUT/weight_read
add wave -noupdate -group {signals for output srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/done
add wave -noupdate -group {signals for output srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/output_row
add wave -noupdate -group {signals for output srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/activations
add wave -noupdate -group {signals for output srams} -expand -group inputs -color Pink /tb_data_buffer/DUT/output_read
add wave -noupdate -group {signals for output srams} -expand -group outputs -color Cyan /tb_data_buffer/DUT/output_rdata
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/start_output0
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/start_output1
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/addr_output0
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/addr_output1
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/output0_out
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/output1_out
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/output0_done
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/output1_done
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/output_sel
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/activations_latch0
add wave -noupdate -group {signals for output srams} -expand -group {internal signals} -color {Violet Red} /tb_data_buffer/DUT/activations_latch1
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/start_output0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/start_output1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/start_weight0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/start_weight1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/start_input0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/start_input1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_input0
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_input1
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_output0
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_output1
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_output0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_output1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_input0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_input1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_weight0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/read_write_weight1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/addr_output0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/addr_output1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/addr_weight0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/addr_weight1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/addr_input0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/addr_input1_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/input0_in_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/input1_in_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/weight0_in_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/weight1_in_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/input0_done
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/input1_done
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/done_buffered
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/done_buffered_2
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/done_buffered_3
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/output_row_write
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/output_row_write_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/output_sel_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/activations_latch0_next
add wave -noupdate -group {next state logic} /tb_data_buffer/DUT/activations_latch1_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {89644 ps} 0}
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
WaveRestoreZoom {0 ps} {189 ns}
