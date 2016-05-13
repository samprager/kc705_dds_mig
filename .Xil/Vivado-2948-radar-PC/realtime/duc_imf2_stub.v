// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fir_compiler_v7_1,Vivado 2014.2" *)
module duc_imf2(aresetn, aclk, s_axis_data_tvalid, s_axis_data_tready, s_axis_data_tdata, m_axis_data_tvalid, m_axis_data_tdata);
  input aresetn;
  input aclk;
  input s_axis_data_tvalid;
  output s_axis_data_tready;
  input [47:0]s_axis_data_tdata;
  output m_axis_data_tvalid;
  output [47:0]m_axis_data_tdata;
endmodule
