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
add wave -noupdate -color Yellow /tb_ahb_accelerator/hwrite
add wave -noupdate -color Yellow /tb_ahb_accelerator/hwdata
add wave -noupdate -color Yellow /tb_ahb_accelerator/hrdata
add wave -noupdate -color Yellow /tb_ahb_accelerator/hresp
add wave -noupdate -color Yellow /tb_ahb_accelerator/hready
add wave -noupdate /tb_ahb_accelerator/DUT/ready
add wave -noupdate /tb_ahb_accelerator/DUT/caddr
add wave -noupdate /tb_ahb_accelerator/DUT/cwdata
add wave -noupdate /tb_ahb_accelerator/DUT/crdata
add wave -noupdate /tb_ahb_accelerator/DUT/cwrite
add wave -noupdate /tb_ahb_accelerator/DUT/cread
add wave -noupdate -radix decimal /tb_ahb_accelerator/BFM/num_transactions_left
add wave -noupdate /tb_ahb_accelerator/DUT/ready
add wave -noupdate /tb_ahb_accelerator/DUT/sa/outputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/done
add wave -noupdate /tb_ahb_accelerator/DUT/cont/array_in
add wave -noupdate /tb_ahb_accelerator/DUT/ahb_sub/start_inference
add wave -noupdate /tb_ahb_accelerator/DUT/cont/inference_started
add wave -noupdate /tb_ahb_accelerator/DUT/ahb_sub/load_weights
add wave -noupdate /tb_ahb_accelerator/DUT/ahb_sub/weights_loaded
add wave -noupdate /tb_ahb_accelerator/DUT/cont/state
add wave -noupdate /tb_ahb_accelerator/DUT/sa/state
add wave -noupdate /tb_ahb_accelerator/DUT/cont/load_weight
add wave -noupdate /tb_ahb_accelerator/DUT/cont/load_input
add wave -noupdate {/tb_ahb_accelerator/DUT/db/input0/sram0/memory[3]}
add wave -noupdate {/tb_ahb_accelerator/DUT/db/input0/sram0/memory[2]}
add wave -noupdate {/tb_ahb_accelerator/DUT/db/input0/sram0/memory[1]}
add wave -noupdate {/tb_ahb_accelerator/DUT/db/input0/sram0/memory[0]}
add wave -noupdate /tb_ahb_accelerator/DUT/cont/input_write
add wave -noupdate /tb_ahb_accelerator/DUT/cont/input_wdata
add wave -noupdate /tb_ahb_accelerator/DUT/db/input0/wdata_in
add wave -noupdate {/tb_ahb_accelerator/DUT/db/output0/sram0/memory[3]}
add wave -noupdate {/tb_ahb_accelerator/DUT/db/output0/sram0/memory[2]}
add wave -noupdate {/tb_ahb_accelerator/DUT/db/output0/sram0/memory[1]}
add wave -noupdate {/tb_ahb_accelerator/DUT/db/output0/sram0/memory[0]}
add wave -noupdate /tb_ahb_accelerator/DUT/sa/outputs
add wave -noupdate /tb_ahb_accelerator/DUT/ba/biased_outputs
add wave -noupdate /tb_ahb_accelerator/DUT/act/activation_outputs
add wave -noupdate -expand /tb_ahb_accelerator/DUT/sa/weights
add wave -noupdate /tb_ahb_accelerator/DUT/sa/inputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/load_inputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/load_weights
add wave -noupdate /tb_ahb_accelerator/DUT/sa/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {902739 ps} 0}
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
WaveRestoreZoom {0 ps} {3108 ns}
