onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_sram_bank/DUT/clk
add wave -noupdate /tb_sram_bank/DUT/n_rst
add wave -noupdate -expand -group inputs -color Coral /tb_sram_bank/DUT/read_write
add wave -noupdate -expand -group inputs -color Coral /tb_sram_bank/DUT/start
add wave -noupdate -expand -group inputs -color Coral /tb_sram_bank/DUT/address_in
add wave -noupdate -expand -group inputs -color Coral /tb_sram_bank/DUT/wdata_in
add wave -noupdate -expand -group outputs -color Pink /tb_sram_bank/DUT/rdata_out
add wave -noupdate -expand -group outputs -color Pink /tb_sram_bank/DUT/transaction_done
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/address
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/read_enable
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/write_enable
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/wdata0
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/wdata1
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/rdata0
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/rdata1
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/sram_state
add wave -noupdate -expand -group {internal signals} -color Aquamarine /tb_sram_bank/DUT/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {158612 ps} 0}
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
WaveRestoreZoom {0 ps} {210 ns}
