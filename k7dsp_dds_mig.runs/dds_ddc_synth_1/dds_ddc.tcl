# 
# Synthesis run script generated by Vivado
# 

  set_param gui.test TreeTableDev
  set_param project.hsv.suppressChildGraphs 0
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7k325tffg900-2
set_property target_language Verilog [current_project]
set_param project.compositeFile.enableAutoGeneration 0
set_property default_lib xil_defaultlib [current_project]

read_ip D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc.xci
set_property used_in_implementation false [get_files d:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc.dcp]
set_property used_in_implementation false [get_files -all d:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc.dcp]
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property is_locked true [get_files D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc.xci]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.cache/wt [current_project]
set_property parent.project_dir D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig [current_project]
catch { write_hwdef -file dds_ddc.hwdef }
synth_design -top dds_ddc -part xc7k325tffg900-2 -mode out_of_context

rename_ref -prefix_all dds_ddc_
write_checkpoint -noxdef dds_ddc.dcp
report_utilization -file dds_ddc_utilization_synth.rpt -pb dds_ddc_utilization_synth.pb
if { [catch {
  file copy -force D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.runs/dds_ddc_synth_1/dds_ddc.dcp D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc.dcp
  write_verilog -force -mode synth_stub D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc_stub.v
  write_vhdl -force -mode synth_stub D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc_stub.vhdl
  write_verilog -force -mode funcsim D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc_funcsim.v
  write_vhdl -force -mode funcsim D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dds_ddc/dds_ddc_funcsim.vhdl
} _RESULT ] } { 
  send_msg_id runtcl-3 error "Unable to successfully create or copy supporting IP files."
  return -code error
}
