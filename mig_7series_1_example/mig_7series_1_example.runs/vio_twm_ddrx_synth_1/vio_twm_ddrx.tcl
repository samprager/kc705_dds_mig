# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7k325tffg900-2
set_property target_language Verilog [current_project]
set_property board_part xilinx.com:kc705:part0:1.0 [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property default_lib xil_defaultlib [current_project]

read_ip d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx.xci
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property is_locked true [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx.xci]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.cache/wt [current_project]
set_property parent.project_dir d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example [current_project]
catch { write_hwdef -file vio_twm_ddrx.hwdef }
synth_design -top vio_twm_ddrx -part xc7k325tffg900-2 -mode out_of_context

rename_ref -prefix_all vio_twm_ddrx_
write_checkpoint -noxdef vio_twm_ddrx.dcp
report_utilization -file vio_twm_ddrx_utilization_synth.rpt -pb vio_twm_ddrx_utilization_synth.pb
if { [catch {
  file copy -force d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/vio_twm_ddrx_synth_1/vio_twm_ddrx.dcp d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx.dcp
  write_verilog -force -mode synth_stub d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx_stub.v
  write_vhdl -force -mode synth_stub d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx_stub.vhdl
  write_verilog -force -mode funcsim d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx_funcsim.v
  write_vhdl -force -mode funcsim d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx_funcsim.vhdl
} _RESULT ] } { 
  send_msg_id runtcl-3 error "Unable to successfully create or copy supporting IP files."
  return -code error
}
