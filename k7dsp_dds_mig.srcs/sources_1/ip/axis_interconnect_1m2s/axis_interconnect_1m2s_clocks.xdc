# Set max delays between S01_AXIS_ACLK and ACLK for async clock cross across fifo_generator instance
set clock_axis_aclk [get_clocks -of_objects [get_ports S01_AXIS_ACLK]]
set clock_aclk          [get_clocks -of_objects [get_ports ACLK]]
set_max_delay -from [filter [all_registers -clock $clock_axis_aclk] {REF_NAME !~ RAMB*}] -to [filter [all_registers -clock $clock_aclk] {REF_NAME !~ RAMB*}] -datapath_only [get_property PERIOD $clock_axis_aclk]
set_max_delay -from [filter [all_registers -clock $clock_aclk] {REF_NAME !~ RAMB*}] -to [filter [all_registers -clock $clock_axis_aclk] {REF_NAME !~ RAMB*}] -datapath_only [get_property PERIOD $clock_aclk]
# Set false path on reset input to fifo_generator instance for async clock crossing case.
set_false_path -through [get_nets -hier -filter {NAME =~ *axis_interconnect_0/inst_si_datapath[1]*s_and_m_aresetn_i}]

