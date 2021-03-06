##################################################################################################
## 
##  Xilinx, Inc. 2010            www.xilinx.com 
##  Fri Jun 17 10:48:19 2016
##  Generated by MIG Version 2.1
##  
##################################################################################################
##  File name :       example_top.sdc
##  Details :     Constraints file
##                    FPGA Family:       KINTEX7
##                    FPGA Part:         XC7K410TFFG900_PKG
##                    Speedgrade:        -2
##                    Design Entry:      VERILOG
##                    Frequency:         800 MHz
##                    Time Period:       1250 ps
##################################################################################################

##################################################################################################
## Controller 0
## Memory Device: DDR3_SDRAM->SODIMMs->MT8JTF12864HZ-1G6
## Data Width: 64
## Time Period: 1250
## Data Mask: 1
##################################################################################################

#create_clock -name sys_clk_i -period 5 [get_ports sys_clk_i]
#set_propagated_clock sys_clk_i
          
############## NET - IOSTANDARD ##################


