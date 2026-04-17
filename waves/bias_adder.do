onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_bias_adder/clk
add wave -noupdate /tb_bias_adder/n_rst
add wave -noupdate /tb_bias_adder/outputs
add wave -noupdate /tb_bias_adder/bias
add wave -noupdate /tb_bias_adder/done
add wave -noupdate /tb_bias_adder/biased_outputs
add wave -noupdate /tb_bias_adder/bias_done
add wave -noupdate /tb_bias_adder/DUT/state
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {254 ps}
