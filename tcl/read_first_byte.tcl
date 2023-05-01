#source E:/minized_renew/read_first_byte.tcl
#writing 
set_property OUTPUT_VALUE 01 [get_hw_probes s_axis_tdata -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tdata} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]

set_property OUTPUT_VALUE A6 [get_hw_probes s_axis_tdest -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tdest} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]

startgroup
set_property OUTPUT_VALUE 1 [get_hw_probes s_axis_tvalid -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tvalid} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup

startgroup
set_property OUTPUT_VALUE 0 [get_hw_probes s_axis_tvalid -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tvalid} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup

set_property OUTPUT_VALUE 00 [get_hw_probes s_axis_tdata -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tdata} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]

startgroup
set_property OUTPUT_VALUE 1 [get_hw_probes s_axis_tlast -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tlast} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup

startgroup
set_property OUTPUT_VALUE 1 [get_hw_probes s_axis_tvalid -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tvalid} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup
startgroup
set_property OUTPUT_VALUE 0 [get_hw_probes s_axis_tvalid -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tvalid} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup



# #reading 

startgroup
set_property OUTPUT_VALUE 0 [get_hw_probes s_axis_tlast -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tlast} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup


set_property OUTPUT_VALUE A7 [get_hw_probes s_axis_tdest -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tdest} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
set_property OUTPUT_VALUE 01 [get_hw_probes s_axis_tdata -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tdata} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]


startgroup
set_property OUTPUT_VALUE 1 [get_hw_probes s_axis_tlast -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tlast} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup

startgroup
set_property OUTPUT_VALUE 1 [get_hw_probes s_axis_tvalid -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tvalid} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup
startgroup
set_property OUTPUT_VALUE 0 [get_hw_probes s_axis_tvalid -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tvalid} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup

startgroup
set_property OUTPUT_VALUE 0 [get_hw_probes s_axis_tlast -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
commit_hw_vio [get_hw_probes {s_axis_tlast} -of_objects [get_hw_vios -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"vio_iic_ctrl_inst"}]]
endgroup
