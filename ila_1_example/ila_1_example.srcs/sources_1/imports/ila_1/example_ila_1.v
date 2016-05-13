// file: ila_1.v
//////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version : 4.0
//  \   \         Application : ILA V4.0
//  /   /         Filename : example_ila_1.v
// /___/   /\     
// \   \  /  \ 
//  \___\/\___\
//
// (c) Copyright 2010 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

`timescale 1ns / 1ps

//The example module here illustrates how ila core can be instantiated in
//a user design. This helps the user on how various ports selected for the core can be used.

module example_ila_1
  (
    input         clk_p,clk_n);
  //****************************************************************************
  //  Local Parameters
  //****************************************************************************
  
  parameter C_NUM_OF_TRIGPORTS = 16;
  parameter C_TRIG0_SIZE = 512;
  parameter C_TRIG1_SIZE = 512;
  parameter C_TRIG2_SIZE = 64;
  parameter C_TRIG3_SIZE = 30;
  parameter C_TRIG4_SIZE = 4;
  parameter C_TRIG5_SIZE = 2;
  parameter C_TRIG6_SIZE = 1;
  parameter C_TRIG7_SIZE = 1;
  parameter C_TRIG8_SIZE = 512;
  parameter C_TRIG9_SIZE = 30;
  parameter C_TRIG10_SIZE = 4;
  parameter C_TRIG11_SIZE = 2;
  parameter C_TRIG12_SIZE = 1;
  parameter C_TRIG13_SIZE = 1;
  parameter C_TRIG14_SIZE = 1;
  parameter C_TRIG15_SIZE = 1;
 

  
  
  //****************************************************************************
  //  Local Signals
  //****************************************************************************
  wire clk;
  wire clk_bufg;
  wire [35:0] control0;
  wire [C_TRIG0_SIZE-1:0] trig_0; 
  wire [C_TRIG1_SIZE-1:0] trig_1; 
  wire [C_TRIG2_SIZE-1:0] trig_2; 
  wire [C_TRIG3_SIZE-1:0] trig_3; 
  wire [C_TRIG4_SIZE-1:0] trig_4; 
  wire [C_TRIG5_SIZE-1:0] trig_5; 
  wire [C_TRIG6_SIZE-1:0] trig_6; 
  wire [C_TRIG7_SIZE-1:0] trig_7; 
  wire [C_TRIG8_SIZE-1:0] trig_8; 
  wire [C_TRIG9_SIZE-1:0] trig_9; 
  wire [C_TRIG10_SIZE-1:0] trig_10; 
  wire [C_TRIG11_SIZE-1:0] trig_11; 
  wire [C_TRIG12_SIZE-1:0] trig_12; 
  wire [C_TRIG13_SIZE-1:0] trig_13; 
  wire [C_TRIG14_SIZE-1:0] trig_14; 
  wire [C_TRIG15_SIZE-1:0] trig_15; 
 
  wire [C_NUM_OF_TRIGPORTS:0] en_out_int;
  
  
  IBUFDS bufds_inst
    (
      .O(clk_bufg),
      .I(clk_p),
      .IB(clk_n));
  BUFG bufg_inst
    (
      .O(clk),
      .I(clk_bufg));



  //-----------------------------------------------------------------
  //  For TRIG0
  //-----------------------------------------------------------------
  // This shift register takes enable_in and registers enable_out. Size of 
  // shift register is given as TRIG0 width. Output of shift register 
  // is mapped to TRIG0.en_out of this shift_reg instance can be used as
  // en_in for next shift_reg instance. 

  // Enabling First shift register

  assign en_out_int[0] = 1'b1;

  shift_reg
    #(.WIDTH(C_TRIG0_SIZE))
    U_SHIFT_REGISTER_0
      (
       .clk(clk),
       .en_in(en_out_int[0]),
       .en_out(en_out_int[1]),
       .shiftout(trig_0));

  

  //-----------------------------------------------------------------
  //  For TRIG1
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG1 width.
  // Output of shift register is mapped TRIG1. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG0 signals 
  // are of shorter width than those of TRIG1.

  shift_reg
    #(.WIDTH(C_TRIG1_SIZE))
    U_SHIFT_REGISTER_1
      (
       .clk(clk),
       .en_in(en_out_int[1]),
       .en_out(en_out_int[2]),
       .shiftout(trig_1));


  //-----------------------------------------------------------------
  //  For TRIG2
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG2 width.
  // Output of shift register is mapped TRIG2. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG1 signals 
  // are of shorter width than those of TRIG2.

  shift_reg
    #(.WIDTH(C_TRIG2_SIZE))
    U_SHIFT_REGISTER_2
      (
       .clk(clk),
       .en_in(en_out_int[2]),
       .en_out(en_out_int[3]),
       .shiftout(trig_2));


  //-----------------------------------------------------------------
  //  For TRIG3
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG3 width.
  // Output of shift register is mapped TRIG3. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG2 signals 
  // are of shorter width than those of TRIG3.

  shift_reg
    #(.WIDTH(C_TRIG3_SIZE))
    U_SHIFT_REGISTER_3
      (
       .clk(clk),
       .en_in(en_out_int[3]),
       .en_out(en_out_int[4]),
       .shiftout(trig_3));


  //-----------------------------------------------------------------
  //  For TRIG4
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG4 width.
  // Output of shift register is mapped TRIG4. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG3 signals 
  // are of shorter width than those of TRIG4.

  shift_reg
    #(.WIDTH(C_TRIG4_SIZE))
    U_SHIFT_REGISTER_4
      (
       .clk(clk),
       .en_in(en_out_int[4]),
       .en_out(en_out_int[5]),
       .shiftout(trig_4));


  //-----------------------------------------------------------------
  //  For TRIG5
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG5 width.
  // Output of shift register is mapped TRIG5. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG4 signals 
  // are of shorter width than those of TRIG5.

  shift_reg
    #(.WIDTH(C_TRIG5_SIZE))
    U_SHIFT_REGISTER_5
      (
       .clk(clk),
       .en_in(en_out_int[5]),
       .en_out(en_out_int[6]),
       .shiftout(trig_5));


  //-----------------------------------------------------------------
  //  For TRIG6
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG6 width.
  // Output of shift register is mapped TRIG6. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG5 signals 
  // are of shorter width than those of TRIG6.

  shift_reg
    #(.WIDTH(C_TRIG6_SIZE))
    U_SHIFT_REGISTER_6
      (
       .clk(clk),
       .en_in(en_out_int[6]),
       .en_out(en_out_int[7]),
       .shiftout(trig_6));


  //-----------------------------------------------------------------
  //  For TRIG7
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG7 width.
  // Output of shift register is mapped TRIG7. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG6 signals 
  // are of shorter width than those of TRIG7.

  shift_reg
    #(.WIDTH(C_TRIG7_SIZE))
    U_SHIFT_REGISTER_7
      (
       .clk(clk),
       .en_in(en_out_int[7]),
       .en_out(en_out_int[8]),
       .shiftout(trig_7));


  //-----------------------------------------------------------------
  //  For TRIG8
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG8 width.
  // Output of shift register is mapped TRIG8. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG7 signals 
  // are of shorter width than those of TRIG8.

  shift_reg
    #(.WIDTH(C_TRIG8_SIZE))
    U_SHIFT_REGISTER_8
      (
       .clk(clk),
       .en_in(en_out_int[8]),
       .en_out(en_out_int[9]),
       .shiftout(trig_8));


  //-----------------------------------------------------------------
  //  For TRIG9
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG9 width.
  // Output of shift register is mapped TRIG9. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG8 signals 
  // are of shorter width than those of TRIG9.

  shift_reg
    #(.WIDTH(C_TRIG9_SIZE))
    U_SHIFT_REGISTER_9
      (
       .clk(clk),
       .en_in(en_out_int[9]),
       .en_out(en_out_int[10]),
       .shiftout(trig_9));


  //-----------------------------------------------------------------
  //  For TRIG10
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG10 width.
  // Output of shift register is mapped TRIG10. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG9 signals 
  // are of shorter width than those of TRIG10.

  shift_reg
    #(.WIDTH(C_TRIG10_SIZE))
    U_SHIFT_REGISTER_10
      (
       .clk(clk),
       .en_in(en_out_int[10]),
       .en_out(en_out_int[11]),
       .shiftout(trig_10));


  //-----------------------------------------------------------------
  //  For TRIG11
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG11 width.
  // Output of shift register is mapped TRIG11. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG10 signals 
  // are of shorter width than those of TRIG11.

  shift_reg
    #(.WIDTH(C_TRIG11_SIZE))
    U_SHIFT_REGISTER_11
      (
       .clk(clk),
       .en_in(en_out_int[11]),
       .en_out(en_out_int[12]),
       .shiftout(trig_11));


  //-----------------------------------------------------------------
  //  For TRIG12
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG12 width.
  // Output of shift register is mapped TRIG12. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG11 signals 
  // are of shorter width than those of TRIG12.

  shift_reg
    #(.WIDTH(C_TRIG12_SIZE))
    U_SHIFT_REGISTER_12
      (
       .clk(clk),
       .en_in(en_out_int[12]),
       .en_out(en_out_int[13]),
       .shiftout(trig_12));


  //-----------------------------------------------------------------
  //  For TRIG13
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG13 width.
  // Output of shift register is mapped TRIG13. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG12 signals 
  // are of shorter width than those of TRIG13.

  shift_reg
    #(.WIDTH(C_TRIG13_SIZE))
    U_SHIFT_REGISTER_13
      (
       .clk(clk),
       .en_in(en_out_int[13]),
       .en_out(en_out_int[14]),
       .shiftout(trig_13));


  //-----------------------------------------------------------------
  //  For TRIG14
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG14 width.
  // Output of shift register is mapped TRIG14. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG13 signals 
  // are of shorter width than those of TRIG14.

  shift_reg
    #(.WIDTH(C_TRIG14_SIZE))
    U_SHIFT_REGISTER_14
      (
       .clk(clk),
       .en_in(en_out_int[14]),
       .en_out(en_out_int[15]),
       .shiftout(trig_14));


  //-----------------------------------------------------------------
  //  For TRIG15
  //-----------------------------------------------------------------
  // This shift register takes enable_in from the previous shift register and 
  // registers enable_out.Size of shift register is given as TRIG15 width.
  // Output of shift register is mapped TRIG15. en_out of this shift_reg 
  // instance can be used as en_in for next shift_reg instance.Each trigger port 
  // in the design can be distinguished by its pulse width.TRIG14 signals 
  // are of shorter width than those of TRIG15.

  shift_reg
    #(.WIDTH(C_TRIG15_SIZE))
    U_SHIFT_REGISTER_15
      (
       .clk(clk),
       .en_in(en_out_int[15]),
       .en_out(en_out_int[16]),
       .shiftout(trig_15));



  //-----------------------------------------------------------------
  //  ILA core instance
  //-----------------------------------------------------------------
  // When this design is run on analyzer, shift operation is observed on each trigger port.
  // The pulse width is different for any two trigger ports. If Data port is selected, 
  // Johnson Counter operation can be observed on Data port. If Trig_out port is selected,
  // shift operation can be viewed on VIO core. 

ila_1 ILA_inst (
  .clk(clk), // input clk
  .probe0(trig_0), // input [511 : 0] PROBE0
  .probe1(trig_1), // input [511 : 0] PROBE1
  .probe2(trig_2), // input [63 : 0] PROBE2
  .probe3(trig_3), // input [29 : 0] PROBE3
  .probe4(trig_4), // input [3 : 0] PROBE4
  .probe5(trig_5), // input [1 : 0] PROBE5
  .probe6(trig_6), // input [0 : 0] PROBE6
  .probe7(trig_7), // input [0 : 0] PROBE7
  .probe8(trig_8), // input [511 : 0] PROBE8
  .probe9(trig_9), // input [29 : 0] PROBE9
  .probe10(trig_10), // input [3 : 0] PROBE10
  .probe11(trig_11), // input [1 : 0] PROBE11
  .probe12(trig_12), // input [0 : 0] PROBE12
  .probe13(trig_13), // input [0 : 0] PROBE13
  .probe14(trig_14), // input [0 : 0] PROBE14
.probe15(trig_15)
);

endmodule

//-------------------------------------------------------------------
//  Shift Register module
//-------------------------------------------------------------------
// Shift register module is a ring counter logic along with en_in and en_out. 
// This logic generates walking one pattern of given width when en_in is '1'. 
// en_out is MSB of the shiftout. Width of shift register is parameterized 
// and default width is specified as '8'. If the width is '1', toggle pattern is generated.
(* DONT_TOUCH = "true" *)
module shift_reg
 #(parameter WIDTH = 8) 
  (
    input clk,
    input en_in,
    (* dont_touch = "true" *)output en_out,
    output [WIDTH-1:0] shiftout);

  reg [WIDTH-1:0] val;
  initial
  val = 'b1;
  (* dont_touch = "true" *)reg en_out_reg;
  

  assign shiftout = val;
  
  // One shot enable
  assign en_out = (val[WIDTH-1] && !(en_out_reg));

  // Ring Counter logic
  generate
    if (WIDTH > 1)
      begin : if_name
        always@(posedge clk) begin
    	  if (en_in == 1'b1) begin
      	    val <= {val[WIDTH-2:0],val[WIDTH-1]};
    	  end
  	end
      end
    else
      begin : else_name
        always@(posedge clk) begin
          if (en_in == 1'b1) begin
            val <= !val;
          end
        end
      end
  endgenerate
 
  // Registering enable out
  always@(posedge clk) begin
    en_out_reg <= val[WIDTH-1];
  end

endmodule
