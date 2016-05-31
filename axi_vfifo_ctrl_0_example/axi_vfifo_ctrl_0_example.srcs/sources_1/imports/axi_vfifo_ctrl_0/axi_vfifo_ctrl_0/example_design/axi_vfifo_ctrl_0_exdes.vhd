--------------------------------------------------------------------------------
--
-- AXI Virtual FIFO Controller Core - core top file for simulation
--
--------------------------------------------------------------------------------
--
-- (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--------------------------------------------------------------------------------
--
-- Filename: axi_vfifo_ctrl_0_exdes.vhd
--
-- Description:
--   This is the VFIFO core wrapper instances for clock and aresetn connections.
--
--------------------------------------------------------------------------------
-- Library Declarations
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE ieee.STD_LOGIC_misc.all;
USE ieee.STD_LOGIC_arith.all;
USE ieee.STD_LOGIC_unsigned.all;

LIBRARY unisim;
USE unisim.vcomponents.all;

ENTITY axi_vfifo_ctrl_0_exdes IS
  PORT(
    SIGNAL  aclk   	 : IN STD_LOGIC;
    SIGNAL  aresetn 	 : IN STD_LOGIC;
    SIGNAL  done         : OUT STD_LOGIC;
    SIGNAL  in_pkt       : OUT STD_LOGIC;
    SIGNAL  out_pkt      : OUT STD_LOGIC;
    SIGNAL  test_status  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch_axi_vfifo_ctrl_0_exdes of axi_vfifo_ctrl_0_exdes IS

 SIGNAL m_axi_awid                          : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_awaddr                        : STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
 SIGNAL m_axi_awlen                         : STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
 SIGNAL m_axi_awsize                        : STD_LOGIC_VECTOR(3 - 1 DOWNTO 0);
 SIGNAL m_axi_awburst                       : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
 SIGNAL m_axi_awlock                        : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_awcache                       : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
 SIGNAL m_axi_awprot                        : STD_LOGIC_VECTOR(3 - 1 DOWNTO 0);
 SIGNAL m_axi_awqos                         : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
 SIGNAL m_axi_awregion                      : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
 SIGNAL m_axi_awuser                        : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_awvalid                       : STD_LOGIC;
 SIGNAL m_axi_awready                       : STD_LOGIC;

 SIGNAL m_axi_wdata                         : STD_LOGIC_VECTOR(256 - 1 DOWNTO 0);
 SIGNAL m_axi_wstrb                         : STD_LOGIC_VECTOR(256 / 8 - 1 DOWNTO 0);
 SIGNAL m_axi_wlast                         : STD_LOGIC;
 SIGNAL m_axi_wuser                         : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_wvalid                        : STD_LOGIC;
 SIGNAL m_axi_wready                        : STD_LOGIC;
 
 SIGNAL m_axi_bid                           : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_bresp                         : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
 SIGNAL m_axi_buser                         : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_bvalid                        : STD_LOGIC;
 SIGNAL m_axi_bready                        : STD_LOGIC;
 
 SIGNAL m_axi_arid                          : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_araddr                        : STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
 SIGNAL m_axi_arlen                         : STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
 SIGNAL m_axi_arsize                        : STD_LOGIC_VECTOR(3 - 1 DOWNTO 0);
 SIGNAL m_axi_arburst                       : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
 SIGNAL m_axi_arlock                        : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_arcache                       : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
 SIGNAL m_axi_arprot                        : STD_LOGIC_VECTOR(3 - 1 DOWNTO 0);
 SIGNAL m_axi_arqos                         : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
 SIGNAL m_axi_arregion                      : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
 SIGNAL m_axi_aruser                        : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_arvalid                       : STD_LOGIC;
 SIGNAL m_axi_arready                       : STD_LOGIC;
 
 SIGNAL m_axi_rid                           : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_rdata                         : STD_LOGIC_VECTOR(256 - 1 DOWNTO 0);
 SIGNAL m_axi_rresp                         : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
 SIGNAL m_axi_rlast                         : STD_LOGIC;
 SIGNAL m_axi_ruser                         : STD_LOGIC_VECTOR(1 - 1 DOWNTO 0);
 SIGNAL m_axi_rvalid                        : STD_LOGIC;
 SIGNAL m_axi_rready                        : STD_LOGIC;
 
 SIGNAL vfifo_mm2s_channel_full             : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
 SIGNAL vfifo_s2mm_channel_full             : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
 SIGNAL vfifo_mm2s_channel_empty            : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
 
 SIGNAL vfifo_idle                          : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);


 SIGNAL m_axis_1_tready                     : STD_LOGIC;
 SIGNAL m_axis_1_tvalid                     : STD_LOGIC;
 SIGNAL m_axis_1_tlast                      : STD_LOGIC;
 SIGNAL m_axis_1_tdata                      : STD_LOGIC_VECTOR(256 - 1 downto 0);
 SIGNAL m_axis_1_tstrb                      : STD_LOGIC_VECTOR(256/8 - 1 downto 0);
 SIGNAL m_axis_1_tkeep                      : STD_LOGIC_VECTOR(256/8 - 1 downto 0);
 SIGNAL m_axis_1_tuser                      : STD_LOGIC_VECTOR(1 - 1 downto 0);
 SIGNAL m_axis_1_tid                        : STD_LOGIC_VECTOR(1 - 1 downto 0);
 SIGNAL m_axis_1_tdest                      : STD_LOGIC_VECTOR(1 - 1 downto 0);
 SIGNAL s_axis_1_tready                     : STD_LOGIC;
 SIGNAL s_axis_1_tvalid                     : STD_LOGIC;
 SIGNAL s_axis_1_tlast                      : STD_LOGIC;
 SIGNAL s_axis_1_tdata                      : STD_LOGIC_VECTOR(256-1 downto 0);
 SIGNAL s_axis_1_tstrb                      : STD_LOGIC_VECTOR(256/8 - 1 downto 0);
 SIGNAL s_axis_1_tkeep                      : STD_LOGIC_VECTOR(256/8 - 1 downto 0);
 SIGNAL s_axis_1_tuser                      : STD_LOGIC_VECTOR(1 - 1 downto 0);
 SIGNAL s_axis_1_tid                        : STD_LOGIC_VECTOR(1 - 1 downto 0);
 SIGNAL s_axis_1_tdest                      : STD_LOGIC_VECTOR(1 - 1 downto 0);
 SIGNAL axis_err_count                      : STD_LOGIC_VECTOR(15 downto 0);
 
 SIGNAL m_axi_lite_ch1_awaddr               : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_awprot               : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_awvalid              : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_awready              : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_wdata                : STD_LOGIC_VECTOR(32-1 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_wstrb                : STD_LOGIC_VECTOR(32/8-1 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_wvalid               : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_wready               : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_bresp                : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_bvalid               : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_bready               : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_araddr               : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_arvalid              : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_arready              : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_rdata                : STD_LOGIC_VECTOR(32-1 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_rvalid               : STD_LOGIC := '0';
 SIGNAL m_axi_lite_ch1_rresp                : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
 SIGNAL m_axi_lite_ch1_rready               : STD_LOGIC := '0';
 SIGNAL lite_gen_status                     : STD_LOGIC_VECTOR(31 downto 0);
 SIGNAL aclk_i 			            : STD_LOGIC;

-----------------------------------------------------------------------------

  COMPONENT axi_vfifo_ctrl_0 IS
    PORT (
 
     -- AXI Stream Input Signals From Switch to AXI Virtual FIFO Controller (AVFC)
     S_AXIS_TVALID                       : IN  STD_LOGIC := '0';
     S_AXIS_TREADY                       : OUT STD_LOGIC := '0';
     S_AXIS_TDATA                        : IN  STD_LOGIC_VECTOR(256 - 1 DOWNTO 0)   := (OTHERS =>'0');
     S_AXIS_TSTRB                        : IN  STD_LOGIC_VECTOR(256/8 - 1 DOWNTO 0) := (OTHERS =>'0');
     S_AXIS_TKEEP                        : IN  STD_LOGIC_VECTOR(256/8 - 1 DOWNTO 0) := (OTHERS =>'0');
     S_AXIS_TLAST                        : IN  STD_LOGIC := '0';
     S_AXIS_TID                          : IN  STD_LOGIC_VECTOR(1 - 1 DOWNTO 0)   := (OTHERS =>'0');
     S_AXIS_TDEST                        : IN  STD_LOGIC_VECTOR(1 - 1 DOWNTO 0)   := (OTHERS =>'0');
 
     -- AXI Virtual FIFO Controller (AVFC) Output Signals To AXI Stream Switch
     M_AXIS_TVALID                       : OUT STD_LOGIC := '0';
     M_AXIS_TREADY                       : IN  STD_LOGIC := '0';
     M_AXIS_TDATA                        : OUT STD_LOGIC_VECTOR(256 - 1 DOWNTO 0)   := (OTHERS => '0');
     M_AXIS_TSTRB                        : OUT STD_LOGIC_VECTOR(256/8 - 1 DOWNTO 0) := (OTHERS => '1');
     M_AXIS_TKEEP                        : OUT STD_LOGIC_VECTOR(256/8 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXIS_TLAST                        : OUT STD_LOGIC := '0';
     M_AXIS_TID                          : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0)   := (OTHERS => '0');
     M_AXIS_TDEST                        : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0)   := (OTHERS => '0');
 
     -- Write Address Channel Signals
     M_AXI_AWID                          : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWADDR                        : OUT STD_LOGIC_VECTOR(32 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWLEN                         : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWSIZE                        : OUT STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWBURST                       : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWLOCK                        : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWCACHE                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWPROT                        : OUT STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWQOS                         : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWREGION                      : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWUSER                        : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_AWVALID                       : OUT STD_LOGIC := '0';
     M_AXI_AWREADY                       : IN  STD_LOGIC := '0';
 
     -- Write Data Channel Signals
     M_AXI_WDATA                         : OUT STD_LOGIC_VECTOR(256 - 1 DOWNTO 0)     := (OTHERS => '0');
     M_AXI_WSTRB                         : OUT STD_LOGIC_VECTOR(256 / 8 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_WLAST                         : OUT STD_LOGIC := '0';
     M_AXI_WUSER                         : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_WVALID                        : OUT STD_LOGIC := '0';
     M_AXI_WREADY                        : IN  STD_LOGIC := '0';
 
     -- Write Response Channel Signals
     M_AXI_BID                           : IN  STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS =>'0');
     M_AXI_BRESP                         : IN  STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS =>'0');
     M_AXI_BUSER                         : IN  STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS =>'0');
     M_AXI_BVALID                        : IN  STD_LOGIC := '0';
     M_AXI_BREADY                        : OUT STD_LOGIC := '1';
 
     -- Read Address Channel Signals
     M_AXI_ARID                          : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARADDR                        : OUT STD_LOGIC_VECTOR(32 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARLEN                         : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARSIZE                        : OUT STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARBURST                       : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARLOCK                        : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARCACHE                       : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARPROT                        : OUT STD_LOGIC_VECTOR(3 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARQOS                         : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARREGION                      : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARUSER                        : OUT STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS => '0');
     M_AXI_ARVALID                       : OUT STD_LOGIC := '0';
     M_AXI_ARREADY                       : IN  STD_LOGIC := '0';
 
     -- Read Data Channel Signals
     M_AXI_RID                           : IN  STD_LOGIC_VECTOR(1 - 1 DOWNTO 0)   := (OTHERS =>'0');
     M_AXI_RDATA                         : IN  STD_LOGIC_VECTOR(256 - 1 DOWNTO 0) := (OTHERS =>'0');
     M_AXI_RRESP                         : IN  STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS =>'0');
     M_AXI_RLAST                         : IN  STD_LOGIC := '0';
     M_AXI_RUSER                         : IN  STD_LOGIC_VECTOR(1 - 1 DOWNTO 0) := (OTHERS =>'0');
     M_AXI_RVALID                        : IN  STD_LOGIC := '0';
     M_AXI_RREADY                        : OUT STD_LOGIC := '0';
 
     -- External Interface Signals
     VFIFO_MM2S_CHANNEL_FULL             : IN  STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS =>'0');
     VFIFO_S2MM_CHANNEL_FULL             : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS =>'0');
     VFIFO_MM2S_CHANNEL_EMPTY            : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS =>'1');

     -- Status Signal
     VFIFO_IDLE                          : OUT STD_LOGIC_VECTOR(2 - 1 DOWNTO 0) := (OTHERS =>'1');
 
 
     -- Global Signals
     ACLK                                : IN  STD_LOGIC := '0';
     ARESETN                             : IN  STD_LOGIC := '0'
   );

  END COMPONENT;

  COMPONENT bram_memory
  PORT (
  s_axi_aclk       : IN STD_LOGIC;
  s_axi_aresetn    : IN STD_LOGIC;
  s_axi_awid       : IN STD_LOGIC_VECTOR(1-1 DOWNTO 0);
  s_axi_awaddr     : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
  s_axi_awlen      : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  s_axi_awsize     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
  s_axi_awburst    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
  s_axi_awlock     : IN STD_LOGIC;
  s_axi_awcache    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  s_axi_awprot     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
  s_axi_awvalid    : IN STD_LOGIC;
  s_axi_awready    : OUT STD_LOGIC;
  s_axi_wdata      : IN STD_LOGIC_VECTOR(256-1 DOWNTO 0);
  s_axi_wstrb      : IN STD_LOGIC_VECTOR(256/8 - 1 DOWNTO 0);
  s_axi_wlast      : IN STD_LOGIC;
  s_axi_wvalid     : IN STD_LOGIC;
  s_axi_wready     : OUT STD_LOGIC;
  s_axi_bid        : OUT STD_LOGIC_VECTOR(1-1 DOWNTO 0);
  s_axi_bresp      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
  s_axi_bvalid     : OUT STD_LOGIC;
  s_axi_bready     : IN STD_LOGIC;
  s_axi_arid       : IN STD_LOGIC_VECTOR(1-1 DOWNTO 0);
  s_axi_araddr     : IN STD_LOGIC_VECTOR(14  DOWNTO 0);
  s_axi_arlen      : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  s_axi_arsize     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
  s_axi_arburst    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
  s_axi_arlock     : IN STD_LOGIC;
  s_axi_arcache    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  s_axi_arprot     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
  s_axi_arvalid    : IN STD_LOGIC;
  s_axi_arready    : OUT STD_LOGIC;
  s_axi_rid        : OUT STD_LOGIC_VECTOR(1-1 DOWNTO 0);
  s_axi_rdata      : OUT STD_LOGIC_VECTOR(256-1 DOWNTO 0);
  s_axi_rresp      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
  s_axi_rlast      : OUT STD_LOGIC;
  s_axi_rvalid     : OUT STD_LOGIC;
  s_axi_rready     : IN STD_LOGIC
  );
  END COMPONENT;
  
  COMPONENT atg_lite_agent
  PORT (
    s_axi_aclk             : IN STD_LOGIC;
    s_axi_aresetn          : IN STD_LOGIC;
    m_axi_lite_ch1_awaddr  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_lite_ch1_awprot  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_lite_ch1_awvalid : OUT STD_LOGIC;
    m_axi_lite_ch1_awready : IN STD_LOGIC;
    m_axi_lite_ch1_wdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_lite_ch1_wstrb   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_lite_ch1_wvalid  : OUT STD_LOGIC;
    m_axi_lite_ch1_wready  : IN STD_LOGIC;
    m_axi_lite_ch1_bresp   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_lite_ch1_bvalid  : IN STD_LOGIC;
    m_axi_lite_ch1_bready  : OUT STD_LOGIC;
    m_axi_lite_ch1_araddr  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_lite_ch1_arvalid : OUT STD_LOGIC;
    m_axi_lite_ch1_arready : IN STD_LOGIC;
    m_axi_lite_ch1_rvalid  : IN STD_LOGIC;
    m_axi_lite_ch1_rready  : OUT STD_LOGIC;
    m_axi_lite_ch1_rdata   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_lite_ch1_rresp   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    done                   : OUT STD_LOGIC;
    status                 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
  END COMPONENT;

  COMPONENT atg_stream_agent
    PORT (
    s_axi_aclk                 : IN STD_LOGIC;
    s_axi_aresetn              : IN STD_LOGIC;
    s_axi_awid                 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_awaddr               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_awlen                : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_awsize               : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_awburst              : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_awlock               : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_awcache              : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_awprot               : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_awqos                : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_awuser               : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_awvalid              : IN STD_LOGIC;
    s_axi_awready              : OUT STD_LOGIC;
    s_axi_wlast                : IN STD_LOGIC;
    s_axi_wdata                : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wstrb                : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wvalid               : IN STD_LOGIC;
    s_axi_wready               : OUT STD_LOGIC;
    s_axi_bid                  : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_bresp                : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid               : OUT STD_LOGIC;
    s_axi_bready               : IN STD_LOGIC;
    s_axi_arid                 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_araddr               : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_arlen                : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_arsize               : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_arburst              : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_arlock               : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_arcache              : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_arprot               : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_arqos                : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_aruser               : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_arvalid              : IN STD_LOGIC;
    s_axi_arready              : OUT STD_LOGIC;
    s_axi_rid                  : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_rlast                : OUT STD_LOGIC;
    s_axi_rdata                : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp                : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid               : OUT STD_LOGIC;
    s_axi_rready               : IN STD_LOGIC;
    m_axis_1_tready            : IN STD_LOGIC;
    m_axis_1_tvalid            : OUT STD_LOGIC;
    m_axis_1_tlast             : OUT STD_LOGIC;
    m_axis_1_tdata             : OUT STD_LOGIC_VECTOR(256-1 DOWNTO 0);
    m_axis_1_tstrb             : OUT STD_LOGIC_VECTOR(256/8-1 DOWNTO 0);
    m_axis_1_tkeep             : OUT STD_LOGIC_VECTOR(256/8-1 DOWNTO 0);
    m_axis_1_tuser             : OUT STD_LOGIC_VECTOR(1-1 DOWNTO 0);
    m_axis_1_tid               : OUT STD_LOGIC_VECTOR(1-1 DOWNTO 0);
    m_axis_1_tdest             : OUT STD_LOGIC_VECTOR(1-1 DOWNTO 0);
    s_axis_1_tready            : OUT STD_LOGIC;
    s_axis_1_tvalid            : IN STD_LOGIC;
    s_axis_1_tlast             : IN STD_LOGIC;
    s_axis_1_tdata             : IN STD_LOGIC_VECTOR(256-1 DOWNTO 0);
    s_axis_1_tstrb             : IN STD_LOGIC_VECTOR(256/8-1 DOWNTO 0);
    s_axis_1_tkeep             : IN STD_LOGIC_VECTOR(256/8-1 DOWNTO 0);
    s_axis_1_tuser             : IN STD_LOGIC_VECTOR(1-1 DOWNTO 0);
    s_axis_1_tid               : IN STD_LOGIC_VECTOR(1-1 DOWNTO 0);
    s_axis_1_tdest             : IN STD_LOGIC_VECTOR(1-1 DOWNTO 0);
    axis_err_count          : OUT STD_LOGIC_VECTOR(15 downto 0);
    core_ext_start             : IN STD_LOGIC;
    core_ext_stop              : IN STD_LOGIC
    );
  END COMPONENT;

BEGIN

    aclk_buf: bufg
    PORT MAP(
      i => aclk,
      o => aclk_i
    );

  vfifo_mm2s_channel_full <= (others => '0');
  test_status             <= lite_gen_status(1 downto 0) & OR_REDUCE(axis_err_count);
  out_pkt 		  <= s_axis_1_tvalid AND s_axis_1_tready AND s_axis_1_tlast; 
  in_pkt 		  <= m_axis_1_tvalid AND m_axis_1_tready AND m_axis_1_tlast;

  axi_vfifo_ctrl_0_inst : axi_vfifo_ctrl_0
    PORT MAP (
      S_AXIS_TVALID                       => m_axis_1_tvalid,
      S_AXIS_TREADY                       => m_axis_1_tready,
      S_AXIS_TDATA                        => m_axis_1_tdata,
      S_AXIS_TSTRB                        => m_axis_1_tstrb,
      S_AXIS_TKEEP                        => m_axis_1_tkeep,
      S_AXIS_TLAST                        => m_axis_1_tlast,
      S_AXIS_TID                          => m_axis_1_tid,
      S_AXIS_TDEST                        => m_axis_1_tdest,

      M_AXIS_TVALID                       => s_axis_1_tvalid,
      M_AXIS_TREADY                       => s_axis_1_tready,
      M_AXIS_TDATA                        => s_axis_1_tdata,
      M_AXIS_TSTRB                        => s_axis_1_tstrb,
      M_AXIS_TKEEP                        => s_axis_1_tkeep,
      M_AXIS_TLAST                        => s_axis_1_tlast,
      M_AXIS_TID                          => s_axis_1_tid,
      M_AXIS_TDEST                        => s_axis_1_tdest,

      M_AXI_AWID                          => m_axi_awid,
      M_AXI_AWADDR                        => m_axi_awaddr,
      M_AXI_AWLEN                         => m_axi_awlen,
      M_AXI_AWSIZE                        => m_axi_awsize,
      M_AXI_AWBURST                       => m_axi_awburst,
      M_AXI_AWLOCK                        => m_axi_awlock,
      M_AXI_AWCACHE                       => m_axi_awcache,
      M_AXI_AWPROT                        => m_axi_awprot,
      M_AXI_AWQOS                         => m_axi_awqos,
      M_AXI_AWREGION                      => m_axi_awregion,
      M_AXI_AWUSER                        => m_axi_awuser,
      M_AXI_AWVALID                       => m_axi_awvalid,
      M_AXI_AWREADY                       => m_axi_awready,

      M_AXI_WDATA                         => m_axi_wdata,
      M_AXI_WSTRB                         => m_axi_wstrb,
      M_AXI_WLAST                         => m_axi_wlast,
      M_AXI_WUSER                         => m_axi_wuser,
      M_AXI_WVALID                        => m_axi_wvalid,
      M_AXI_WREADY                        => m_axi_wready,

      M_AXI_BID                           => m_axi_bid,
      M_AXI_BRESP                         => m_axi_bresp,
      M_AXI_BUSER                         => m_axi_buser,
      M_AXI_BVALID                        => m_axi_bvalid,
      M_AXI_BREADY                        => m_axi_bready,

      M_AXI_ARID                          => m_axi_arid,
      M_AXI_ARADDR                        => m_axi_araddr,
      M_AXI_ARLEN                         => m_axi_arlen,
      M_AXI_ARSIZE                        => m_axi_arsize,
      M_AXI_ARBURST                       => m_axi_arburst,
      M_AXI_ARLOCK                        => m_axi_arlock,
      M_AXI_ARCACHE                       => m_axi_arcache,
      M_AXI_ARPROT                        => m_axi_arprot,
      M_AXI_ARQOS                         => m_axi_arqos,
      M_AXI_ARREGION                      => m_axi_arregion,
      M_AXI_ARUSER                        => m_axi_aruser,
      M_AXI_ARVALID                       => m_axi_arvalid,
      M_AXI_ARREADY                       => m_axi_arready,

      M_AXI_RID                           => m_axi_rid,
      M_AXI_RDATA                         => m_axi_rdata,
      M_AXI_RRESP                         => m_axi_rresp,
      M_AXI_RLAST                         => m_axi_rlast,
      M_AXI_RUSER                         => m_axi_ruser,
      M_AXI_RVALID                        => m_axi_rvalid,
      M_AXI_RREADY                        => m_axi_rready,

      -- External Interface Signals
      VFIFO_MM2S_CHANNEL_FULL             => vfifo_mm2s_channel_full,
      VFIFO_MM2S_CHANNEL_EMPTY            => vfifo_mm2s_channel_empty,
      VFIFO_S2MM_CHANNEL_FULL             => vfifo_s2mm_channel_full,

      -- Status Signal
      VFIFO_IDLE                          => vfifo_idle,


      ACLK                                => aclk_i,
      ARESETN                             => aresetn
    );

    bram_memory_inst : bram_memory
        PORT MAP (
         s_axi_aclk => aclk_i,
         s_axi_aresetn => aresetn,
         s_axi_awid    => (others => '0'),
         s_axi_awaddr  => m_axi_awaddr(14 downto 0),
         s_axi_awlen   => m_axi_awlen,
         s_axi_awsize  => m_axi_awsize,
         s_axi_awburst => m_axi_awburst,
         s_axi_awlock  => '0', 
         s_axi_awcache => m_axi_awcache,
         s_axi_awprot  => m_axi_awprot,
         s_axi_awvalid => m_axi_awvalid,
         s_axi_awready => m_axi_awready,
         s_axi_wdata   => m_axi_wdata,
         s_axi_wstrb   => m_axi_wstrb,
         s_axi_wlast   => m_axi_wlast,
         s_axi_wvalid  => m_axi_wvalid,
         s_axi_wready  => m_axi_wready,
         s_axi_bid     => open,
         s_axi_bresp   => m_axi_bresp,
         s_axi_bvalid  => m_axi_bvalid,
         s_axi_bready  => m_axi_bready,
         s_axi_arid    => (others => '0'),
         s_axi_araddr  => m_axi_araddr(14 downto 0),
         s_axi_arlen   => m_axi_arlen,
         s_axi_arsize  => m_axi_arsize,
         s_axi_arburst => m_axi_arburst,
         s_axi_arlock  => '0',
         s_axi_arcache => m_axi_arcache,
         s_axi_arprot  => m_axi_arprot,
         s_axi_arvalid => m_axi_arvalid,
         s_axi_arready => m_axi_arready,
         s_axi_rid     => open,
         s_axi_rdata   => m_axi_rdata,
         s_axi_rresp   => m_axi_rresp,
         s_axi_rlast   => m_axi_rlast,
         s_axi_rvalid  => m_axi_rvalid,
         s_axi_rready  => m_axi_rready
       );

   lite_agent_inst: atg_lite_agent
     PORT MAP (
       s_axi_aclk             => aclk_i,
       s_axi_aresetn          => aresetn,
       m_axi_lite_ch1_awaddr  => m_axi_lite_ch1_awaddr,
       m_axi_lite_ch1_awprot  => m_axi_lite_ch1_awprot,
       m_axi_lite_ch1_awvalid => m_axi_lite_ch1_awvalid,
       m_axi_lite_ch1_awready => m_axi_lite_ch1_awready,
       m_axi_lite_ch1_wdata   => m_axi_lite_ch1_wdata,
       m_axi_lite_ch1_wstrb   => m_axi_lite_ch1_wstrb,
       m_axi_lite_ch1_wvalid  => m_axi_lite_ch1_wvalid,
       m_axi_lite_ch1_wready  => m_axi_lite_ch1_wready,
       m_axi_lite_ch1_bresp   => m_axi_lite_ch1_bresp,
       m_axi_lite_ch1_bvalid  => m_axi_lite_ch1_bvalid,
       m_axi_lite_ch1_bready  => m_axi_lite_ch1_bready,
       m_axi_lite_ch1_araddr  => m_axi_lite_ch1_araddr,
       m_axi_lite_ch1_arvalid => m_axi_lite_ch1_arvalid,
       m_axi_lite_ch1_arready => m_axi_lite_ch1_arready,
       m_axi_lite_ch1_rdata   => m_axi_lite_ch1_rdata,
       m_axi_lite_ch1_rvalid  => m_axi_lite_ch1_rvalid,
       m_axi_lite_ch1_rready  => m_axi_lite_ch1_rready,
       m_axi_lite_ch1_rresp   => m_axi_lite_ch1_rresp,
       done                   => done,
       status                 => lite_gen_status
    );
  
   stream_agent_inst: atg_stream_agent
    PORT MAP
   (
     s_axi_aclk => aclk_i,
     s_axi_aresetn => aresetn,
     s_axi_awid => (others => '0'),
     s_axi_awaddr => m_axi_lite_ch1_awaddr,
     s_axi_awlen => (others => '0'),
     s_axi_awsize => STD_LOGIC_VECTOR(to_unsigned(2, 3)),
     s_axi_awburst => STD_LOGIC_VECTOR(to_unsigned(1, 2)),
     s_axi_awlock => (others => '0'),
     s_axi_awcache => (others => '0'),
     s_axi_awprot => (others => '0'),
     s_axi_awqos => (others => '0'),
     s_axi_awuser => (others => '0'),
     s_axi_awvalid => m_axi_lite_ch1_awvalid,
     s_axi_awready => m_axi_lite_ch1_awready,
     s_axi_wlast => '1',
     s_axi_wdata => m_axi_lite_ch1_wdata,
     s_axi_wstrb => m_axi_lite_ch1_wstrb,
     s_axi_wvalid => m_axi_lite_ch1_wvalid,
     s_axi_wready => m_axi_lite_ch1_wready,
     s_axi_bid => open,
     s_axi_bresp => m_axi_lite_ch1_bresp,
     s_axi_bvalid => m_axi_lite_ch1_bvalid,
     s_axi_bready => m_axi_lite_ch1_bready,
     s_axi_arid =>  (others => '0'),
     s_axi_araddr => m_axi_lite_ch1_araddr,
     s_axi_arlen => (others => '0'),
     s_axi_arsize => STD_LOGIC_VECTOR(to_unsigned(2, 3)),
     s_axi_arburst => STD_LOGIC_VECTOR(to_unsigned(1, 2)),
     s_axi_arlock => (others => '0'),
     s_axi_arcache => (others => '0'),
     s_axi_arprot => (others => '0'),
     s_axi_arqos => (others => '0'),
     s_axi_aruser => (others => '0'),
     s_axi_arvalid => m_axi_lite_ch1_arvalid,
     s_axi_arready => m_axi_lite_ch1_arready,
     s_axi_rid => open,
     s_axi_rlast => open,
     s_axi_rdata => m_axi_lite_ch1_rdata,
     s_axi_rresp => m_axi_lite_ch1_rresp,
     s_axi_rvalid => m_axi_lite_ch1_rvalid,
     s_axi_rready => m_axi_lite_ch1_rready,
     m_axis_1_tready => m_axis_1_tready,
     m_axis_1_tvalid => m_axis_1_tvalid,
     m_axis_1_tlast => m_axis_1_tlast,
     m_axis_1_tdata => m_axis_1_tdata,
     m_axis_1_tstrb => m_axis_1_tstrb,
     m_axis_1_tkeep => m_axis_1_tkeep,
     m_axis_1_tuser => m_axis_1_tuser,
     m_axis_1_tid => m_axis_1_tid,
     m_axis_1_tdest => m_axis_1_tdest,
     s_axis_1_tready => s_axis_1_tready,
     s_axis_1_tvalid => s_axis_1_tvalid,
     s_axis_1_tlast => s_axis_1_tlast,
     s_axis_1_tdata => s_axis_1_tdata,
     s_axis_1_tstrb => s_axis_1_tstrb,
     s_axis_1_tkeep => s_axis_1_tkeep,
     s_axis_1_tuser => (others => '0'),
     s_axis_1_tid => s_axis_1_tid,
     s_axis_1_tdest => s_axis_1_tdest,
     axis_err_count => axis_err_count,
     core_ext_start => '0',
     core_ext_stop  => '0'
   );


end arch_axi_vfifo_ctrl_0_exdes;
