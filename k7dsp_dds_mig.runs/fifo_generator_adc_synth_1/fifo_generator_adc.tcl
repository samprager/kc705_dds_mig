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

read_ip /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc.xci
set_property used_in_implementation false [get_files /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc.dcp]
set_property used_in_implementation false [get_files -all /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc.dcp]
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property is_locked true [get_files /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc.xci]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.cache/wt [current_project]
set_property parent.project_dir /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig [current_project]
catch { write_hwdef -file fifo_generator_adc.hwdef }
synth_design -top fifo_generator_adc -part xc7k325tffg900-2 -mode out_of_context

rename_ref -prefix_all fifo_generator_adc_
write_checkpoint -noxdef fifo_generator_adc.dcp
report_utilization -file fifo_generator_adc_utilization_synth.rpt -pb fifo_generator_adc_utilization_synth.pb
if { [catch {
  file copy -force /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.runs/fifo_generator_adc_synth_1/fifo_generator_adc.dcp /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc.dcp
  write_verilog -force -mode synth_stub /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc_stub.v
  write_vhdl -force -mode synth_stub /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc_stub.vhdl
  write_verilog -force -mode funcsim /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc_funcsim.v
  write_vhdl -force -mode funcsim /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/fifo_generator_adc/fifo_generator_adc_funcsim.vhdl
} _RESULT ] } { 
  send_msg_id runtcl-3 error "Unable to successfully create or copy supporting IP files."
  return -code error
}
