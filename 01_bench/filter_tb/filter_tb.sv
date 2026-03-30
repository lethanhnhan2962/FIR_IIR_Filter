`timescale 1ns/1ps

module filter_tb;

  // ============================
  // SIGNALS
  // ============================
  logic        tb_clk;
  logic        tb_rst_n;
  logic [ 2:0] tb_wave_sel;
  logic        tb_inc_btn;
  logic        tb_dec_btn;
  logic [ 1:0] tb_wave_ctrl;
  logic        tb_noise_en;
  logic        tb_audio_sel;
  logic [15:0] tb_audio_data;
  logic [ 1:0] tb_filter_en;
  logic [15:0] tb_data;

  // ============================
  // DUT
  // ============================
  filter u_dut (
    .i_clk        (tb_clk),
    .i_rst_n      (tb_rst_n),
    .i_wave_sel   (tb_wave_sel),
    .i_inc_btn    (tb_inc_btn),
    .i_dec_btn    (tb_dec_btn),
    .i_wave_ctrl  (tb_wave_ctrl),
    .i_noise_en   (tb_noise_en),
    .i_audio_sel  (tb_audio_sel),
    .i_audio_data (tb_audio_data),
    .i_filter_en  (tb_filter_en),
    .o_data       (tb_data)
  );

  // ============================
  // CLOCK (50 MHz)
  // ============================
  initial tb_clk = 0;
  always #10 tb_clk = ~tb_clk;

  // ============================
  // TASK: BUTTON PRESS
  // ============================
  task press_btn_inc();
    begin
      tb_inc_btn = 1;
      repeat (5) @(posedge tb_clk);
      tb_inc_btn = 0;
    end
  endtask

  task press_btn_dec();
    begin
      tb_dec_btn = 1;
      repeat (5) @(posedge tb_clk);
      tb_dec_btn = 0;
    end
  endtask

  // ============================
  // TEST
  // ============================
  initial begin
    // init
    tb_inc_btn    = 0;
    tb_dec_btn    = 0;
    tb_wave_ctrl  = 0;
    tb_audio_data = 0;

    // reset
    tb_rst_n = 0;
    #100;
    tb_rst_n = 1;

    // ============================
    // TESTCASE 1: Sine wave
    // Sweep f from 1kHz to 10kHz
    // ============================
    tb_wave_sel   = 3'd1;   // Sine
    tb_noise_en   = 1;
    tb_audio_sel  = 0;
    tb_filter_en  = 2'b01;  // FIR
    tb_wave_ctrl  = 2'b01;  // Adjust frequency
    repeat (10) begin
      #(1_000_000); // 1 ms
      press_btn_inc();
    end

    // ============================
    // TESTCASE 2: Square wave (duty cycle = 50%)
    // Sweep f from 1kHz to 10kHz
    // ============================
    tb_wave_sel   = 3'd2;   // Square
    tb_noise_en   = 1;
    tb_audio_sel  = 0;
    tb_filter_en  = 2'b01;  // FIR
    tb_wave_ctrl  = 2'b01;  // Adjust frequency
    repeat (10) begin
      #(1_000_000); // 1 ms
      press_btn_inc();
    end

    // ============================
    // TESTCASE 3: Trianle wave
    // Sweep f from 1kHz to 10kHz
    // ============================
    tb_wave_sel   = 3'd3;   // Triangle
    tb_noise_en   = 1;
    tb_audio_sel  = 0;
    tb_filter_en  = 2'b01;  // FIR
    tb_wave_ctrl  = 2'b01;  // Adjust frequency
    repeat (10) begin
      #(1_000_000); // 1 ms
      press_btn_inc();
    end

    // ============================
    // TESTCASE 4: Sawtooth wave
    // Sweep f from 1kHz to 10kHz
    // ============================
    tb_wave_sel   = 3'd4;   // Sawtoooth
    tb_noise_en   = 1;
    tb_audio_sel  = 0;
    tb_filter_en  = 2'b01;  // FIR
    tb_wave_ctrl  = 2'b01;  // Adjust frequency
    repeat (10) begin
      #(1_000_000); // 1 ms
      press_btn_inc();
    end

    // ============================
    // TESTCASE 5: ECG wave
    // Sweep f from 1kHz to 10kHz
    // ============================
    tb_wave_sel   = 3'd5;   // ECG 
    tb_noise_en   = 1;
    tb_audio_sel  = 0;
    tb_filter_en  = 2'b01;  // FIR
    tb_wave_ctrl  = 2'b01;  // Adjust frequency
    repeat (10) begin
      #(1_000_000); // 1 ms
      press_btn_inc();
    end

    $finish;
  end

endmodule
