`timescale 1ps/100fs

module sim_tb_packetizer;

   localparam AXI_TCLK_PERIOD          = 8000;         // 125 MHz
  localparam RESET_PERIOD = 320000; //in pSec  

    reg axi_tresetn_i;
    reg axi_tclk_i;
    
   wire                   axi_tclk;
   wire                   axi_tresetn;
  
     // data from ADC Data fifo
  reg       [7:0]                    adc_axis_tdata_reg;
  reg                                adc_axis_tvalid_reg;
  reg                                adc_axis_tlast_reg;
  reg                                adc_axis_tuser_reg;
  
         // data from ADC Data fifo
wire       [7:0]                    adc_axis_tdata;
wire                                adc_axis_tvalid;
wire                                adc_axis_tlast;
wire                                adc_axis_tuser;

 wire                               adc_axis_tready;
  
 
 wire  [7:0]       tdata;
 wire              tvalid;
 wire              tlast;
 wire              tready;
 
 reg                tready_reg;
 reg                adc_axis_tvalid_select;
 //**************************************************************************//
  // Reset Generation
  //**************************************************************************//
  initial begin
    axi_tresetn_i = 1'b0;
    #RESET_PERIOD
      axi_tresetn_i = 1'b1;
   end

  //**************************************************************************//
  // Clock Generation
  //**************************************************************************//

  initial 
    begin
        axi_tclk_i = 1'b0;
    end
  always 
    begin
        axi_tclk_i = #(AXI_TCLK_PERIOD/2.0) ~axi_tclk_i;
    end
    
    
   assign axi_tresetn = axi_tresetn_i;
   assign axi_tclk = axi_tclk_i;
   
        
 initial begin
      tready_reg = 1'b1; // initial value
      @(posedge axi_tresetn_i); // wait for reset
      tready_reg = 1'b0;
      repeat(32) @(posedge axi_tclk_i);
      tready_reg = 1'b1;
      repeat(256) @(posedge axi_tclk_i);
      tready_reg = 1'b0;
      repeat(32) @(posedge axi_tclk_i);
      tready_reg = 1'b0;
      repeat(1) @(posedge axi_tclk_i);
      tready_reg = 1'b1;
      repeat(3) @(posedge axi_tclk_i);
      tready_reg = 1'b0;
      repeat(1) @(posedge axi_tclk_i);
      tready_reg = 1'b1;
      repeat(2) @(posedge axi_tclk_i);
      tready_reg = 1'b0;  
      repeat(1) @(posedge axi_tclk_i);
      tready_reg = 1'b1;
      repeat(1) @(posedge axi_tclk_i);
      tready_reg = 1'b0; 
      repeat(256) @(posedge axi_tclk_i);
      tready_reg = 1'b1;        
      repeat(2048) @(posedge axi_tclk_i);
      $finish;
    end     
 
 always @(posedge  axi_tclk_i) begin
    if (~axi_tresetn_i) begin
        adc_axis_tdata_reg <= 'b0;
        adc_axis_tvalid_reg <= 1'b0;
        adc_axis_tlast_reg <= 1'b0;
        adc_axis_tuser_reg <= 1'b0;
    end else begin
        adc_axis_tvalid_reg <= 1'b1;
        if (adc_axis_tready & adc_axis_tvalid)
            adc_axis_tdata_reg <= adc_axis_tdata_reg + 1'b1;
        if (&adc_axis_tdata_reg[5:0])
            adc_axis_tlast_reg <= 1'b1;
        else    
            adc_axis_tlast_reg <= 1'b0;     
    end
end
        
 initial begin
     adc_axis_tvalid_select = 1'b0; // initial value
     @(posedge axi_tresetn_i); // wait for reset
     adc_axis_tvalid_select = 1'b1;
     repeat(150) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b0;
     repeat(32) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b1;
     repeat(1) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b1;
     repeat(3) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b0;
     repeat(1) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b1;
     repeat(2) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b0;  
     repeat(1) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b1;
     repeat(1) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b0; 
     repeat(20) @(posedge axi_tclk_i);
     adc_axis_tvalid_select = 1'b1;        
   end         
  
kc705_ethernet_rgmii_axi_packetizer u_packetizer_top
(
       .axi_tclk (axi_tclk),
       .axi_tresetn (axi_tresetn),

        .enable_adc_pkt (1'b1),
        .speed  (2'b10),

    // data from ADC Data fifo
        .adc_axis_tdata               (adc_axis_tdata), 
        .adc_axis_tvalid              (adc_axis_tvalid), 
        .adc_axis_tlast              (adc_axis_tlast),
        .adc_axis_tuser          (adc_axis_tuser),
        .adc_axis_tready              (adc_axis_tready),

        .tdata       (tdata),
        .tvalid       (tvalid),
        .tlast       (tlast),
        .tready       (tready)
);

assign tready = tready_reg;
assign adc_axis_tdata =  adc_axis_tdata_reg;
assign adc_axis_tvalid =  adc_axis_tvalid_reg & adc_axis_tvalid_select;
assign adc_axis_tlast =  adc_axis_tlast_reg;
assign adc_axis_tuser =  adc_axis_tuser_reg;


  
  
endmodule