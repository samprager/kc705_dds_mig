/*
 * Created by 
   realTimeFpga.exe 11.3_xilinx-p002 on Mon Jun 13 14:28:44 2016
 * (c) Xilinx, Inc.
 */

module keep_new(IBus, OBus);
   input [0:1]IBus;
   output [0:1]OBus;

   BUF assign_buf_10000 (.O(OBus[0]), .I(IBus[0]));
   BUF assign_buf_10001 (.O(OBus[1]), .I(IBus[1]));

endmodule
