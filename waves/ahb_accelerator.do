onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ahb_accelerator/clk
add wave -noupdate /tb_ahb_accelerator/n_rst
add wave -noupdate /tb_ahb_accelerator/hsel
add wave -noupdate /tb_ahb_accelerator/haddr
add wave -noupdate /tb_ahb_accelerator/hsize
add wave -noupdate /tb_ahb_accelerator/hburst
add wave -noupdate /tb_ahb_accelerator/htrans
add wave -noupdate /tb_ahb_accelerator/hwrite
add wave -noupdate /tb_ahb_accelerator/hwdata
add wave -noupdate /tb_ahb_accelerator/hrdata
add wave -noupdate /tb_ahb_accelerator/hresp
add wave -noupdate /tb_ahb_accelerator/hready
add wave -noupdate /tb_ahb_accelerator/DUT/sa/load_inputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/load_weights
add wave -noupdate /tb_ahb_accelerator/DUT/sa/input_vector
add wave -noupdate /tb_ahb_accelerator/DUT/sa/outputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/state
add wave -noupdate -label William_state /tb_ahb_accelerator/DUT/cont/state
add wave -noupdate /tb_ahb_accelerator/DUT/cont/array_in
add wave -noupdate -expand /tb_ahb_accelerator/DUT/sa/input_mat
add wave -noupdate /tb_ahb_accelerator/DUT/sa/int_inputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/int_sums
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1655000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 282
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
WaveRestoreZoom {1554461 ps} {1571865 ps}
