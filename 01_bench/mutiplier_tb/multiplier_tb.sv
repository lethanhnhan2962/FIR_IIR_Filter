`timescale 1ns/1ps

module multiplier_tb;

  // ============================
  // PARAMETERS (SMALL CONFIG)
  // ============================
  localparam int DATA_WIDTH    = 16;
  localparam int TAP           = 3;
  localparam int PAIR_WIDTH    = DATA_WIDTH + 1;
  localparam int PAIR          = TAP/2;
  localparam int COEF_WIDTH    = 16;
  localparam int PRODUCT_WIDTH = PAIR_WIDTH + COEF_WIDTH;

  // ============================
  // TESTBENCH SIGNALS
  // ============================
  logic signed [PAIR_WIDTH-1:0]    tb_pair_sum [0:PAIR];
  logic signed [COEF_WIDTH-1:0]    tb_coef     [0:PAIR];
  logic signed [PRODUCT_WIDTH-1:0] tb_product  [0:PAIR];

  // ============================
  // DUT INSTANCE
  // ============================
  multiplier #(
    .DATA_WIDTH    (DATA_WIDTH),
    .TAP           (TAP),
    .PAIR_WIDTH    (PAIR_WIDTH),
    .PAIR          (PAIR),
    .COEF_WIDTH    (COEF_WIDTH),
    .PRODUCT_WIDTH (PRODUCT_WIDTH)
  ) dut (
    .i_pair_sum (tb_pair_sum),
    .i_coef     (tb_coef),
    .o_product  (tb_product)
  );

  // ============================
  // CHECK TASK
  // ============================
  task check(string test_name);
    int i;
    logic signed [PRODUCT_WIDTH-1:0] expected;
    begin
      for (i = 0; i <= PAIR; i++) begin
        expected = tb_pair_sum[i] * tb_coef[i];

        if (tb_product[i] === expected) begin
          $display("PASS: %s index=%0d", test_name, i);
        end else begin
          $display("FAIL: %s index=%0d", test_name, i);
        end
      end
    end
  endtask

  // ============================
  // MAIN TEST
  // ============================
  initial begin
    $display("START MULTIPLIER TEST");

    // --------------------------------
    // Test 1: positive * positive
    // --------------------------------
    tb_pair_sum[0] = 10;
    tb_pair_sum[1] = 20;

    tb_coef[0] = 3;
    tb_coef[1] = 4;

    #10;
    check("POS_POS");

    // --------------------------------
    // Test 2: negative * negative
    // --------------------------------
    tb_pair_sum[0] = -15;
    tb_pair_sum[1] = -5;

    tb_coef[0] = -2;
    tb_coef[1] = -3;

    #10;
    check("NEG_NEG");

    // --------------------------------
    // Test 3: positive * negative
    // --------------------------------
    tb_pair_sum[0] = 25;
    tb_pair_sum[1] = -8;

    tb_coef[0] = -6;
    tb_coef[1] = 7;

    #10;
    check("POS_NEG");

    // --------------------------------
    // Test 4: random values
    // --------------------------------
    tb_pair_sum[0] = $random;
    tb_pair_sum[1] = $random;

    tb_coef[0] = $random;
    tb_coef[1] = $random;

    #10;
    check("RANDOM");

    $display("END TEST");
    $finish;
  end

endmodule
