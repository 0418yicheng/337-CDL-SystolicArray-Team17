onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ahb_accelerator/clk
add wave -noupdate /tb_ahb_accelerator/n_rst
add wave -noupdate /tb_ahb_accelerator/test_name
add wave -noupdate -color Yellow /tb_ahb_accelerator/hsel
add wave -noupdate -color Yellow /tb_ahb_accelerator/haddr
add wave -noupdate -color Yellow /tb_ahb_accelerator/hsize
add wave -noupdate -color Yellow /tb_ahb_accelerator/hburst
add wave -noupdate -color Yellow /tb_ahb_accelerator/htrans
add wave -noupdate -color Yellow /tb_ahb_accelerator/hwdata
add wave -noupdate -color Yellow /tb_ahb_accelerator/hrdata
add wave -noupdate -color Yellow /tb_ahb_accelerator/hwrite
add wave -noupdate -color Yellow /tb_ahb_accelerator/hresp
add wave -noupdate -color Yellow /tb_ahb_accelerator/hready
add wave -noupdate /tb_ahb_accelerator/DUT/cont/ready
add wave -noupdate /tb_ahb_accelerator/DUT/ahb_sub/bias
add wave -noupdate /tb_ahb_accelerator/DUT/ahb_sub/activation_mode
add wave -noupdate /tb_ahb_accelerator/DUT/sa/inputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/outputs
add wave -noupdate /tb_ahb_accelerator/DUT/ba/biased_outputs
add wave -noupdate /tb_ahb_accelerator/DUT/act/activation_outputs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13221050 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 172
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
WaveRestoreZoom {12851379 ps} {12901332 ps}
bookmark add wave bookmark0 {{0 ps} {13702500 ps}} 0
