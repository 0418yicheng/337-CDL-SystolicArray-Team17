onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_pe/clk
add wave -noupdate /tb_pe/n_rst
add wave -noupdate /tb_pe/load_weight
add wave -noupdate /tb_pe/load_input
add wave -noupdate -radix binary /tb_pe/in_weight
add wave -noupdate -radix binary /tb_pe/in
add wave -noupdate -radix binary /tb_pe/input_sum
add wave -noupdate -radix binary /tb_pe/input_out
add wave -noupdate -radix binary /tb_pe/sum
add wave -noupdate /tb_pe/inf
add wave -noupdate /tb_pe/nan
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/s_prod
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/e_prod
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/m_prod
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/e_large
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/e_small
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/e_diff
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/m_large
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/m_small
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/m_sum
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/s_final
add wave -noupdate -expand -group Internal -radix binary /tb_pe/DUT/e_final
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18623 ps} 0}
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
WaveRestoreZoom {0 ps} {27935 ps}
