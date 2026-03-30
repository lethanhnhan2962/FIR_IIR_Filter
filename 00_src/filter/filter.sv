module filter #(
  parameter int DATA_WIDTH    = 16,
  parameter int TAP           = 63,
  parameter int PAIR_WIDTH    = DATA_WIDTH + 1,
  parameter int PAIR          = TAP / 2,
  parameter int COEF_WIDTH    = 16,
  parameter int PRODUCT_WIDTH = PAIR_WIDTH + COEF_WIDTH,
  parameter int SUM_WIDTH     = PRODUCT_WIDTH + $clog2(PAIR + 1)
)(
  // Global clock and active-low reset
  input  logic               i_clk,
  input  logic               i_rst_n,
  
  // Wave generator control
  input  logic [ 2:0] i_wave_sel,
  input  logic        i_inc_btn,
  input  logic        i_dec_btn,
  input  logic [ 1:0] i_wave_ctrl,
  input  logic        i_noise_en,

  // Audio control
  input  logic        i_audio_sel,
  input  logic [15:0] i_audio_data,
  
  // Filter enable
  input  logic [ 1:0] i_filter_en,

  // output data
  output logic [15:0] o_data
);

  // ---------------------------------------------------------
  // 1. WAVE GENERATOR
  // ---------------------------------------------------------
  logic signed [15:0] wave_data;

  wave_gen u_wave_gen (
    .i_clk       (i_clk),
    .i_rst_n     (i_rst_n),
    .i_wave_sel  (i_wave_sel),
    .i_inc_btn   (i_inc_btn),
    .i_dec_btn   (i_dec_btn),
    .i_wave_ctrl (i_wave_ctrl),
    .i_noise_en  (i_noise_en),
    .o_wave_data (wave_data)
  );
  
  // ---------------------------------------------------------
  // 2. WAVE GENERATOR
  // ---------------------------------------------------------
  logic signed [15:0] sample;
  
  assign sample = (i_audio_sel) ? i_audio_data : wave_data;
  
  // ---------------------------------------------------------
  // 3. CLOCK DIVIDER
  // ---------------------------------------------------------
  logic clk_1mhz;
  logic clk_48khz;
  
  clk_div u_clk_div (
    .i_clk       (i_clk),
    .i_rst_n     (i_rst_n),
    .o_clk_1mhz  (clk_1mhz),
    .o_clk_48khz (clk_48khz)
  );
  
  // ---------------------------------------------------------
  // 4. SYMMETRIC FIR
  // ---------------------------------------------------------
  logic signed [15:0] fir_data;

  symmetric_fir #(
    .DATA_WIDTH    (DATA_WIDTH),
    .TAP           (TAP),
    .PAIR_WIDTH    (PAIR_WIDTH),
    .PAIR          (PAIR),
    .COEF_WIDTH    (COEF_WIDTH),
    .PRODUCT_WIDTH (PRODUCT_WIDTH),
    .SUM_WIDTH     (SUM_WIDTH)
  ) u_symmetric_fir (
    .i_sample_clk (clk_48khz),
    .i_rst_n      (i_rst_n),
    .i_sample     (sample),
    .o_fir_data   (fir_data)
  );

  // ---------------------------------------------------------
  // 5. IIR
  // ---------------------------------------------------------
  logic signed [15:0] iir_data;
  
  assign iir_data = 16'b0;
  
  // ---------------------------------------------------------
  // 6. MUX 3-1 16 bit
  // ---------------------------------------------------------
  mux4to1_16b u_mux4to1_16b (
    .i_sel (i_filter_en),
    .i_d0  (sample),
    .i_d1  (fir_data),
    .i_d2  (iir_data),
    .i_d3  (16'd0),
    .o_y   (o_data)
  );

endmodule
