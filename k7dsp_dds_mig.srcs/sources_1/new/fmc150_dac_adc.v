`timescale 1ps/1ps

module fmc150_dac_adc #
  (

     parameter C_AXI_ID_WIDTH           = 4, // The AXI id width used for read and write
                                             // This is an integer between 1-16
     parameter C_AXI_ADDR_WIDTH         = 32, // This is AXI address width for all 
                                              // SI and MI slots
     parameter C_AXI_DATA_WIDTH         = 32, // Width of the AXI write and read data
  
     parameter C_AXI_NBURST_SUPPORT     = 0, // Support for narrow burst transfers
                                             // 1-supported, 0-not supported 
     parameter C_EN_WRAP_TRANS          = 0, // Set 1 to enable wrap transactions

     parameter C_BEGIN_ADDRESS          = 0, // Start address of the address map
  
     parameter C_END_ADDRESS            = 32'hFFFF_FFFF, // End address of the address map
     
     parameter PRBS_EADDR_MASK_POS      = 32'hFFFFD000,

     parameter PRBS_SADDR_MASK_POS      = 32'h00002000,

     parameter DBG_WR_STS_WIDTH         = 40,

     parameter DBG_RD_STS_WIDTH         = 40,
  
     parameter ENFORCE_RD_WR            = 0,

     parameter ENFORCE_RD_WR_CMD        = 8'h11,

     parameter EN_UPSIZER               = 0,

     parameter ENFORCE_RD_WR_PATTERN    = 3'b000,
  
     parameter ADC_BUFFER_WIDTH = 1
  
   )
  (

   input    aclk, // AXI input clock
   input    aresetn, // Active low AXI reset signal

 // --KC705 Resources - from fmc150 example design
 
  input cpu_reset,       // : in    std_logic; -- CPU RST button, SW7 on KC705
  input sysclk_p,        // : in    std_logic;
  input sysclk_n,        // : in    std_logic;
  
   // --ADC Data Out Signals
   output [63:0] adc_data_out, 
  output adc_data_out_valid,
  
  output clk_out_245_76MHz,
  output clk_out_491_52MHz,
  
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
 input prsnt_m2c_l        //             : in    std_logic
 
 
 
   );
     wire clk;
     wire clk_245_76MHz;
     wire clk_491_52MHz;
     
/*    
     wire [9:0]              adc_fifo_wr_data_count;
     wire [6:0]               adc_fifo_rd_data_count;
     wire                       adc_fifo_wr_ack;
     wire                       adc_fifo_valid;
     wire                       adc_fifo_almost_full;
     wire                       adc_fifo_almost_empty;
     wire                      adc_fifo_wr_en;
     wire                      adc_fifo_rd_en;
     wire [511:0]             axi_adc_fifo_data_out;
     wire                     adc_fifo_full;
     wire                     adc_fifo_empty;
     
      
     
  // Wires for adc_axi4_inst module
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
     wire [C_AXI_ID_WIDTH-1:0]       s_axi_awid;
     wire [C_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr;
     wire [7:0]                        s_axi_awlen;
     wire [2:0]                        s_axi_awsize;
     wire [1:0]                        s_axi_awburst;
     wire [0:0]                        s_axi_awlock;
     wire [3:0]                        s_axi_awcache;
     wire [2:0]                        s_axi_awprot;
     wire                              s_axi_awvalid;
     wire                              s_axi_awready;
      // Slave Interface Write Data Ports
     wire [C_AXI_DATA_WIDTH-1:0]     s_axi_wdata;
     wire [(C_AXI_DATA_WIDTH/8)-1:0]   s_axi_wstrb;
     wire                              s_axi_wlast;
     wire                              s_axi_wvalid;
     wire                              s_axi_wready;
      // Slave Interface Write Response Ports
     wire                              s_axi_bready;
     wire [C_AXI_ID_WIDTH-1:0]       s_axi_bid;
     wire [1:0]                        s_axi_bresp;
     wire                              s_axi_bvalid;
      // Slave Interface Read Address Ports
     wire [C_AXI_ID_WIDTH-1:0]       s_axi_arid;
     wire [C_AXI_ADDR_WIDTH-1:0]     s_axi_araddr;
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
     wire [C_AXI_ID_WIDTH-1:0]       s_axi_rid;
     wire [C_AXI_DATA_WIDTH-1:0]     s_axi_rdata;
     wire [1:0]                        s_axi_rresp;
     wire                              s_axi_rlast;
     wire                              s_axi_rvalid;
   
     wire                              cmp_data_valid;
     wire [C_AXI_DATA_WIDTH-1:0]      cmp_data;     // Compare data
     wire [C_AXI_DATA_WIDTH-1:0]      rdata_cmp;      // Read data
   
     wire                              dbg_wr_sts_vld;
     wire [DBG_WR_STS_WIDTH-1:0]       dbg_wr_sts;
     wire                              dbg_rd_sts_vld;
     wire [DBG_RD_STS_WIDTH-1:0]       dbg_rd_sts; 
   
   wire                                      tg_compare_error;
   wire                                    init_calib_complete;
   */
   
   KC705_fmc150  #
   (
       .ADC_BUFFER_WIDTH (ADC_BUFFER_WIDTH)
   )
    KC705_fmc150_inst
   (
        // --KC705 Resources - from fmc150 example design
        .adc_data_out (adc_data_out),
        .adc_data_out_valid (adc_data_out_valid),
        
        .clk_out_245_76MHz  (clk_245_76MHz),
        .clk_out_491_52MHz  (clk_491_52MHz),
          
          
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
   
   /*
   
   fifo_generator_adc u_fifo_generator_adc 
   (
   //wr_clk                    : IN  std_logic := '0';
   // rd_clk                    : IN  std_logic := '0';
   // wr_data_count             : OUT std_logic_vector(10-1 DOWNTO 0) := (OTHERS => '0');
   //rd_data_count             : OUT std_logic_vector(7-1 DOWNTO 0) := (OTHERS => '0');
   //wr_ack                    : OUT std_logic := '0';
   //valid                     : OUT std_logic := '0';
   //almost_full               : OUT std_logic := '0';
   //almost_empty              : OUT std_logic := '1';
   //rst                       : IN  std_logic := '0';
   //wr_en                     : IN  std_logic := '0';
   //rd_en                     : IN  std_logic := '0';
   //din                       : IN  std_logic_vector(64-1 DOWNTO 0) := (OTHERS => '0');
   //dout                      : OUT std_logic_vector(512-1 DOWNTO 0) := (OTHERS => '0');
   //full                      : OUT std_logic := '0';
   //empty                     : OUT std_logic := '1');
   .wr_clk                    (clk_245_76MHz),
   .rd_clk                    (clk),
   .wr_data_count             (adc_fifo_wr_data_count),
   .rd_data_count             (adc_fifo_rd_data_count),
   .wr_ack                    (adc_fifo_wr_ack),
   .valid                     (adc_fifo_valid),
   .almost_full               (adc_fifo_almost_full),
   .almost_empty              (adc_fifo_almost_empty),
   .rst                       (cpu_reset),
   //.wr_en                     (adc_fifo_wr_en),
   .wr_en                     (adc_data_out_valid),
   //.rd_en                     (adc_fifo_rd_en),
   .rd_en                     (adc_fifo_rd_en),
   .din                       (adc_data_out),
   .dout                      (axi_adc_fifo_data_out),
   .full                      (adc_fifo_full),
   .empty                     (adc_fifo_empty)
   
   );
   assign adc_fifo_rd_en = 1'b1;
   
   
   fmc150_adc_axi4 #(

     .C_AXI_ID_WIDTH                   (C_AXI_ID_WIDTH),
     .C_AXI_ADDR_WIDTH                 (C_AXI_ADDR_WIDTH),
     .C_AXI_DATA_WIDTH                 (C_AXI_DATA_WIDTH),
     .C_AXI_NBURST_SUPPORT             (C_AXI_NBURST_SUPPORT),
     .C_EN_WRAP_TRANS                  (C_EN_WRAP_TRANS),
     .C_BEGIN_ADDRESS                  (C_BEGIN_ADDRESS),
     .C_END_ADDRESS                    (C_END_ADDRESS),
     .PRBS_EADDR_MASK_POS              (PRBS_EADDR_MASK_POS),
     .DBG_WR_STS_WIDTH                 (DBG_WR_STS_WIDTH),
     .DBG_RD_STS_WIDTH                 (DBG_RD_STS_WIDTH),
     .ENFORCE_RD_WR                    (ENFORCE_RD_WR),
     .ENFORCE_RD_WR_CMD                (ENFORCE_RD_WR_CMD),
     .EN_UPSIZER                       (EN_UPSIZER),
     .ENFORCE_RD_WR_PATTERN            (ENFORCE_RD_WR_PATTERN)

   ) u_adc_axi4_inst
   (
     .aclk                             (clk),
     .aresetn                          (aresetn),

    .adc_axi_data                      (axi_adc_fifo_data_out),
// Input control signals
     .init_cmptd                       (init_calib_complete),
     .init_test                        (1'b0),
     .wdog_mask                        (~init_calib_complete),
     .wrap_en                          (1'b0),

// AXI write address channel signals
     .axi_wready                       (s_axi_awready),
     .axi_wid                          (s_axi_awid),
     .axi_waddr                        (s_axi_awaddr),
     .axi_wlen                         (s_axi_awlen),
     .axi_wsize                        (s_axi_awsize),
     .axi_wburst                       (s_axi_awburst),
     .axi_wlock                        (s_axi_awlock),
     .axi_wcache                       (s_axi_awcache),
     .axi_wprot                        (s_axi_awprot),
     .axi_wvalid                       (s_axi_awvalid),

// AXI write data channel signals
     .axi_wd_wready                    (s_axi_wready),
     .axi_wd_wid                       (s_axi_wid),
     .axi_wd_data                      (s_axi_wdata),
     .axi_wd_strb                      (s_axi_wstrb),
     .axi_wd_last                      (s_axi_wlast),
     .axi_wd_valid                     (s_axi_wvalid),

// AXI write response channel signals
     .axi_wd_bid                       (s_axi_bid),
     .axi_wd_bresp                     (s_axi_bresp),
     .axi_wd_bvalid                    (s_axi_bvalid),
     .axi_wd_bready                    (s_axi_bready),

// AXI read address channel signals
     .axi_rready                       (s_axi_arready),
     .axi_rid                          (s_axi_arid),
     .axi_raddr                        (s_axi_araddr),
     .axi_rlen                         (s_axi_arlen),
     .axi_rsize                        (s_axi_arsize),
     .axi_rburst                       (s_axi_arburst),
     .axi_rlock                        (s_axi_arlock),
     .axi_rcache                       (s_axi_arcache),
     .axi_rprot                        (s_axi_arprot),
     .axi_rvalid                       (s_axi_arvalid),

// AXI read data channel signals
     .axi_rd_bid                       (s_axi_rid),
     .axi_rd_rresp                     (s_axi_rresp),
     .axi_rd_rvalid                    (s_axi_rvalid),
     .axi_rd_data                      (s_axi_rdata),
     .axi_rd_last                      (s_axi_rlast),
     .axi_rd_rready                    (s_axi_rready),

// Error status signals
     .cmd_err                          (cmd_err),
     .data_msmatch_err                 (data_msmatch_err),
     .write_err                        (write_err),
     .read_err                         (read_err),
     .test_cmptd                       (test_cmptd),
     .write_cmptd                      (write_cmptd),
     .read_cmptd                       (read_cmptd),
     .cmptd_one_wr_rd                  (cmptd_one_wr_rd),

// Debug status signals
     .cmp_data_en                      (cmp_data_valid),
     .cmp_data_o                       (cmp_data),
     .rdata_cmp                        (rdata_cmp),
     .dbg_wr_sts_vld                   (dbg_wr_sts_vld),
     .dbg_wr_sts                       (dbg_wr_sts),
     .dbg_rd_sts_vld                   (dbg_rd_sts_vld),
     .dbg_rd_sts                       (dbg_rd_sts)
);
*/
assign clk = aclk;
assign clk_out_245_76MHz = clk_245_76MHz;
assign clk_out_491_52MHz = clk_491_52MHz;
   
   endmodule