// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cmpy_v6_0,Vivado 2014.2" *)
module complex_multiplier_DUC(aclk, s_axis_a_tvalid, s_axis_a_tready, s_axis_a_tdata, s_axis_b_tvalid, s_axis_b_tready, s_axis_b_tdata, m_axis_dout_tvalid, m_axis_dout_tready, m_axis_dout_tdata);
  input aclk;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [47:0]s_axis_a_tdata;
  input s_axis_b_tvalid;
  output s_axis_b_tready;
  input [47:0]s_axis_b_tdata;
  output m_axis_dout_tvalid;
  input m_axis_dout_tready;
  output [47:0]m_axis_dout_tdata;
endmodule
