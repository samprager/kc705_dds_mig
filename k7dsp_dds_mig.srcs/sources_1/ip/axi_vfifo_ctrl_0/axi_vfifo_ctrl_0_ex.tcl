#-------------------------------------------------------------
# Generated Example Tcl script for IP 'axi_vfifo_ctrl_0' (xilinx.com:ip:axi_vfifo_ctrl:2.0)
#-------------------------------------------------------------

# Declare source IP directory
set srcIpDir "/media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axi_vfifo_ctrl_0"

# Create project
create_project -name axi_vfifo_ctrl_0_example -force
set_property part xc7k325tffg900-2 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language MIXED [current_project]
set_property board_part xilinx.com:kc705:part0:1.0 [current_project]
set returnCode 0

# Import the original IP (excluding example files)
import_ip -files [list [file join $srcIpDir axi_vfifo_ctrl_0.xci]] -name axi_vfifo_ctrl_0
reset_target {example} [get_ips axi_vfifo_ctrl_0]

# Generate the IP
proc _filter_supported_targets {targets ip} {
  set res {}
  set all [get_property SUPPORTED_TARGETS $ip]
  foreach target $targets {
    lappend res {*}[lsearch -all -inline -nocase $all $target]
  }
  return $res
}
generate_target [_filter_supported_targets {instantiation_template synthesis simulation} [get_ips axi_vfifo_ctrl_0]] [get_ips axi_vfifo_ctrl_0]

# Add example synthesis HDL files
add_files -scan_for_includes -fileset [current_fileset] \
  [list [file join $srcIpDir axi_vfifo_ctrl_0/example_design/axi_vfifo_ctrl_0_exdes.vhd]]

# Add example miscellaneous synthesis files
add_files -fileset [current_fileset] \
  [list [file join $srcIpDir addr.coe]] \
  [list [file join $srcIpDir data.coe]] \
  [list [file join $srcIpDir mask.coe]] \
  [list [file join $srcIpDir ctrl.coe]]

# Add example XDC files
add_files -fileset [current_fileset -constrset] \
  [list [file join $srcIpDir axi_vfifo_ctrl_0/example_design/axi_vfifo_ctrl_0_exdes.xdc]]


# Add example simulation HDL files
if { [catch {current_fileset -simset} exc] } { create_fileset -simset sim_1 }
add_files -scan_for_includes -fileset [current_fileset -simset] \
  [list [file join $srcIpDir axi_vfifo_ctrl_0/simulation/axi_vfifo_ctrl_0_tb.vhd]]
set_property USED_IN_SYNTHESIS false [get_files [file join $srcIpDir axi_vfifo_ctrl_0/simulation/axi_vfifo_ctrl_0_tb.vhd]]

# Import all files while preserving hierarchy
import_files

# Set top
set_property TOP [lindex [find_top] 0] [current_fileset]

# Source script extension file(s)
if {[catch {source [file join $srcIpDir gen_ex_cores.tcl]} errMsg]} {
  puts "Error encountered while sourcing custom IP example design script."
  puts "$errorInfo"
  incr returnCode
}

# Update compile order
update_compile_order -fileset [current_fileset]
update_compile_order -fileset [current_fileset -simset]

set dfile /media/sf_VMLinux/Projects/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axi_vfifo_ctrl_0/oepdone.txt
set doneFile [open $dfile w]
puts $doneFile "Open Example Project DONE"
close $doneFile
if { $returnCode != 0 } {
  error "Problems were encountered while executing the example design script, please review the log files."
}
