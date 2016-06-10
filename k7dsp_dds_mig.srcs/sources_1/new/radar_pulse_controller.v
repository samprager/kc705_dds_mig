`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MiXIL
// Engineer: Samuel Prager
//
// Create Date: 06/8/2016 02:25:19 PM
// Design Name:
// Module Name: radar_pulse_controller
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
module radar_pulse_controller #(
  parameter CLK_FREQ = 200,    // MHz
  parameter CHIRP_PRP = 1000000 //Pule Repetition Period (usec)
)(
  input aclk,
  input aresetn,

  // input gpio_sw_c,
  // input gpio_sw_e,
  // input gpio_sw_n,
  // input gpio_sw_s,
  // input gpio_sw_w,
  // input [7:0]  gpio_dip_sw,
  // output [7:0]  gpio_led,

//  input clk_mig,              // 200 MHZ OR 100 MHz
//  input mig_init_calib_complete,

  input clk_fmc150,           // 245.76 MHz
  input fmc150_status_vector, // {pll_status, mmcm_adac_locked, mmcm_locked, ADC_calibration_good};

  input chirp_ready,          // continuous high when dac ready
  input chirp_active,         // continuous high while chirping
  input chirp_done,           // single pulse when chirp finished
  output chirp_init,          // single pulse to initiate chirp
  output chirp_enable,        // continuous high while chirp enabled
  output adc_enable,          // high while adc samples saved

  input clk_eth,              // gtx_clk : 125 MHz
  input data_tx_ready,        // high when ready to transmit
  input data_tx_active,       // high while data being transmitted
  input data_tx_done,         // single pule when done transmitting
  output data_tx_init,        // single pulse to start tx data
  output data_tx_enable      // continuous high while transmit enabled

);

localparam CHIRP_PRF_COUNT = CLK_FREQ*CHIRP_PRP;
localparam ADC_LIMIT = 2000;
localparam     IDLE        = 3'b000,
               ACTIVE      = 3'b001,
               CHIRP       = 3'b010,    // pulse chirp (and generate adc samples)
               COLLECT     = 3'b011,    // continue to collect adc samples
               PROCESS     = 3'b100,    // process adc samples
               WAIT        = 3'b101,    // wait to transmit samples
               TRANSMIT    = 3'b110,    // transmitting samples over ethernet
               OVERHEAD    = 3'b111;    // clean up before idle

reg [2:0] next_gen_state;
reg [2:0] gen_state;

reg [31:0] chirp_count;
reg [3:0] overhead_count;
reg [31:0] adc_collect_count;
reg [31:0] process_count;

reg chirp_ready_int;
reg chirp_active_int;
reg chirp_done_int;
reg chirp_init_int;
reg chirp_enable_int;
reg adc_enable_int;

reg data_tx_ready_int;
reg data_tx_active_int;
reg data_tx_done_int;
reg data_tx_init_int;
reg data_tx_enable_int;


always @(posedge aclk)
begin
  if(~aresetn)
    chirp_count <= 0;
  else if (gen_state == ACTIVE & (|chirp_count))
    chirp_count <= chirp_count - 1;
  else if (gen_state == IDLE)
    chirp_count <= CHIRP_PRF_COUNT;
end

always @(posedge aclk)
begin
  if(~aresetn)
    adc_collect_count <= 0;
  else if (gen_state == COLLECT & (|adc_collect_count))
    adc_collect_count <= adc_collect_count - 1;
  else if (gen_state == IDLE)
    adc_collect_count <= ADC_LIMIT;
end

always @(posedge aclk)
begin
  if(~aresetn)
    process_count <= 0;
  else if (gen_state == PROCESS & (|process_count))
    process_count <= process_count - 1;
  else if (gen_state == IDLE)
    process_count <= 2;
end

always @(posedge aclk)
begin
  if(~aresetn)
    overhead_count <= 0;
  else if (gen_state == OVERHEAD & (|overhead_count))
    overhead_count <= overhead_count - 1;
  else if (gen_state == IDLE)
    overhead_count <= 2;
end

always @(gen_state or chirp_count or chirp_done or chirp_ready or
          data_tx_ready or data_tx_done or overhead_count or
          fmc150_status_vector or adc_collect_count or process_count)
begin
   next_gen_state = gen_state;
   case (gen_state)
      IDLE : begin
         if (chirp_ready & (&fmc150_status_vector))
            next_gen_state = ACTIVE;
      end
      ACTIVE : begin
         if (chirp_ready & (chirp_count == 0) & (&fmc150_status_vector))
            next_gen_state = CHIRP;
      end
      CHIRP : begin
         if (chirp_done)
            next_gen_state = COLLECT;
      end
      COLLECT : begin
         if (adc_collect_count == 1)
            next_gen_state = PROCESS;
      end
      PROCESS : begin
         if (process_count == 1) begin
            //next_gen_state = WAIT;
            next_gen_state = OVERHEAD;
         end
      end
      // Skip Transmit Control for now
      WAIT : begin
         if (data_tx_ready) begin
            next_gen_state = TRANSMIT;
         end
      end
      TRANSMIT : begin
         if (data_tx_done) begin
            next_gen_state = OVERHEAD;
         end
      end
      OVERHEAD : begin
         if (overhead_count == 1) begin
            next_gen_state = IDLE;
         end
      end
      default : begin
         next_gen_state = IDLE;
      end
   endcase
end

always @(posedge aclk)
begin
   if (~aresetn) begin
      gen_state <= IDLE;
   end
   else begin
   gen_state <= next_gen_state;
   end
end

always @(posedge clk_fmc150)
begin
  if(~aresetn)
    chirp_enable_int <= 1'b0;
  else if (gen_state ==  CHIRP)
    chirp_enable_int <= 1'b1;
  else
    chirp_enable_int <= 1'b0;
end

always @(posedge clk_fmc150)
begin
  if(~aresetn)
    chirp_init_int <= 1'b0;
  else if (gen_state ==  CHIRP & !chirp_active)
    chirp_init_int <= 1'b1;
  else
    chirp_init_int <= 1'b0;
end

always @(posedge clk_fmc150)
begin
  if(~aresetn)
    adc_enable_int <= 1'b0;
  else if (gen_state == CHIRP | gen_state == COLLECT)
    adc_enable_int <= 1'b1;
  else
    adc_enable_int <= 1'b0;
end

always @(posedge clk_eth)
begin
  if(~aresetn)
    data_tx_enable_int <= 1'b0;
  else if (gen_state == TRANSMIT)
    data_tx_enable_int <= 1'b1;
  else
    data_tx_enable_int <= 1'b0;
end

always @(posedge clk_eth)
begin
  if(~aresetn)
    data_tx_init_int <= 1'b0;
  else if (gen_state == TRANSMIT & !data_tx_active)
    data_tx_init_int <= 1'b1;
  else
    data_tx_init_int <= 1'b0;
end

assign chirp_enable = chirp_enable_int;
assign chirp_init = chirp_init_int;
assign adc_enable = adc_enable_int;
assign data_tx_enable = data_tx_enable_int;
assign data_tx_init = data_tx_init_int;

endmodule
