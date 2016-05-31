//*****************************************************************************
// (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
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
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 2.1
//  \   \         Application        : MIG
//  /   /         Filename           : example_top.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//   Top-level  module. This module serves as an example,
//   and allows the user to synthesize a self-contained design,
//   which they can be used to test their hardware.
//   In addition to the memory controller, the module instantiates:
//     1. Synthesizable testbench - used to model user's backend logic
//        and generate different traffic patterns
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ps/1ps

module example_top #
  (

   //***************************************************************************
   // Traffic Gen related parameters
   //***************************************************************************
   parameter BEGIN_ADDRESS         = 32'h00000000,
   parameter END_ADDRESS           = 32'h00ffffff,

   parameter PRBS_EADDR_MASK_POS   = 32'hff000000,
   parameter ENFORCE_RD_WR         = 0,
   parameter ENFORCE_RD_WR_CMD     = 8'h11,
   parameter ENFORCE_RD_WR_PATTERN = 3'b000,
   parameter C_EN_WRAP_TRANS       = 0,
   parameter C_AXI_NBURST_TEST     = 0,

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter BANK_WIDTH            = 3,
                                     // # of memory Bank Address bits.
   parameter CK_WIDTH              = 1,
                                     // # of CK/CK# outputs to memory.
   parameter COL_WIDTH             = 10,
                                     // # of memory Column Address bits.
   parameter CS_WIDTH              = 1,
                                     // # of unique CS outputs to memory.
   parameter nCS_PER_RANK          = 1,
                                     // # of unique CS outputs per rank for phy
   parameter CKE_WIDTH             = 1,
                                     // # of CKE outputs to memory.
   parameter DM_WIDTH              = 8,
                                     // # of DM (data mask)
   parameter DQ_WIDTH              = 64,
                                     // # of DQ (data)
   parameter DQS_WIDTH             = 8,
   parameter DQS_CNT_WIDTH         = 3,
                                     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8,
                                     // # of DQ per DQS
   parameter ECC                   = "OFF",
   parameter ECC_TEST              = "OFF",
   parameter nBANK_MACHS           = 4,
   parameter RANKS                 = 1,
                                     // # of Ranks.
   parameter ODT_WIDTH             = 1,
                                     // # of ODT outputs to memory.
   parameter ROW_WIDTH             = 14,
                                     // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 28,
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices


   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************

   parameter BURST_MODE            = "8",
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8", "4", "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8", "4".

   //***************************************************************************
   // The following parameters are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these parameters vary.
   //***************************************************************************
   parameter CLKIN_PERIOD          = 5000,
//   parameter CLKIN_PERIOD          = 4069,
                                     // Input Clock Period
   parameter CLKFBOUT_MULT         = 4,
                                     // write PLL VCO multiplier
   parameter DIVCLK_DIVIDE         = 1,
                                     // write PLL VCO divisor
   parameter CLKOUT0_PHASE         = 337.5,
                                     // Phase for PLL output clock (CLKOUT0)
   parameter CLKOUT0_DIVIDE        = 2,
                                     // VCO output divisor for PLL output clock (CLKOUT0)
   parameter CLKOUT1_DIVIDE        = 2,
                                     // VCO output divisor for PLL output clock (CLKOUT1)
   parameter CLKOUT2_DIVIDE        = 32,
                                     // VCO output divisor for PLL output clock (CLKOUT2)
   parameter CLKOUT3_DIVIDE        = 8,
                                     // VCO output divisor for PLL output clock (CLKOUT3)


   //***************************************************************************
   // Simulation parameters
   //*********************************************************************

   parameter SIMULATION            = "FALSE",
                                     // Should be TRUE during design simulations and
                                     // FALSE during implementations

   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************

   parameter TCQ                   = 100,//   parameter IODELAY_GRP0

   parameter DRAM_TYPE             = "DDR3",


   //***************************************************************************
   // Referece clock frequency parameters
   //***************************************************************************
//   parameter REFCLK_FREQ           = 200.0,
                                     // IODELAYCTRL reference clock frequency
//   parameter DIFF_TERM_REFCLK      = "TRUE",
                                     // Differential Termination for idelay
                                     // reference clock input pins
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
//   parameter tCK                   = 2500,
                                     // memory tCK paramter.
                                     // # = Clock Period in pS.
   parameter nCK_PER_CLK           = 4,
                                     // # of memory CKs per fabric CLK
//   parameter DIFF_TERM_SYSCLK      = "FALSE",
                                     // Differential Termination for System
                                     // clock input pins


   //***************************************************************************
   // AXI4 Shim parameters
   //***************************************************************************
   parameter C_S_AXI_ID_WIDTH              = 4,

   parameter C_S_AXI_ADDR_WIDTH            = 30,

   parameter C_S_AXI_DATA_WIDTH            = 512,

   parameter C_S_AXI_SUPPORTS_NARROW_BURST = 0,

   parameter DEBUG_PORT            = "OFF",
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.

   //***************************************************************************
   // Temparature monitor parameter
   //***************************************************************************
//   parameter TEMP_MON_CONTROL      = "INTERNAL",
                                     // # = "INTERNAL", "EXTERNAL"

   parameter RST_ACT_LOW           = 0,
                                     // =1 for active low reset,
                                     // =0 for active high.

  parameter C_ADC_BUFFER_WIDTH = C_S_AXI_DATA_WIDTH/32
   )
  (

    // Inouts
    inout [63:0]                         ddr3_dq,
    inout [7:0]                        ddr3_dqs_n,
    inout [7:0]                        ddr3_dqs_p,

    // Outputs
    output [13:0]                       ddr3_addr,
    output [2:0]                      ddr3_ba,
    output                                       ddr3_ras_n,
    output                                       ddr3_cas_n,
    output                                       ddr3_we_n,
    output                                       ddr3_reset_n,
    output [0:0]                        ddr3_ck_p,
    output [0:0]                        ddr3_ck_n,
    output [0:0]                       ddr3_cke,
    output [0:0]           ddr3_cs_n,
    output [7:0]                        ddr3_dm,
    output [0:0]                       ddr3_odt,

    // Inputs

    // Differential system clocks
    input                                        ddr3_clk1_p,
    input                                        ddr3_clk1_n,
    //  output                                       tg_compare_error,
    // output                                       init_calib_complete,

    //  input                                        cpu_reset,



    // --KC705 Resources - from fmc150 example design
    input cpu_reset,       // : in    std_logic; -- CPU RST button, SW7 on KC705
    input sysclk_p,        // : in    std_logic;
    input sysclk_n,        // : in    std_logic;
    output [7:0]  gpio_led,        // : out   std_logic_vector(7 downto 0);
    input [7:0]  gpio_dip_sw,   //   : in    std_logic_vector(7 downto 0);
    output gpio_led_c,        //       : out   std_logic;
    output gpio_led_e,        //       : out   std_logic;
    output gpio_led_n,       //       : out   std_logic;
    output gpio_led_s,        //       : out   std_logic;
    output gpio_led_w,        //              : out   std_logic;
    input gpio_sw_c,        //               : in    std_logic;
    input gpio_sw_e,        //               : in    std_logic;
    input gpio_sw_n,        //               : in    std_logic;
    input gpio_sw_s,        //               : in    std_logic;
    input gpio_sw_w,        //               : in    std_logic;

    // --Clock/Data connection to ADC on FMC150 (ADS62P49)
    input clk_ab_p,        //                : in    std_logic;
    input clk_ab_n,        //                : in    std_logic;
    input[6:0] cha_p,        //                   : in    std_logic_vector(6 downto 0);
    input[6:0] cha_n,        //                   : in    std_logic_vector(6 downto 0);
    input[6:0] chb_p,        //                   : in    std_logic_vector(6 downto 0);
    input[6:0] chb_n,        //                   : in    std_logic_vector(6 downto 0);

    //  --Clock/Data connection to DAC on FMC150 (DAC3283)
    output dac_dclk_p,        //              : out   std_logic;
    output dac_dclk_n,        //              : out   std_logic;
    output[7:0] dac_data_p,        //              : out   std_logic_vector(7 downto 0);
    output[7:0] dac_data_n,        //              : out   std_logic_vector(7 downto 0);
    output dac_frame_p,        //             : out   std_logic;
    output dac_frame_n,        //             : out   std_logic;
    output txenable,        //                : out   std_logic;

    // --Clock/Trigger connection to FMC150
    // --clk_to_fpga_p    : in    std_logic;
    // --clk_to_fpga_n    : in    std_logic;
    // --ext_trigger_p    : in    std_logic;
    // --ext_trigger_n    : in    std_logic;

    //  --Serial Peripheral Interface (SPI)
    output spi_sclk,        //                : out   std_logic; -- Shared SPI clock line
    output spi_sdata,        //               : out   std_logic; -- Shared SPI sata line

    //  -- ADC specific signals
    output adc_n_en,        //                : out   std_logic; -- SPI chip select
    input adc_sdo,        //                 : in    std_logic; -- SPI data out
    output adc_reset,        //               : out   std_logic; -- SPI reset

    // -- CDCE specific signals
    output cdce_n_en,        //               : out   std_logic; -- SPI chip select
    input cdce_sdo,        //                : in    std_logic; -- SPI data out
    output cdce_n_reset,        //            : out   std_logic;
    output cdce_n_pd,        //               : out   std_logic;
    output ref_en,        //                  : out   std_logic;
    input pll_status,        //             : in    std_logic;

    //  -- DAC specific signals
    output dac_n_en,        //                : out   std_logic; -- SPI chip select
    input dac_sdo,        //                 : in    std_logic; -- SPI data out

    //  -- Monitoring specific signals
    output mon_n_en,        //                : out   std_logic; -- SPI chip select
    input mon_sdo,        //                 : in    std_logic; -- SPI data out
    output mon_n_reset,        //             : out   std_logic;
    input mon_n_int,        //               : in    std_logic;

    // --FMC Present status
    input prsnt_m2c_l,        //             : in    std_logic


    // System reset - Default polarity of sys_rst pin is Active Low.
    // System reset polarity will change based on the option
    // selected in GUI.

    // Ethernet RGMII Interface I/)
    // asynchronous reset
  //  input         glbl_rst,

    // 200MHz clock input from board
  //  input         clk_in_p,
  //  input         clk_in_n,
    // 125 MHz clock from MMCM
    output        gtx_clk_bufg_out,

    output        phy_resetn,


    // RGMII Interface
    //----------------
    output [3:0]  rgmii_txd,
    output        rgmii_tx_ctl,
    output        rgmii_txc,
    input  [3:0]  rgmii_rxd,
    input         rgmii_rx_ctl,
    input         rgmii_rxc,

    // MDIO Interface
    //---------------
    inout         mdio,
    output        mdc,


    // Serialised statistics vectors
    //------------------------------
    output        tx_statistics_s,
    output        rx_statistics_s,

    // Serialised Pause interface controls
    //------------------------------------
    input         pause_req_s,

    // Main example design controls
    //-----------------------------
    //input  [1:0]  mac_speed,    // mac_speed[0] = dip switch[3]. mac_speed[1] = dip switch[2]
    input         update_speed,
    //input         serial_command, // tied to pause_req_s
    input         config_board,
    output        serial_response,
    //input         gen_tx_data, // dip switch[1]
    //input         chk_tx_data,   // dip switch[0]
    input         reset_error,
    output        frame_error,
    output        activity_flashn

    );

function integer clogb2 (input integer size);
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
        size = size >> 1;
    end
  endfunction // clogb2

  function integer STR_TO_INT;
    input [7:0] in;
    begin
      if(in == "8")
        STR_TO_INT = 8;
      else if(in == "4")
        STR_TO_INT = 4;
      else
        STR_TO_INT = 0;
    end
  endfunction


//  localparam CMD_PIPE_PLUS1        = "ON";
                                     // add pipeline stage between MC and PHY
  localparam DATA_WIDTH            = 64;
//  localparam ECC_TEST              = "OFF";
  localparam RANK_WIDTH = clogb2(RANKS);
//  localparam tPRDI                 = 1_000_000;
                                     // memory tPRDI paramter in pS.
  localparam PAYLOAD_WIDTH         = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH;
  localparam BURST_LENGTH          = STR_TO_INT(BURST_MODE);
  localparam APP_DATA_WIDTH        = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
  localparam APP_MASK_WIDTH        = APP_DATA_WIDTH / 8;

  //***************************************************************************
  // Traffic Gen related parameters (derived)
  //***************************************************************************
  localparam  TG_ADDR_WIDTH = ((CS_WIDTH == 1) ? 0 : RANK_WIDTH)
                                 + BANK_WIDTH + ROW_WIDTH + COL_WIDTH;
  localparam MASK_SIZE             = DATA_WIDTH/8;
  localparam DBG_WR_STS_WIDTH      = 40;
  localparam DBG_RD_STS_WIDTH      = 40;

  localparam ADC_AXI_DATA_WIDTH = 64;
  localparam ADC_AXI_STREAM_ID = 1'b0;
  localparam ADC_AXI_STREAM_DEST = 1'b0;



  wire                          clk_245_76MHz;
  wire                          clk_491_52MHz;


  wire                              clk;
  wire                              rst;
  wire                              mmcm_locked;
  reg                               aresetn;
  wire                              app_sr_active;
  wire                              app_ref_ack;
  wire                              app_zq_ack;
  wire                              app_rd_data_valid;
  wire [APP_DATA_WIDTH-1:0]         app_rd_data;

  wire                              mem_pattern_init_done;

  wire                              cmd_err;
  wire                              data_msmatch_err;
  wire                              write_err;
  wire                              read_err;
  wire                              test_cmptd;
  wire                              write_cmptd;
  wire                              read_cmptd;
  wire                              cmptd_one_wr_rd;

  // Slave Interface Write Address Ports
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_awid;
  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr;
  wire [7:0]                        s_axi_awlen;
  wire [2:0]                        s_axi_awsize;
  wire [1:0]                        s_axi_awburst;
  wire [0:0]                        s_axi_awlock;
  wire [3:0]                        s_axi_awcache;
  wire [2:0]                        s_axi_awprot;
  wire                              s_axi_awvalid;
  wire                              s_axi_awready;
   // Slave Interface Write Data Ports
  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata;
  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]   s_axi_wstrb;
  wire                              s_axi_wlast;
  wire                              s_axi_wvalid;
  wire                              s_axi_wready;
   // Slave Interface Write Response Ports
  wire                              s_axi_bready;
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_bid;
  wire [1:0]                        s_axi_bresp;
  wire                              s_axi_bvalid;
   // Slave Interface Read Address Ports
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_arid;
  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr;
  wire [7:0]                        s_axi_arlen;
  wire [2:0]                        s_axi_arsize;
  wire [1:0]                        s_axi_arburst;
  wire [0:0]                        s_axi_arlock;
  wire [3:0]                        s_axi_arcache;
  wire [2:0]                        s_axi_arprot;
  wire                              s_axi_arvalid;
  wire                              s_axi_arready;
   // Slave Interface Read Data Ports
  wire                              s_axi_rready;
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_rid;
  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata;
  wire [1:0]                        s_axi_rresp;
  wire                              s_axi_rlast;
  wire                              s_axi_rvalid;

  wire                              cmp_data_valid;
  wire [C_S_AXI_DATA_WIDTH-1:0]      cmp_data;     // Compare data
  wire [C_S_AXI_DATA_WIDTH-1:0]      rdata_cmp;      // Read data

  wire                              dbg_wr_sts_vld;
  wire [DBG_WR_STS_WIDTH-1:0]       dbg_wr_sts;
  wire                              dbg_rd_sts_vld;
  wire [DBG_RD_STS_WIDTH-1:0]       dbg_rd_sts;



wire                                      tg_compare_error;
wire                                    init_calib_complete;


// Ethernet Controller wrapper signals
wire                 gtx_clk_bufg;
wire                 refclk_bufg;
wire                 s_axi_aclk;
wire                 dcm_locked;

wire                  gen_tx_data;
wire                  chk_tx_data;
wire      [1:0]       mac_speed;



 // --ADC AXI-Stream Data Out Signals from fmc150_dac_adc module
wire [ADC_AXI_DATA_WIDTH-1:0]   axis_adc_tdata;
wire                            axis_adc_tvalid;
wire                            axis_adc_tlast;
wire [ADC_AXI_DATA_WIDTH/8-1:0] axis_adc_tkeep;
wire                            axis_adc_tid;
wire                            axis_adc_tdest;
wire                            axis_adc_tuser;
wire                            axis_adc_tready;


assign tg_compare_error = cmd_err | data_msmatch_err | write_err | read_err;




// Start of User Design top instance
//***************************************************************************
// The User design is instantiated below. The memory interface ports are
// connected to the top-level and the application interface ports are
// connected to the traffic generator module. This provides a reference
// for connecting the memory controller to system.
//***************************************************************************



kc705_ethernet_rgmii_example_design ethernet_rgmii_wrapper
(
  // asynchronous reset
  .glbl_rst         (cpu_reset),

  // 200MHz clock input from board
  //.clk_in_p         (ddr3_clk1_p),
  //.clk_in_n         (ddr3_clk1_n),
  // 125 MHz clock from MMCM
  .gtx_clk_bufg     (gtx_clk_bufg),
  .refclk_bufg      (refclk_bufg),
  .s_axi_aclk       (s_axi_aclk),

  .dcm_locked       (dcm_locked),

  .phy_resetn        (phy_resetn),


  // RGMII Interface
  //----------------
  .rgmii_txd        (rgmii_txd),    //[3:0]
  .rgmii_tx_ctl        (rgmii_tx_ctl),
  .rgmii_txc        (rgmii_txc),
  .rgmii_rxd         (rgmii_rxd), //[3:0]
  .rgmii_rx_ctl         (rgmii_rx_ctl),
  .rgmii_rxc         (rgmii_rxc),

  // MDIO Interface
  //---------------
  .mdio         (mdio),
  .mdc        (mdc),


  // Serialised statistics vectors
  //------------------------------
  .tx_statistics_s        (tx_statistics_s),
  .rx_statistics_s        (rx_statistics_s),

  // Serialised Pause interface controls
  //------------------------------------
  .pause_req_s         (pause_req_s),

  // connections to adc data ports
  .enable_adc_pkt            (enable_adc_pkt),
  .adc_axis_tdata           (adc_axis_tdata),
  .adc_axis_tvalid          (adc_axis_tvalid),
  .adc_axis_tlast           (adc_axis_tlast),
  .adc_axis_tuser           (adc_axis_tuser),
  .adc_axis_tready          (adc_axis_tready),

  // Main example design controls
  //-----------------------------
  .mac_speed             (mac_speed),       // [1:0]
  .update_speed         (update_speed),
  //input         serial_command, // tied to pause_req_s
  .config_board         (config_board),
  .serial_response        (serial_response),
  .gen_tx_data         (gen_tx_data),
  .chk_tx_data         (chk_tx_data),
  .reset_error         (reset_error),
  .frame_error        (frame_error),
  .frame_errorn        (frame_errorn),
  .activity_flash        (activity_flash),
  .activity_flashn        (activity_flashn)
);

assign gen_tx_data = gpio_dip_sw[1];
assign chk_tx_data = gpio_dip_sw[0];
assign mac_speed = {gpio_dip_sw[2],gpio_dip_sw[3]};
assign enable_adc_pkt = 1'b1;

//----------------------------------------------------------------------------
// Clock logic to generate required clocks from the 200MHz on board
// if 125MHz is available directly this can be removed
//----------------------------------------------------------------------------
kc705_ethernet_rgmii_example_design_clocks example_clocks
 (
    // differential clock inputs
    .clk_in_p         (ddr3_clk1_p),
    .clk_in_n         (ddr3_clk1_n),

    // asynchronous control/resets
    .glbl_rst         (glbl_rst),
    .dcm_locked       (dcm_locked),

    // clock outputs
    .gtx_clk_bufg     (gtx_clk_bufg),
    .refclk_bufg      (refclk_bufg),
    .s_axi_aclk       (s_axi_aclk)
 );

 assign gtx_clk_bufg_out = gtx_clk_bufg;


fmc150_dac_adc  #
(
    .C_AXI_ID_WIDTH                   (C_S_AXI_ID_WIDTH),
    .C_AXI_ADDR_WIDTH                 (C_S_AXI_ADDR_WIDTH),
    .C_AXI_DATA_WIDTH                 (C_S_AXI_DATA_WIDTH),
    .C_AXI_NBURST_SUPPORT             (C_AXI_NBURST_TEST),
    .C_EN_WRAP_TRANS                  (C_EN_WRAP_TRANS),
    .C_BEGIN_ADDRESS                  (BEGIN_ADDRESS),
    .C_END_ADDRESS                    (END_ADDRESS),
    .PRBS_EADDR_MASK_POS              (PRBS_EADDR_MASK_POS),
    .DBG_WR_STS_WIDTH                 (DBG_WR_STS_WIDTH),
    .DBG_RD_STS_WIDTH                 (DBG_RD_STS_WIDTH),
    .ENFORCE_RD_WR                    (ENFORCE_RD_WR),
    .ENFORCE_RD_WR_CMD                (ENFORCE_RD_WR_CMD),
    .EN_UPSIZER                       (C_S_AXI_SUPPORTS_NARROW_BURST),
    .ENFORCE_RD_WR_PATTERN            (ENFORCE_RD_WR_PATTERN),
    .ADC_BUFFER_WIDTH (C_ADC_BUFFER_WIDTH),

    .ADC_AXI_DATA_WIDTH(ADC_AXI_DATA_WIDTH),
    .ADC_AXI_STREAM_ID(ADC_AXI_STREAM_ID),
    .ADC_AXI_STREAM_DEST(ADC_AXI_STREAM_DEST)
)
fmc150_dac_adc_inst
(
    .aclk (clk),
    .aresetn (aresetn),
     // --KC705 Resources - from fmc150 example design
     .axis_adc_tdata                      (axis_adc_tdata),
     .axis_adc_tvalid                     (axis_adc_tvalid),
     .axis_adc_tlast                      (axis_adc_tlast),
     .axis_adc_tkeep                      (axis_adc_tkeep),
     .axis_adc_tid                        (axis_adc_tid),
     .axis_adc_tdest                      (axis_adc_tdest),
     .axis_adc_tuser                      (axis_adc_tuser),
     .axis_adc_tready                     (axis_adc_tready),


     .clk_out_245_76MHz                        (clk_245_76MHz),
     .clk_out_491_52MHz                       (clk_491_52MHz),


    .cpu_reset (cpu_reset),       // : in    std_logic; -- CPU RST button, SW7 on KC705
    .sysclk_p (sysclk_p),        // : in    std_logic;
    .sysclk_n (sysclk_n),        // : in    std_logic;
//    .sysclk_p (refclk2_p),        // : in    std_logic;
//    .sysclk_n (refclk2_n),        // : in    std_logic;
//    .sysclk_buf (refclk2),
    .gpio_led (gpio_led),        // : out   std_logic_vector(7 downto 0);
    .gpio_dip_sw (gpio_dip_sw),   //   : in    std_logic_vector(7 downto 0);
    .gpio_led_c (gpio_led_c),        //       : out   std_logic;
     .gpio_led_e (gpio_led_e),        //       : out   std_logic;
     .gpio_led_n (gpio_led_n),       //       : out   std_logic;
     .gpio_led_s (gpio_led_s),        //       : out   std_logic;
     .gpio_led_w (gpio_led_w),        //              : out   std_logic;
     .gpio_sw_c (gpio_sw_c),        //               : in    std_logic;
     .gpio_sw_e (gpio_sw_e),        //               : in    std_logic;
     .gpio_sw_n (gpio_sw_n),        //               : in    std_logic;
     .gpio_sw_s (gpio_sw_s),        //               : in    std_logic;
     .gpio_sw_w (gpio_sw_w),        //               : in    std_logic;

    // --Clock/Data connection to ADC on FMC150 (ADS62P49)
     .clk_ab_p (clk_ab_p),        //                : in    std_logic;
     .clk_ab_n (clk_ab_n),        //                : in    std_logic;
     .cha_p (cha_p),        //                   : in    std_logic_vector(6 downto 0);
     .cha_n (cha_n),        //                   : in    std_logic_vector(6 downto 0);
     .chb_p (chb_p),        //                   : in    std_logic_vector(6 downto 0);
     .chb_n (chb_n),        //                   : in    std_logic_vector(6 downto 0);

    //  --Clock/Data connection to DAC on FMC150 (DAC3283)
     .dac_dclk_p (dac_dclk_p),        //              : out   std_logic;
     .dac_dclk_n (dac_dclk_n),        //              : out   std_logic;
     .dac_data_p (dac_data_p),        //              : out   std_logic_vector(7 downto 0);
     .dac_data_n (dac_data_n),        //              : out   std_logic_vector(7 downto 0);
     .dac_frame_p (dac_frame_p),        //             : out   std_logic;
     .dac_frame_n (dac_frame_n),        //             : out   std_logic;
     .txenable (txenable),        //                : out   std_logic;

    // --Clock/Trigger connection to FMC150
    // --clk_to_fpga_p    : in    std_logic;
    // --clk_to_fpga_n    : in    std_logic;
    // --ext_trigger_p    : in    std_logic;
    // --ext_trigger_n    : in    std_logic;

    //  --Serial Peripheral Interface (SPI)
     .spi_sclk (spi_sclk),        //                : out   std_logic; -- Shared SPI clock line
     .spi_sdata (spi_sdata),        //               : out   std_logic; -- Shared SPI sata line

    //  -- ADC specific signals
     .adc_n_en (adc_n_en),        //                : out   std_logic; -- SPI chip select
     .adc_sdo (adc_sdo),        //                 : in    std_logic; -- SPI data out
     .adc_reset (adc_reset),        //               : out   std_logic; -- SPI reset

    // -- CDCE specific signals
     .cdce_n_en (cdce_n_en),        //               : out   std_logic; -- SPI chip select
     .cdce_sdo (cdce_sdo),        //                : in    std_logic; -- SPI data out
     .cdce_n_reset (cdce_n_reset),        //            : out   std_logic;
     .cdce_n_pd (cdce_n_pd),        //               : out   std_logic;
     .ref_en (ref_en),        //                  : out   std_logic;
     .pll_status (pll_status),        //             : in    std_logic;

    //  -- DAC specific signals
     .dac_n_en (dac_n_en),        //                : out   std_logic; -- SPI chip select
     .dac_sdo (dac_sdo),        //                 : in    std_logic; -- SPI data out

    //  -- Monitoring specific signals
      .mon_n_en (mon_n_en),        //                : out   std_logic; -- SPI chip select
      .mon_sdo (mon_sdo),        //                 : in    std_logic; -- SPI data out
      .mon_n_reset (mon_n_reset),        //             : out   std_logic;
      .mon_n_int (mon_n_int),        //               : in    std_logic;

    // --FMC Present status
     .prsnt_m2c_l (prsnt_m2c_l)        //             : in    std_logic

);



axi_vfifo_ctrl_0 u_axi_vfifo_ctrl_0(
// aclk : IN STD_LOGIC;
// aresetn : IN STD_LOGIC;
// s_axis_tvalid : IN STD_LOGIC;
// s_axis_tready : OUT STD_LOGIC;
// s_axis_tdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
// s_axis_tstrb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
// s_axis_tkeep : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
// s_axis_tlast : IN STD_LOGIC;
// s_axis_tid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
// s_axis_tdest : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axis_tvalid : OUT STD_LOGIC;
// m_axis_tready : IN STD_LOGIC;
// m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
// m_axis_tstrb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
// m_axis_tkeep : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
// m_axis_tlast : OUT STD_LOGIC;
// m_axis_tid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axis_tdest : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_awid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
// m_axi_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
// m_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
// m_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
// m_axi_awlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
// m_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
// m_axi_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
// m_axi_awregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
// m_axi_awuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_awvalid : OUT STD_LOGIC;
// m_axi_awready : IN STD_LOGIC;
// m_axi_wdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
// m_axi_wstrb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
// m_axi_wlast : OUT STD_LOGIC;
// m_axi_wuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_wvalid : OUT STD_LOGIC;
// m_axi_wready : IN STD_LOGIC;
// m_axi_bid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
// m_axi_buser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_bvalid : IN STD_LOGIC;
// m_axi_bready : OUT STD_LOGIC;
// m_axi_arid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
// m_axi_arlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
// m_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
// m_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
// m_axi_arlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
// m_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
// m_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
// m_axi_arregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
// m_axi_aruser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_arvalid : OUT STD_LOGIC;
// m_axi_arready : IN STD_LOGIC;
// m_axi_rid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_rdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
// m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
// m_axi_rlast : IN STD_LOGIC;
// m_axi_ruser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
// m_axi_rvalid : IN STD_LOGIC;
// m_axi_rready : OUT STD_LOGIC;
// vfifo_mm2s_channel_full : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
// vfifo_s2mm_channel_full : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
// vfifo_mm2s_channel_empty : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
// vfifo_idle : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);

axis_interconnect_0 u_axis_interconnect_0(
//   ACLK,
// ARESETN,
// S00_AXIS_ACLK,
// S01_AXIS_ACLK,
// S00_AXIS_ARESETN,
// S01_AXIS_ARESETN,
// S00_AXIS_TVALID,
// S01_AXIS_TVALID,
// S00_AXIS_TREADY,
// S01_AXIS_TREADY,
// S00_AXIS_TDATA,
// S01_AXIS_TDATA,
// S00_AXIS_TSTRB,
// S01_AXIS_TSTRB,
// S00_AXIS_TKEEP,
// S01_AXIS_TKEEP,
// S00_AXIS_TLAST,
// S01_AXIS_TLAST,
// S00_AXIS_TID,
// S01_AXIS_TID,
// S00_AXIS_TDEST,
// S01_AXIS_TDEST,
// S00_AXIS_TUSER,
// S01_AXIS_TUSER,
// M00_AXIS_ACLK,
// M00_AXIS_ARESETN,
// M00_AXIS_TVALID,
// M00_AXIS_TREADY,
// M00_AXIS_TDATA,
// M00_AXIS_TSTRB,
// M00_AXIS_TKEEP,
// M00_AXIS_TLAST,
// M00_AXIS_TID,
// M00_AXIS_TDEST,
// M00_AXIS_TUSER,
// S00_ARB_REQ_SUPPRESS,
// S01_ARB_REQ_SUPPRESS,
// S00_DECODE_ERR,
// S01_DECODE_ERR,
// S00_FIFO_DATA_COUNT,
// S01_FIFO_DATA_COUNT
// );
//
// (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLKIF CLK" *)
// input wire ACLK;
// (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RSTIF RST" *)
// input wire ARESETN;
// (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_CLKIF CLK" *)
// input wire S00_AXIS_ACLK;
// (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S01_CLKIF CLK" *)
// input wire S01_AXIS_ACLK;
// (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_RSTIF RST" *)
// input wire S00_AXIS_ARESETN;
// (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S01_RSTIF RST" *)
// input wire S01_AXIS_ARESETN;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TVALID" *)
// input wire S00_AXIS_TVALID;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TVALID" *)
// input wire S01_AXIS_TVALID;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TREADY" *)
// output wire S00_AXIS_TREADY;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TREADY" *)
// output wire S01_AXIS_TREADY;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TDATA" *)
// input wire [511 : 0] S00_AXIS_TDATA;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TDATA" *)
// input wire [63 : 0] S01_AXIS_TDATA;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TSTRB" *)
// input wire [63 : 0] S00_AXIS_TSTRB;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TSTRB" *)
// input wire [7 : 0] S01_AXIS_TSTRB;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TKEEP" *)
// input wire [63 : 0] S00_AXIS_TKEEP;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TKEEP" *)
// input wire [7 : 0] S01_AXIS_TKEEP;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TLAST" *)
// input wire S00_AXIS_TLAST;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TLAST" *)
// input wire S01_AXIS_TLAST;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TID" *)
// input wire [0 : 0] S00_AXIS_TID;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TID" *)
// input wire [0 : 0] S01_AXIS_TID;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TDEST" *)
// input wire [0 : 0] S00_AXIS_TDEST;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TDEST" *)
// input wire [0 : 0] S01_AXIS_TDEST;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TUSER" *)
// input wire [63 : 0] S00_AXIS_TUSER;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S01_AXIS TUSER" *)
// input wire [7 : 0] S01_AXIS_TUSER;
// (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M00_CLKIF CLK" *)
// input wire M00_AXIS_ACLK;
// (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M00_RSTIF RST" *)
// input wire M00_AXIS_ARESETN;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TVALID" *)
// output wire M00_AXIS_TVALID;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TREADY" *)
// input wire M00_AXIS_TREADY;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TDATA" *)
// output wire [2047 : 0] M00_AXIS_TDATA;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TSTRB" *)
// output wire [255 : 0] M00_AXIS_TSTRB;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TKEEP" *)
// output wire [255 : 0] M00_AXIS_TKEEP;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TLAST" *)
// output wire M00_AXIS_TLAST;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TID" *)
// output wire [0 : 0] M00_AXIS_TID;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TDEST" *)
// output wire [0 : 0] M00_AXIS_TDEST;
// (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TUSER" *)
// output wire [255 : 0] M00_AXIS_TUSER;
// input wire S00_ARB_REQ_SUPPRESS;
// input wire S01_ARB_REQ_SUPPRESS;
// output wire S00_DECODE_ERR;
// output wire S01_DECODE_ERR;
// output wire [31 : 0] S00_FIFO_DATA_COUNT;
// output wire [31 : 0] S01_FIFO_DATA_COUNT;
  );

//   mig_7series_0 u_mig_7series_0
//       (
//
//
// // Memory interface ports
//        .ddr3_addr                      (ddr3_addr),
//        .ddr3_ba                        (ddr3_ba),
//        .ddr3_cas_n                     (ddr3_cas_n),
//        .ddr3_ck_n                      (ddr3_ck_n),
//        .ddr3_ck_p                      (ddr3_ck_p),
//        .ddr3_cke                       (ddr3_cke),
//        .ddr3_ras_n                     (ddr3_ras_n),
//        .ddr3_reset_n                   (ddr3_reset_n),
//        .ddr3_we_n                      (ddr3_we_n),
//        .ddr3_dq                        (ddr3_dq),
//        .ddr3_dqs_n                     (ddr3_dqs_n),
//        .ddr3_dqs_p                     (ddr3_dqs_p),
//        .init_calib_complete            (init_calib_complete),
//
//        .ddr3_cs_n                      (ddr3_cs_n),
//        .ddr3_dm                        (ddr3_dm),
//        .ddr3_odt                       (ddr3_odt),
// // Application interface ports
//        .ui_clk                         (clk),
//        .ui_clk_sync_rst                (rst),
//
//        .mmcm_locked                    (mmcm_locked),
//        .aresetn                        (aresetn),
//        .app_sr_req                     (1'b0),
//        .app_ref_req                    (1'b0),
//        .app_zq_req                     (1'b0),
//        .app_sr_active                  (app_sr_active),
//        .app_ref_ack                    (app_ref_ack),
//        .app_zq_ack                     (app_zq_ack),
//
// // Slave Interface Write Address Ports
//        .s_axi_awid                     (s_axi_awid),
//        .s_axi_awaddr                   (s_axi_awaddr),
//        .s_axi_awlen                    (s_axi_awlen),
//        .s_axi_awsize                   (s_axi_awsize),
//        .s_axi_awburst                  (s_axi_awburst),
//        .s_axi_awlock                   (s_axi_awlock),
//        .s_axi_awcache                  (s_axi_awcache),
//        .s_axi_awprot                   (s_axi_awprot),
//        .s_axi_awqos                    (4'h0),
//        .s_axi_awvalid                  (s_axi_awvalid),
//        .s_axi_awready                  (s_axi_awready),
// // Slave Interface Write Data Ports
//        .s_axi_wdata                    (s_axi_wdata),
// //       .s_axi_wdata                    (axi_adc_fifo_data_out),
//
//        .s_axi_wstrb                    (s_axi_wstrb),
//        .s_axi_wlast                    (s_axi_wlast),
//        .s_axi_wvalid                   (s_axi_wvalid),
// //       .s_axi_wvalid                   (adc_fifo_valid),
//        .s_axi_wready                   (s_axi_wready),
// // Slave Interface Write Response Ports
//        .s_axi_bid                      (s_axi_bid),
//        .s_axi_bresp                    (s_axi_bresp),
//        .s_axi_bvalid                   (s_axi_bvalid),
//        .s_axi_bready                   (s_axi_bready),
// // Slave Interface Read Address Ports
//        .s_axi_arid                     (s_axi_arid),
//        .s_axi_araddr                   (s_axi_araddr),
//        .s_axi_arlen                    (s_axi_arlen),
//        .s_axi_arsize                   (s_axi_arsize),
//        .s_axi_arburst                  (s_axi_arburst),
//        .s_axi_arlock                   (s_axi_arlock),
//        .s_axi_arcache                  (s_axi_arcache),
//        .s_axi_arprot                   (s_axi_arprot),
//        .s_axi_arqos                    (4'h0),
//        .s_axi_arvalid                  (s_axi_arvalid),
//        .s_axi_arready                  (s_axi_arready),
// // Slave Interface Read Data Ports
//        .s_axi_rid                      (s_axi_rid),
//        .s_axi_rdata                    (s_axi_rdata),
//        .s_axi_rresp                    (s_axi_rresp),
//        .s_axi_rlast                    (s_axi_rlast),
//        .s_axi_rvalid                   (s_axi_rvalid),
//        .s_axi_rready                   (s_axi_rready),
//
//
//
// // System Clock Ports
//        .sys_clk_p                       (ddr3_clk1_p),
//        .sys_clk_n                       (ddr3_clk1_n),
// //        .sys_clk_p                       (refclk1_p),
// //        .sys_clk_n                       (refclk1_n),
//
//        .sys_rst                        (cpu_reset)
//        );
// // End of User Design top instance


//***************************************************************************
// The traffic generation module instantiated below drives traffic (patterns)
// on the application interface of the memory controller
//***************************************************************************

   always @(posedge clk) begin
     aresetn <= ~rst;
   end






endmodule
