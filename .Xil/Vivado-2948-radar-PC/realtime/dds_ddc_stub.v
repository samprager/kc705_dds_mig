// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dds_compiler_v6_0,Vivado 2014.2" *)
module dds_ddc(aclk, aresetn, m_axis_data_tvalid, m_axis_data_tdata, event_pinc_invalid, event_poff_invalid);
  input aclk;
  input aresetn;
  output m_axis_data_tvalid;
  output [47:0]m_axis_data_tdata;
  output event_pinc_invalid;
  output event_poff_invalid;
endmodule
