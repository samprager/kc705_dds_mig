// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.2 (win64) Build 932637 Wed Jun 11 13:33:10 MDT 2014
// Date        : Thu Jun 02 19:35:38 2016
// Host        : radar-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               d:/UndergroundRadar/kc705_dds_mig/mig_7series_1_example/mig_7series_1_example.srcs/sources_1/ip/ila_ddrx_axi/ila_ddrx_axi_stub.v
// Design      : ila_ddrx_axi
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2014.2" *)
module ila_ddrx_axi(clk, trig_out, trig_out_ack, probe0, probe1, probe2, probe3, probe4, probe5, probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14, probe15, probe16, probe17, probe18, probe19, probe20, probe21, probe22, probe23, probe24, probe25, probe26, probe27, probe28, probe29, probe30, probe31, probe32, probe33, probe34, probe35, probe36, probe37, probe38, probe39, probe40, probe41, probe42, probe43, probe44, probe45, probe46, probe47, probe48, probe49, probe50, probe51, probe52, probe53, probe54, probe55, probe56, probe57, probe58, probe59, probe60, probe61, probe62, probe63, probe64, probe65, probe66, probe67, probe68, probe69, probe70, probe71, probe72, probe73, probe74, probe75, probe76, probe77, probe78, probe79, probe80, probe81, probe82, probe83, probe84, probe85, probe86, probe87, probe88, probe89, probe90, probe91, probe92, probe93, probe94)
/* synthesis syn_black_box black_box_pad_pin="clk,trig_out,trig_out_ack,probe0[0:0],probe1[0:0],probe2[0:0],probe3[0:0],probe4[0:0],probe5[0:0],probe6[0:0],probe7[0:0],probe8[0:0],probe9[0:0],probe10[1:0],probe11[1:0],probe12[1:0],probe13[0:0],probe14[0:0],probe15[0:0],probe16[0:0],probe17[0:0],probe18[5:0],probe19[0:0],probe20[63:0],probe21[0:0],probe22[0:0],probe23[0:0],probe24[0:0],probe25[0:0],probe26[31:0],probe27[31:0],probe28[4:0],probe29[3:0],probe30[0:0],probe31[0:0],probe32[5:0],probe33[2:0],probe34[5:0],probe35[0:0],probe36[0:0],probe37[5:0],probe38[5:0],probe39[4:0],probe40[5:0],probe41[0:0],probe42[0:0],probe43[3:0],probe44[4:0],probe45[4:0],probe46[0:0],probe47[0:0],probe48[3:0],probe49[53:0],probe50[26:0],probe51[11:0],probe52[11:0],probe53[11:0],probe54[5:0],probe55[3:0],probe56[7:0],probe57[7:0],probe58[7:0],probe59[7:0],probe60[7:0],probe61[7:0],probe62[7:0],probe63[7:0],probe64[0:0],probe65[0:0],probe66[5:0],probe67[5:0],probe68[5:0],probe69[4:0],probe70[11:0],probe71[11:0],probe72[5:0],probe73[5:0],probe74[5:0],probe75[107:0],probe76[107:0],probe77[107:0],probe78[89:0],probe79[254:0],probe80[0:0],probe81[0:0],probe82[5:0],probe83[5:0],probe84[7:0],probe85[7:0],probe86[7:0],probe87[7:0],probe88[7:0],probe89[7:0],probe90[7:0],probe91[7:0],probe92[0:0],probe93[0:0],probe94[0:0]" */;
  input clk;
  output trig_out;
  input trig_out_ack;
  input [0:0]probe0;
  input [0:0]probe1;
  input [0:0]probe2;
  input [0:0]probe3;
  input [0:0]probe4;
  input [0:0]probe5;
  input [0:0]probe6;
  input [0:0]probe7;
  input [0:0]probe8;
  input [0:0]probe9;
  input [1:0]probe10;
  input [1:0]probe11;
  input [1:0]probe12;
  input [0:0]probe13;
  input [0:0]probe14;
  input [0:0]probe15;
  input [0:0]probe16;
  input [0:0]probe17;
  input [5:0]probe18;
  input [0:0]probe19;
  input [63:0]probe20;
  input [0:0]probe21;
  input [0:0]probe22;
  input [0:0]probe23;
  input [0:0]probe24;
  input [0:0]probe25;
  input [31:0]probe26;
  input [31:0]probe27;
  input [4:0]probe28;
  input [3:0]probe29;
  input [0:0]probe30;
  input [0:0]probe31;
  input [5:0]probe32;
  input [2:0]probe33;
  input [5:0]probe34;
  input [0:0]probe35;
  input [0:0]probe36;
  input [5:0]probe37;
  input [5:0]probe38;
  input [4:0]probe39;
  input [5:0]probe40;
  input [0:0]probe41;
  input [0:0]probe42;
  input [3:0]probe43;
  input [4:0]probe44;
  input [4:0]probe45;
  input [0:0]probe46;
  input [0:0]probe47;
  input [3:0]probe48;
  input [53:0]probe49;
  input [26:0]probe50;
  input [11:0]probe51;
  input [11:0]probe52;
  input [11:0]probe53;
  input [5:0]probe54;
  input [3:0]probe55;
  input [7:0]probe56;
  input [7:0]probe57;
  input [7:0]probe58;
  input [7:0]probe59;
  input [7:0]probe60;
  input [7:0]probe61;
  input [7:0]probe62;
  input [7:0]probe63;
  input [0:0]probe64;
  input [0:0]probe65;
  input [5:0]probe66;
  input [5:0]probe67;
  input [5:0]probe68;
  input [4:0]probe69;
  input [11:0]probe70;
  input [11:0]probe71;
  input [5:0]probe72;
  input [5:0]probe73;
  input [5:0]probe74;
  input [107:0]probe75;
  input [107:0]probe76;
  input [107:0]probe77;
  input [89:0]probe78;
  input [254:0]probe79;
  input [0:0]probe80;
  input [0:0]probe81;
  input [5:0]probe82;
  input [5:0]probe83;
  input [7:0]probe84;
  input [7:0]probe85;
  input [7:0]probe86;
  input [7:0]probe87;
  input [7:0]probe88;
  input [7:0]probe89;
  input [7:0]probe90;
  input [7:0]probe91;
  input [0:0]probe92;
  input [0:0]probe93;
  input [0:0]probe94;
endmodule
