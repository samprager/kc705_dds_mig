// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v12_0,Vivado 2014.2" *)
module fifo_generator_adc(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, almost_full, wr_ack, empty, almost_empty, valid, rd_data_count, wr_data_count);
  input rst;
  input wr_clk;
  input rd_clk;
  input [63:0]din;
  input wr_en;
  input rd_en;
  output [511:0]dout;
  output full;
  output almost_full;
  output wr_ack;
  output empty;
  output almost_empty;
  output valid;
  output [6:0]rd_data_count;
  output [9:0]wr_data_count;
endmodule
