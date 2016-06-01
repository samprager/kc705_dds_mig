-- (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
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
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:axi_vfifo_ctrl:2.0
-- IP Revision: 5

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY axi_vfifo_ctrl_v2_0;
USE axi_vfifo_ctrl_v2_0.axi_vfifo_ctrl_v2_0;

ENTITY axi_vfifo_ctrl_0 IS
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    s_axis_tstrb : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    s_axis_tkeep : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    s_axis_tid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axis_tdest : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    m_axis_tstrb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tkeep : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC;
    m_axis_tid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_tdest : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_awid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_awlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_awregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_awuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_awvalid : OUT STD_LOGIC;
    m_axi_awready : IN STD_LOGIC;
    m_axi_wdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    m_axi_wstrb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axi_wlast : OUT STD_LOGIC;
    m_axi_wuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_wvalid : OUT STD_LOGIC;
    m_axi_wready : IN STD_LOGIC;
    m_axi_bid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_buser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_bvalid : IN STD_LOGIC;
    m_axi_bready : OUT STD_LOGIC;
    m_axi_arid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_arlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_arlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_arregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_aruser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_arvalid : OUT STD_LOGIC;
    m_axi_arready : IN STD_LOGIC;
    m_axi_rid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_rdata : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_rlast : IN STD_LOGIC;
    m_axi_ruser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_rvalid : IN STD_LOGIC;
    m_axi_rready : OUT STD_LOGIC;
    vfifo_mm2s_channel_full : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    vfifo_s2mm_channel_full : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    vfifo_mm2s_channel_empty : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    vfifo_idle : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END axi_vfifo_ctrl_0;

ARCHITECTURE axi_vfifo_ctrl_0_arch OF axi_vfifo_ctrl_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : string;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF axi_vfifo_ctrl_0_arch: ARCHITECTURE IS "yes";

  COMPONENT axi_vfifo_ctrl_v2_0 IS
    GENERIC (
      C_FAMILY : STRING;
      C_DRAM_BASE_ADDR : STRING;
      C_HAS_AXIS_TUSER : INTEGER;
      C_AXIS_TDATA_WIDTH : INTEGER;
      C_AXIS_TUSER_WIDTH : INTEGER;
      C_AXIS_TID_WIDTH : INTEGER;
      C_AXI_BURST_SIZE : INTEGER;
      C_AXI_ADDR_WIDTH : INTEGER;
      C_NUM_CHANNEL : INTEGER;
      C_NUM_PAGE_CH0 : INTEGER;
      C_NUM_PAGE_CH1 : INTEGER;
      C_NUM_PAGE_CH2 : INTEGER;
      C_NUM_PAGE_CH3 : INTEGER;
      C_NUM_PAGE_CH4 : INTEGER;
      C_NUM_PAGE_CH5 : INTEGER;
      C_NUM_PAGE_CH6 : INTEGER;
      C_NUM_PAGE_CH7 : INTEGER;
      C_IMPLEMENTATION_TYPE : INTEGER;
      C_HAS_AXIS_TID : INTEGER;
      C_ENABLE_INTERRUPT : INTEGER;
      C_AR_WEIGHT_CH0 : INTEGER;
      C_AR_WEIGHT_CH1 : INTEGER;
      C_AR_WEIGHT_CH2 : INTEGER;
      C_AR_WEIGHT_CH3 : INTEGER;
      C_AR_WEIGHT_CH4 : INTEGER;
      C_AR_WEIGHT_CH5 : INTEGER;
      C_AR_WEIGHT_CH6 : INTEGER;
      C_AR_WEIGHT_CH7 : INTEGER;
      C_DEASSERT_TREADY : INTEGER;
      C_S2MM_TXN_TIMEOUT_VAL : INTEGER
    );
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axis_tvalid : IN STD_LOGIC;
      s_axis_tready : OUT STD_LOGIC;
      s_axis_tdata : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
      s_axis_tstrb : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_tkeep : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_tlast : IN STD_LOGIC;
      s_axis_tid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axis_tdest : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axis_tuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_tvalid : OUT STD_LOGIC;
      m_axis_tready : IN STD_LOGIC;
      m_axis_tdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
      m_axis_tstrb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_tkeep : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_tlast : OUT STD_LOGIC;
      m_axis_tid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_tdest : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_tuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_awid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_awlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC;
      m_axi_awready : IN STD_LOGIC;
      m_axi_wdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_wlast : OUT STD_LOGIC;
      m_axi_wuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_wvalid : OUT STD_LOGIC;
      m_axi_wready : IN STD_LOGIC;
      m_axi_bid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_buser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC;
      m_axi_bready : OUT STD_LOGIC;
      m_axi_arid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_arlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_arlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_aruser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC;
      m_axi_arready : IN STD_LOGIC;
      m_axi_rid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_rdata : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_rlast : IN STD_LOGIC;
      m_axi_ruser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_rvalid : IN STD_LOGIC;
      m_axi_rready : OUT STD_LOGIC;
      vfifo_mm2s_channel_full : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      vfifo_s2mm_channel_full : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      vfifo_mm2s_channel_empty : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      vfifo_mm2s_rresp_err_intr : OUT STD_LOGIC;
      vfifo_s2mm_bresp_err_intr : OUT STD_LOGIC;
      vfifo_s2mm_overrun_err_intr : OUT STD_LOGIC;
      vfifo_idle : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
  END COMPONENT axi_vfifo_ctrl_v2_0;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 AXI_CLOCK CLK";
  ATTRIBUTE X_INTERFACE_INFO OF aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 AXI_RESETN RST";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tid: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axis_tdest: SIGNAL IS "xilinx.com:interface:axis:1.0 S_AXIS TDEST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tid: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tdest: SIGNAL IS "xilinx.com:interface:axis:1.0 M_AXIS TDEST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awlen: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWLEN";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awsize: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awburst: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWBURST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awlock: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWLOCK";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awcache: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWCACHE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awqos: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWQOS";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awregion: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWREGION";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awuser: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWUSER";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_wlast: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI WLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_wuser: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI WUSER";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_bid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI BID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_buser: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI BUSER";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arlen: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARLEN";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arsize: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arburst: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARBURST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arlock: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARLOCK";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arcache: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARCACHE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arqos: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARQOS";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arregion: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARREGION";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_aruser: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARUSER";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_rid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI RID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_rlast: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI RLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_ruser: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI RUSER";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 M_AXI RREADY";
BEGIN
  U0 : axi_vfifo_ctrl_v2_0
    GENERIC MAP (
      C_FAMILY => "kintex7",
      C_DRAM_BASE_ADDR => "80000000",
      C_HAS_AXIS_TUSER => 0,
      C_AXIS_TDATA_WIDTH => 512,
      C_AXIS_TUSER_WIDTH => 1,
      C_AXIS_TID_WIDTH => 1,
      C_AXI_BURST_SIZE => 1024,
      C_AXI_ADDR_WIDTH => 32,
      C_NUM_CHANNEL => 2,
      C_NUM_PAGE_CH0 => 8192,
      C_NUM_PAGE_CH1 => 8192,
      C_NUM_PAGE_CH2 => 2048,
      C_NUM_PAGE_CH3 => 2048,
      C_NUM_PAGE_CH4 => 2048,
      C_NUM_PAGE_CH5 => 2048,
      C_NUM_PAGE_CH6 => 2048,
      C_NUM_PAGE_CH7 => 2048,
      C_IMPLEMENTATION_TYPE => 1,
      C_HAS_AXIS_TID => 1,
      C_ENABLE_INTERRUPT => 0,
      C_AR_WEIGHT_CH0 => 8,
      C_AR_WEIGHT_CH1 => 8,
      C_AR_WEIGHT_CH2 => 8,
      C_AR_WEIGHT_CH3 => 8,
      C_AR_WEIGHT_CH4 => 8,
      C_AR_WEIGHT_CH5 => 8,
      C_AR_WEIGHT_CH6 => 8,
      C_AR_WEIGHT_CH7 => 8,
      C_DEASSERT_TREADY => 0,
      C_S2MM_TXN_TIMEOUT_VAL => 64
    )
    PORT MAP (
      aclk => aclk,
      aresetn => aresetn,
      s_axis_tvalid => s_axis_tvalid,
      s_axis_tready => s_axis_tready,
      s_axis_tdata => s_axis_tdata,
      s_axis_tstrb => s_axis_tstrb,
      s_axis_tkeep => s_axis_tkeep,
      s_axis_tlast => s_axis_tlast,
      s_axis_tid => s_axis_tid,
      s_axis_tdest => s_axis_tdest,
      s_axis_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(1, 1)),
      m_axis_tvalid => m_axis_tvalid,
      m_axis_tready => m_axis_tready,
      m_axis_tdata => m_axis_tdata,
      m_axis_tstrb => m_axis_tstrb,
      m_axis_tkeep => m_axis_tkeep,
      m_axis_tlast => m_axis_tlast,
      m_axis_tid => m_axis_tid,
      m_axis_tdest => m_axis_tdest,
      m_axi_awid => m_axi_awid,
      m_axi_awaddr => m_axi_awaddr,
      m_axi_awlen => m_axi_awlen,
      m_axi_awsize => m_axi_awsize,
      m_axi_awburst => m_axi_awburst,
      m_axi_awlock => m_axi_awlock,
      m_axi_awcache => m_axi_awcache,
      m_axi_awprot => m_axi_awprot,
      m_axi_awqos => m_axi_awqos,
      m_axi_awregion => m_axi_awregion,
      m_axi_awuser => m_axi_awuser,
      m_axi_awvalid => m_axi_awvalid,
      m_axi_awready => m_axi_awready,
      m_axi_wdata => m_axi_wdata,
      m_axi_wstrb => m_axi_wstrb,
      m_axi_wlast => m_axi_wlast,
      m_axi_wuser => m_axi_wuser,
      m_axi_wvalid => m_axi_wvalid,
      m_axi_wready => m_axi_wready,
      m_axi_bid => m_axi_bid,
      m_axi_bresp => m_axi_bresp,
      m_axi_buser => m_axi_buser,
      m_axi_bvalid => m_axi_bvalid,
      m_axi_bready => m_axi_bready,
      m_axi_arid => m_axi_arid,
      m_axi_araddr => m_axi_araddr,
      m_axi_arlen => m_axi_arlen,
      m_axi_arsize => m_axi_arsize,
      m_axi_arburst => m_axi_arburst,
      m_axi_arlock => m_axi_arlock,
      m_axi_arcache => m_axi_arcache,
      m_axi_arprot => m_axi_arprot,
      m_axi_arqos => m_axi_arqos,
      m_axi_arregion => m_axi_arregion,
      m_axi_aruser => m_axi_aruser,
      m_axi_arvalid => m_axi_arvalid,
      m_axi_arready => m_axi_arready,
      m_axi_rid => m_axi_rid,
      m_axi_rdata => m_axi_rdata,
      m_axi_rresp => m_axi_rresp,
      m_axi_rlast => m_axi_rlast,
      m_axi_ruser => m_axi_ruser,
      m_axi_rvalid => m_axi_rvalid,
      m_axi_rready => m_axi_rready,
      vfifo_mm2s_channel_full => vfifo_mm2s_channel_full,
      vfifo_s2mm_channel_full => vfifo_s2mm_channel_full,
      vfifo_mm2s_channel_empty => vfifo_mm2s_channel_empty,
      vfifo_idle => vfifo_idle
    );
END axi_vfifo_ctrl_0_arch;
