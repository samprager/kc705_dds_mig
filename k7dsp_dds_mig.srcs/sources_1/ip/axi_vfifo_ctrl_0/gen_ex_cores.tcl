
create_ip -name axi_bram_ctrl -version 4.0 -vendor xilinx.com -library ip -module_name bram_memory
set_property -dict [list CONFIG.DATA_WIDTH {256} CONFIG.MEM_DEPTH {1024} CONFIG.ID_WIDTH {1} CONFIG.SUPPORTS_NARROW_BURST {0} CONFIG.BMG_INSTANCE {INTERNAL}] [get_ips bram_memory]

set addr_coe [lindex [get_property name [get_files *addr.coe]] 0 ]
set mask_coe [lindex [get_property name [get_files *mask.coe]] 0 ]
set ctrl_coe [lindex [get_property name [get_files *ctrl.coe]] 0 ]
set data_coe [lindex [get_property name [get_files *data.coe]] 0 ]

create_ip -name axi_traffic_gen -version 2.0 -vendor xilinx.com -library ip -module_name atg_lite_agent
set_property -dict [list CONFIG.C_ATG_MODE {AXI4-Lite} CONFIG.C_ATG_SYSTEM_INIT_ADDR_MIF $addr_coe CONFIG.C_ATG_SYSTEM_INIT_MASK_MIF $mask_coe CONFIG.C_ATG_SYSTEM_INIT_CTRL_MIF $ctrl_coe CONFIG.C_ATG_SYSTEM_INIT_DATA_MIF $data_coe CONFIG.C_ATG_SYSINIT_MODES {System_Test} CONFIG.C_ATG_SYSTEM_TEST_MAX_CLKS {2147483647} CONFIG.C_ATG_SYSTEM_CMD_MAX_RETRY {256} CONFIG.C_ATG_MIF_DATA_DEPTH {256} CONFIG.C_ATG_SYSTEM_MAX_CHANNELS {1} CONFIG.C_ATG_SYSTEM_CH1_HIGH {0x00000FFF} CONFIG.C_ATG_SYSTEM_CH1_LOW {0x00000000}] [get_ips atg_lite_agent]

create_ip -name axi_traffic_gen -version 2.0 -vendor xilinx.com -library ip -module_name atg_stream_agent 
set_property -dict [list CONFIG.C_BASEADDR {0x00000000} CONFIG.C_HIGHADDR {0x00000FFF} CONFIG.C_ATG_MODE {AXI4-Stream} CONFIG.C_AXIS_TUSER_WIDTH {1} CONFIG.C_AXIS_TID_WIDTH {1} CONFIG.C_AXIS_TDEST_WIDTH {1} CONFIG.C_AXIS_TDATA_WIDTH {256} CONFIG.C_AXIS_MODE {Master Loop back} CONFIG.C_AXIS_SPARSE_EN {false}] [get_ips atg_stream_agent]

set_property generate_synth_checkpoint false [get_files *.xci]
generate_target all [get_ips *]
