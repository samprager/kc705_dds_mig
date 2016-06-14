`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/27/2016 02:25:19 PM
// Design Name:
// Module Name: adc_data_axis_wrapper
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module adc_data_axis_wrapper #(
  parameter ADC_AXI_DATA_WIDTH = 64,
  parameter ADC_AXI_TID_WIDTH = 1,
  parameter ADC_AXI_TDEST_WIDTH = 1,
  parameter ADC_AXI_TUSER_WIDTH = 1,
  parameter ADC_AXI_STREAM_ID = 1'b0,
  parameter ADC_AXI_STREAM_DEST = 1'b0
)(
  input                               axi_tclk,
  input                               axi_tresetn,

  input [ADC_AXI_DATA_WIDTH-1:0]            adc_data,
  input                                     adc_fifo_data_valid,
  input                                     adc_fifo_empty,
  input                                     adc_fifo_almost_empty,
  output                                    adc_fifo_rd_en,

  output [ADC_AXI_DATA_WIDTH-1:0]       tdata,
  output                                    tvalid,
  output reg                                tlast = 1'b1,
  output reg [ADC_AXI_DATA_WIDTH/8-1:0]     tkeep = {ADC_AXI_DATA_WIDTH/8{1'b1}},
  output reg [ADC_AXI_DATA_WIDTH/8-1:0]     tstrb = {ADC_AXI_DATA_WIDTH/8{1'b1}},
  output reg [ADC_AXI_TID_WIDTH-1:0]        tid = ADC_AXI_STREAM_ID[ADC_AXI_TID_WIDTH-1:0],
  output reg [ADC_AXI_TDEST_WIDTH-1:0]      tdest = ADC_AXI_STREAM_DEST[ADC_AXI_TDEST_WIDTH-1:0],
  output reg [ADC_AXI_TUSER_WIDTH-1:0]      tuser = {ADC_AXI_TUSER_WIDTH{1'b0}},

  input                                   tready
 );

// localparam   IDLE        = 1'b0,
//              DATA      =   1'b1;

//wire                       axi_treset;
//reg [15:0]                 total_count;        // counter for 64 bit words
//reg [15:0]                 current_count;
//reg                        state;
//reg                        next_state;
reg                        tvalid_int;
//reg                        adc_fifo_data_valid_int;


assign axi_treset = !axi_tresetn;
assign adc_fifo_rd_en = tready;

//assign tvalid = adc_fifo_data_valid;
assign tvalid = tvalid_int;
assign tdata = adc_data; 

always @(posedge axi_tclk)
begin
    if (axi_treset) 
        tvalid_int <= 1'b0;
    else    
        tvalid_int <= (tready & !adc_fifo_empty)|(!tready & tvalid_int);
end   
/*
always @(posedge axi_tclk)
begin
  tid <= ADC_AXI_STREAM_ID[ADC_AXI_TID_WIDTH-1:0];
  tdest <= ADC_AXI_STREAM_DEST[ADC_AXI_TDEST_WIDTH-1:0];
  tkeep <= {ADC_AXI_DATA_WIDTH/8{1'b1}};
  tuser <= {ADC_AXI_TUSER_WIDTH{1'b0}};
  tstrb <= {ADC_AXI_DATA_WIDTH/8{1'b1}};
end
*/

//// need a packet counter - max size limited to 11 bits
//always @(posedge axi_tclk)
//begin
//   if (axi_treset) begin
//      total_count <= 0;
//      current_count <= 0;
//   end
//   else begin
//      total_count <= total_count+1;
//      if (adc_fifo_data_valid)
//        current_count <= current_count +1;
//      else
//        current_count <= 0;
//  end
//end
 

//// simple state machine to control the data
//// on the transition from IDLE we reset the counters and increment the packet size
//always @(state or tready or adc_fifo_empty)
//begin
//   next_state = state;
//   case (state)
//      IDLE : begin
//         if (tready & !adc_fifo_empty)
//            next_state = DATA;
//      end
//      DATA : begin
//         // when an AVB AV channel we want to keep valid asserted to indicate a continuous feed of data
//         //   the AVB module is then enitirely resposible for the bandwidth
//         if (!tready | adc_fifo_empty) begin
//            next_state = IDLE;
//         end
//      end
//      default : begin
//         next_state = IDLE;
//      end
//   endcase
//end

//always @(posedge axi_tclk)
//begin
//   if (axi_treset) begin
//      state <= IDLE;
//   end
//   else begin
//   state <= next_state;
//   end
//end

//// now generate the TVALID output
//always @(posedge axi_tclk)
//begin
//   if (axi_treset)
//      tvalid_int <= 0;
//   else if (state == DATA & tready & adc_fifo_data_valid)
//      tvalid_int <= 1;
//   else if (tready)
//      tvalid_int <= 0;
//end

//// now generate the TDATA output
//always @(posedge axi_tclk)
//begin
//   if (state == DATA & tready  & adc_fifo_data_valid)
//      tdata <= adc_data;
//end


//// now generate the TLAST output
//always @(posedge axi_tclk)
//begin
//   if (axi_treset)
//      tlast <= 0;
//   else if (state == DATA & tready  & adc_fifo_data_valid)
//      tlast <= 1;
//   else if (tready)
//      tlast <= 0;
//end

//assign tvalid = tvalid_int;


endmodule
