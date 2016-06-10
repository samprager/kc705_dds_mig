# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
  set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Labtools 27-147} -limit 4294967295
create_project -in_memory -part xc7k325tffg900-2
set_property target_language Verilog [current_project]
set_property board_part xilinx.com:kc705:part0:1.0 [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property default_lib xil_defaultlib [current_project]

read_ip D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m.xci
set_property used_in_implementation false [get_files d:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m.dcp]
set_property used_in_implementation false [get_files -all d:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m.dcp]
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property is_locked true [get_files D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m.xci]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.cache/wt [current_project]
set_property parent.project_dir D:/UndergroundRadar/kc705_dds_mig [current_project]
catch { write_hwdef -file axis_interconnect_1s2m.hwdef }
synth_design -top axis_interconnect_1s2m -part xc7k325tffg900-2 -mode out_of_context

rename_ref -prefix_all axis_interconnect_1s2m_
write_checkpoint -noxdef axis_interconnect_1s2m.dcp
report_utilization -file axis_interconnect_1s2m_utilization_synth.rpt -pb axis_interconnect_1s2m_utilization_synth.pb
if { [catch {
  file copy -force D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.runs/axis_interconnect_1s2m_synth_1/axis_interconnect_1s2m.dcp D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m.dcp
  write_verilog -force -mode synth_stub D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m_stub.v
  write_vhdl -force -mode synth_stub D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m_stub.vhdl
  write_verilog -force -mode funcsim D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m_funcsim.v
  write_vhdl -force -mode funcsim D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1s2m/axis_interconnect_1s2m_funcsim.vhdl
} _RESULT ] } { 
  send_msg_id runtcl-3 error "Unable to successfully create or copy supporting IP files."
  return -code error
}
