// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
// Date        : Thu Mar 03 18:07:53 2016
// Host        : radar-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               D:/Prager/KC705_DDS/Mixed/k7dsp_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2014.2" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, probe6, probe7, probe8, probe9, probe10)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[63:0],probe1[15:0],probe2[15:0],probe3[15:0],probe4[15:0],probe5[0:0],probe6[0:0],probe7[9:0],probe8[0:0],probe9[0:0],probe10[0:0]" */;
  input clk;
  input [63:0]probe0;
  input [15:0]probe1;
  input [15:0]probe2;
  input [15:0]probe3;
  input [15:0]probe4;
  input [0:0]probe5;
  input [0:0]probe6;
  input [9:0]probe7;
  input [0:0]probe8;
  input [0:0]probe9;
  input [0:0]probe10;
endmodule
