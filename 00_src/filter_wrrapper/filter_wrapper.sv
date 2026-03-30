module filter_wrapper (
  input  logic       clk,
  input  logic [1:0] key,
  input  logic [6:0] sw,
  output logic [6:0] led,
  
  // AUDIO CODEC
  inout  wire AUD_BCLK,
  output wire AUD_DACDAT,
  inout  wire AUD_DACLRCK,
  inout  wire AUD_ADCLRCK,
  input  wire AUD_ADCDAT,
  output wire AUD_XCK,

  // I2C
  inout  wire I2C_SDAT,
  output wire I2C_SCLK
);

  //---------------------------
  // RESET
  //---------------------------
  logic rst_n;
  
  assign rst_n = sw[0];
  assign led   = sw;

  //---------------------------
  // PLL
  //---------------------------
  logic audio_mclk;

  clock_pll u_clock_pll (
      .refclk   (clk),
      .rst      (rst_n),
      .outclk_0 (audio_mclk)
  );
  
  assign AUD_XCK = audio_mclk;

  //---------------------------
  // I2C CONFIG
  //---------------------------
  i2c_av_config u_config (
      .clk      (clk),
      .reset    (rst_n),
      .i2c_sclk (I2C_SCLK),
      .i2c_sdat (I2C_SDAT),
      .status   ()
  );

  //---------------------------
  // AUDIO CODEC I/O
  //---------------------------
  logic [ 1:0] sample_req;
  wire  [15:0] codec_data_in;
  logic [23:0] wave_data;

  audio_codec u_audio_codec (
      .clk          (clk),
      .reset        (rst_n),
      .sample_req   (sample_req),
      .audio_output (wave_data[15:0]),
      .audio_input  (codec_data_in),
      .channel_sel  (2'b10),
      .AUD_ADCLRCK  (AUD_ADCLRCK),
      .AUD_ADCDAT   (AUD_ADCDAT),
      .AUD_DACLRCK  (AUD_DACLRCK),
      .AUD_DACDAT   (AUD_DACDAT),
      .AUD_BCLK     (AUD_BCLK)
  );

  //---------------------------
  // WAVE GENERATOR
  //---------------------------
  filter u_filter (
    .i_clk        (clk),
    .i_rst_n      (rst_n),
    .i_wave_sel   (sw[3:1]),
    .i_inc_btn    (key[1]),
    .i_dec_btn    (key[0]),
    .i_wave_ctrl  (sw[5:4]),
    .i_noise_en   (sw[6]),
    .o_wave_data  (wave_data)
  );

endmodule