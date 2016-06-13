// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
// Date        : Mon Jun 13 12:48:00 2016
// Host        : radar-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               D:/UndergroundRadar/kc705_dds_mig/k7dsp_dds_mig.srcs/sources_1/ip/axis_interconnect_1m2s/axis_interconnect_1m2s_stub.v
// Design      : axis_interconnect_1m2s
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "axis_interconnect_v1_1_axis_interconnect_16x16_top,Vivado 2014.2" *)
module axis_interconnect_1m2s(ACLK, ARESETN, S00_AXIS_ACLK, S01_AXIS_ACLK, S00_AXIS_ARESETN, S01_AXIS_ARESETN, S00_AXIS_TVALID, S01_AXIS_TVALID, S00_AXIS_TREADY, S01_AXIS_TREADY, S00_AXIS_TDATA, S01_AXIS_TDATA, S00_AXIS_TSTRB, S01_AXIS_TSTRB, S00_AXIS_TKEEP, S01_AXIS_TKEEP, S00_AXIS_TLAST, S01_AXIS_TLAST, S00_AXIS_TID, S01_AXIS_TID, S00_AXIS_TDEST, S01_AXIS_TDEST, M00_AXIS_ACLK, M00_AXIS_ARESETN, M00_AXIS_TVALID, M00_AXIS_TREADY, M00_AXIS_TDATA, M00_AXIS_TSTRB, M00_AXIS_TKEEP, M00_AXIS_TLAST, M00_AXIS_TID, M00_AXIS_TDEST, S00_ARB_REQ_SUPPRESS, S01_ARB_REQ_SUPPRESS, S00_DECODE_ERR, S01_DECODE_ERR, S00_FIFO_DATA_COUNT, S01_FIFO_DATA_COUNT, M00_FIFO_DATA_COUNT)
/* synthesis syn_black_box black_box_pad_pin="ACLK,ARESETN,S00_AXIS_ACLK,S01_AXIS_ACLK,S00_AXIS_ARESETN,S01_AXIS_ARESETN,S00_AXIS_TVALID,S01_AXIS_TVALID,S00_AXIS_TREADY,S01_AXIS_TREADY,S00_AXIS_TDATA[63:0],S01_AXIS_TDATA[7:0],S00_AXIS_TSTRB[7:0],S01_AXIS_TSTRB[0:0],S00_AXIS_TKEEP[7:0],S01_AXIS_TKEEP[0:0],S00_AXIS_TLAST,S01_AXIS_TLAST,S00_AXIS_TID[0:0],S01_AXIS_TID[0:0],S00_AXIS_TDEST[0:0],S01_AXIS_TDEST[0:0],M00_AXIS_ACLK,M00_AXIS_ARESETN,M00_AXIS_TVALID,M00_AXIS_TREADY,M00_AXIS_TDATA[511:0],M00_AXIS_TSTRB[63:0],M00_AXIS_TKEEP[63:0],M00_AXIS_TLAST,M00_AXIS_TID[0:0],M00_AXIS_TDEST[0:0],S00_ARB_REQ_SUPPRESS,S01_ARB_REQ_SUPPRESS,S00_DECODE_ERR,S01_DECODE_ERR,S00_FIFO_DATA_COUNT[31:0],S01_FIFO_DATA_COUNT[31:0],M00_FIFO_DATA_COUNT[31:0]" */;
  input ACLK;
  input ARESETN;
  input S00_AXIS_ACLK;
  input S01_AXIS_ACLK;
  input S00_AXIS_ARESETN;
  input S01_AXIS_ARESETN;
  input S00_AXIS_TVALID;
  input S01_AXIS_TVALID;
  output S00_AXIS_TREADY;
  output S01_AXIS_TREADY;
  input [63:0]S00_AXIS_TDATA;
  input [7:0]S01_AXIS_TDATA;
  input [7:0]S00_AXIS_TSTRB;
  input [0:0]S01_AXIS_TSTRB;
  input [7:0]S00_AXIS_TKEEP;
  input [0:0]S01_AXIS_TKEEP;
  input S00_AXIS_TLAST;
  input S01_AXIS_TLAST;
  input [0:0]S00_AXIS_TID;
  input [0:0]S01_AXIS_TID;
  input [0:0]S00_AXIS_TDEST;
  input [0:0]S01_AXIS_TDEST;
  input M00_AXIS_ACLK;
  input M00_AXIS_ARESETN;
  output M00_AXIS_TVALID;
  input M00_AXIS_TREADY;
  output [511:0]M00_AXIS_TDATA;
  output [63:0]M00_AXIS_TSTRB;
  output [63:0]M00_AXIS_TKEEP;
  output M00_AXIS_TLAST;
  output [0:0]M00_AXIS_TID;
  output [0:0]M00_AXIS_TDEST;
  input S00_ARB_REQ_SUPPRESS;
  input S01_ARB_REQ_SUPPRESS;
  output S00_DECODE_ERR;
  output S01_DECODE_ERR;
  output [31:0]S00_FIFO_DATA_COUNT;
  output [31:0]S01_FIFO_DATA_COUNT;
  output [31:0]M00_FIFO_DATA_COUNT;
endmodule
