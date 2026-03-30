`timescale 1ns/1ps

module delay_line_tb;

  localparam DATA_WIDTH  = 16;
  localparam TAP         = 63;

  // -------------------------------------
  // DUT signals
  // -------------------------------------
  logic                          tb_clk;
  logic                          tb_rst_n;
  logic signed [DATA_WIDTH-1:0]  tb_sample;
  logic signed [DATA_WIDTH-1:0]  tb_delay_sample [0:TAP-1];

  // -------------------------------------
  // DUT instance
  // -------------------------------------
  delay_line #(
    .DATA_WIDTH(DATA_WIDTH),
    .TAP(TAP)
  ) dut (
    .i_clk          (tb_clk),
    .i_rst_n        (tb_rst_n),
    .i_sample       (tb_sample),
    .o_delay_sample (tb_delay_sample)
  );

  // -------------------------------------
  // Clock: 20 ns period
  // -------------------------------------
  initial begin
    tb_clk = 0;
    forever #10 tb_clk = ~tb_clk;
  end

  // -------------------------------------
  // Test process
  // -------------------------------------
  initial begin
    $display("=== FIR Delay Line Testbench Start ===");
    $dumpfile("delay_line_tb.vcd");
    $dumpvars(0, delay_line_tb);

    // INIT
    tb_rst_n  = 0;
    tb_sample = 0;
    #100

    // Hold reset
    tb_rst_n = 1;

    // Random sample each cycle
    repeat (100) begin
      @(posedge tb_clk);
      tb_sample <= $urandom_range(0, 255);
    end

    $display("=== FIR Delay Line Testbench End ===");
    $stop;
  end

endmodule


