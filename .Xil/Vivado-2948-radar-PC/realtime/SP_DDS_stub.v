// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dds_compiler_v6_0,Vivado 2014.2" *)
module SP_DDS(aclk, aclken, s_axis_phase_tvalid, s_axis_phase_tdata, m_axis_data_tvalid, m_axis_data_tdata);
  input aclk;
  input aclken;
  input s_axis_phase_tvalid;
  input [15:0]s_axis_phase_tdata;
  output m_axis_data_tvalid;
  output [31:0]m_axis_data_tdata;
endmodule
