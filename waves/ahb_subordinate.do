onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ahb_subordinate/clk
add wave -noupdate /tb_ahb_subordinate/n_rst
add wave -noupdate /tb_ahb_subordinate/test_name
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/ready
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/inference_done
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/weights_loaded
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/crdata
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/cwdata
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/caddr
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/cwrite
add wave -noupdate -expand -group Controller /tb_ahb_subordinate/cread
add wave -noupdate -expand -group Errors /tb_ahb_subordinate/boe
add wave -noupdate -expand -group Errors /tb_ahb_subordinate/oe
add wave -noupdate -expand -group Errors /tb_ahb_subordinate/nan_flag
add wave -noupdate -expand -group Errors /tb_ahb_subordinate/inf_flag
add wave -noupdate -expand -group {Bias Adder} /tb_ahb_subordinate/bias
add wave -noupdate -expand -group Activation /tb_ahb_subordinate/activation_mode
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/hsel
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/htrans
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/haddr
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/hsize
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/hwrite
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/hwdata
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/hrdata
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/hready
add wave -noupdate -expand -group AHB /tb_ahb_subordinate/hresp
add wave -noupdate /tb_ahb_subordinate/current_transaction_num
add wave -noupdate /tb_ahb_subordinate/current_transaction_error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {430483 ps} 0}
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
WaveRestoreZoom {342362 ps} {527662 ps}
