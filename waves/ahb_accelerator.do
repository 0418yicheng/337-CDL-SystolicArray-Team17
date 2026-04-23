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
add wave -noupdate /tb_ahb_accelerator/DUT/ahb_sub/inference_done
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
add wave -noupdate /tb_ahb_accelerator/DUT/db/output_sel
add wave -noupdate /tb_ahb_accelerator/DUT/db/output_row_write
add wave -noupdate /tb_ahb_accelerator/DUT/sa/outputs
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/bias
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/a
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/b
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/ea
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/eb
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/re
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/ma
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/mb
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/rm
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/sa
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/sb
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/rs
add wave -noupdate -expand -group Bias /tb_ahb_accelerator/DUT/ba/biased_outputs
add wave -noupdate /tb_ahb_accelerator/DUT/act/activation_outputs
add wave -noupdate /tb_ahb_accelerator/DUT/sa/done
add wave -noupdate /tb_ahb_accelerator/DUT/db/activations_latch0
add wave -noupdate /tb_ahb_accelerator/DUT/db/start_output0
add wave -noupdate /tb_ahb_accelerator/DUT/db/read_write_output0
add wave -noupdate /tb_ahb_accelerator/DUT/db/output0_done
add wave -noupdate /tb_ahb_accelerator/DUT/db/activations
add wave -noupdate /tb_ahb_accelerator/DUT/db/activations_latch1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4609957 ps} 0}
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
WaveRestoreZoom {4246843 ps} {4280982 ps}
