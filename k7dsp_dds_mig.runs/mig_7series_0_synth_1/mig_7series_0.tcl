# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7k325tffg900-2
set_property target_language Verilog [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property default_lib xil_defaultlib [current_project]

read_ip D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0.xci
set_property used_in_implementation false [get_files d:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0.dcp]
set_property used_in_implementation false [get_files -all d:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0.dcp]
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property is_locked true [get_files D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0.xci]

set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.cache/wt [current_project]
set_property parent.project_dir D:/UndergroundRadar/kc705_dds_mig [current_project]
catch { write_hwdef -file mig_7series_0.hwdef }
synth_design -top mig_7series_0 -part xc7k325tffg900-2 -mode out_of_context

rename_ref -prefix_all mig_7series_0_
write_checkpoint -noxdef mig_7series_0.dcp
report_utilization -file mig_7series_0_utilization_synth.rpt -pb mig_7series_0_utilization_synth.pb
if { [catch {
  file copy -force D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.runs/mig_7series_0_synth_1/mig_7series_0.dcp D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0.dcp
  write_verilog -force -mode synth_stub D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0_stub.v
  write_vhdl -force -mode synth_stub D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0_stub.vhdl
  write_verilog -force -mode funcsim D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0_funcsim.v
  write_vhdl -force -mode funcsim D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/mig_7series_0/mig_7series_0_funcsim.vhdl
} _RESULT ] } { 
  send_msg_id runtcl-3 error "Unable to successfully create or copy supporting IP files."
  return -code error
}
