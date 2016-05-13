// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
// Date        : Thu May 12 18:43:35 2016
// Host        : radar-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/dac3283_init_mem/dac3283_init_mem_stub.v
// Design      : dac3283_init_mem
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2014.2" *)
module dac3283_init_mem(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[4:0],douta[15:0]" */;
  input clka;
  input [4:0]addra;
  output [15:0]douta;
endmodule
