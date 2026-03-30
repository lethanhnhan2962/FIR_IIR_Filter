`timescale 1ns/1ps

module pre_adder_tb;

  // ============================
  // PARAMETERS
  // ============================
  localparam int DATA_WIDTH = 16;
  localparam int TAP        = 3;
  localparam int PAIR_WIDTH = DATA_WIDTH + 1;
  localparam int PAIR       = TAP/2; // = 1

  // ============================
  // TESTBENCH SIGNALS
  // ============================
  logic signed [DATA_WIDTH-1:0] tb_delay_sample [0:TAP-1];
  logic signed [PAIR_WIDTH-1:0] tb_pair_sum     [0:PAIR];

  // ============================
  // DUT INSTANCE
  // ============================
  pre_adder #(
    .DATA_WIDTH (DATA_WIDTH),
    .TAP        (TAP),
    .PAIR_WIDTH (PAIR_WIDTH),
    .PAIR       (PAIR)
  ) dut (
    .i_delay_sample (tb_delay_sample),
    .o_pair_sum     (tb_pair_sum)
  );

  // ============================
  // CHECK FUNCTION
  // ============================
  task check(string test_name);
    logic signed [PAIR_WIDTH-1:0] expected;
    begin
      // Compute expected result
      expected = tb_delay_sample[0] + tb_delay_sample[2];

      // Compare result
      if (tb_pair_sum[0] == expected) begin
        $display("PASS: %s", test_name);
      end else begin
        $display("FAIL: %s", test_name);
      end
    end
  endtask

  // ============================
  // MAIN TEST SEQUENCE
  // ============================
  initial begin
    $display("START TEST");

    // Test 1: positive + positive
    tb_delay_sample[0] = 10;
    tb_delay_sample[1] = 0;
    tb_delay_sample[2] = 20;
    #1;
    check("POS_POS");

    // Test 2: negative + negative
    tb_delay_sample[0] = -15;
    tb_delay_sample[2] = -5;
    #1;
    check("NEG_NEG");

    // Test 3: positive + negative
    tb_delay_sample[0] = 30;
    tb_delay_sample[2] = -10;
    #1;
    check("POS_NEG");

    // Test 4: negative + positive
    tb_delay_sample[0] = -25;
    tb_delay_sample[2] = 40;
    #1;
    check("NEG_POS");

    // Test 5: overflow case
    tb_delay_sample[0] = 32767;
    tb_delay_sample[2] = 1;
    #1;
    check("OVERFLOW");

    $display("END TEST");
    $finish;
  end

endmodule
