proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  create_project -in_memory -part xc7k325tffg900-2
  set_property board_part xilinx.com:kc705:part0:1.0 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.cache/wt [current_project]
  set_property parent.project_dir d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example [current_project]
  add_files -quiet d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/synth_1/example_top.dcp
  add_files -quiet d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/vio_twm_ddrx_synth_1/vio_twm_ddrx.dcp
  set_property netlist_only true [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/vio_twm_ddrx_synth_1/vio_twm_ddrx.dcp]
  add_files -quiet d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/mig_7series_1_synth_1/mig_7series_1.dcp
  set_property netlist_only true [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/mig_7series_1_synth_1/mig_7series_1.dcp]
  add_files -quiet d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/ila_ddrx_axi_synth_1/ila_ddrx_axi.dcp
  set_property netlist_only true [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.runs/ila_ddrx_axi_synth_1/ila_ddrx_axi.dcp]
  read_xdc d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/constrs_1/imports/par/example_top.xdc
  set_property processing_order EARLY [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/constrs_1/imports/par/example_top.xdc]
  read_xdc -mode out_of_context -ref vio_twm_ddrx -cells inst d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx_ooc.xdc
  set_property processing_order EARLY [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx_ooc.xdc]
  read_xdc -ref vio_twm_ddrx -cells inst d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx.xdc
  set_property processing_order EARLY [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/vio_twm_ddrx/vio_twm_ddrx.xdc]
  read_xdc -mode out_of_context -ref mig_7series_1 d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/mig_7series_1/mig_7series_1/user_design/constraints/mig_7series_1_ooc.xdc
  set_property processing_order EARLY [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/mig_7series_1/mig_7series_1/user_design/constraints/mig_7series_1_ooc.xdc]
  read_xdc -ref mig_7series_1 d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/mig_7series_1/mig_7series_1/user_design/constraints/mig_7series_1.xdc
  set_property processing_order EARLY [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/mig_7series_1/mig_7series_1/user_design/constraints/mig_7series_1.xdc]
  read_xdc -mode out_of_context -ref ila_ddrx_axi d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/ila_ddrx_axi/ila_ddrx_axi_ooc.xdc
  set_property processing_order EARLY [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/ila_ddrx_axi/ila_ddrx_axi_ooc.xdc]
  read_xdc -ref ila_ddrx_axi d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/ila_ddrx_axi/constraints/ila.xdc
  set_property processing_order EARLY [get_files d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/ila_ddrx_axi/constraints/ila.xdc]
  link_design -top example_top -part xc7k325tffg900-2
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  catch {update_ip_catalog -quiet -current_ip_cache {d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.cache} }
  opt_design 
  write_checkpoint -force example_top_opt.dcp
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force example_top_placed.dcp
  catch { report_io -file example_top_io_placed.rpt }
  catch { report_clock_utilization -file example_top_clock_utilization_placed.rpt }
  catch { report_utilization -file example_top_utilization_placed.rpt -pb example_top_utilization_placed.pb }
  catch { report_control_sets -verbose -file example_top_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force example_top_routed.dcp
  catch { report_drc -file example_top_drc_routed.rpt -pb example_top_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -file example_top_timing_summary_routed.rpt -pb example_top_timing_summary_routed.pb }
  catch { report_power -file example_top_power_routed.rpt -pb example_top_power_summary_routed.pb }
  catch { report_route_status -file example_top_route_status.rpt -pb example_top_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

