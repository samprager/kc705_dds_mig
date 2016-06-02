// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
// Date        : Fri Jan 15 12:32:21 2016
// Host        : SP-W7X64-VM running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub {c:/Users/Sam/Vivado
//               Projects/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v}
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_in1_p, clk_in1_n, clk_out1_ce, clk_out1, clk_out2_ce, clk_out2, reset, locked)
/* synthesis syn_black_box black_box_pad_pin="clk_in1_p,clk_in1_n,clk_out1_ce,clk_out1,clk_out2_ce,clk_out2,reset,locked" */;
  input clk_in1_p;
  input clk_in1_n;
  input clk_out1_ce;
  output clk_out1;
  input clk_out2_ce;
  output clk_out2;
  input reset;
  output locked;
endmodule
