`timescale 1ns/1ps

module accumulator_tb;

  // ============================
  // PARAMETERS
  // ============================
  localparam int DATA_WIDTH    = 16;
  localparam int TAP           = 11;
  localparam int PAIR          = TAP/2;
  localparam int PAIR_WIDTH    = DATA_WIDTH + 1;
  localparam int COEF_WIDTH    = 16;
  localparam int PRODUCT_WIDTH = PAIR_WIDTH + COEF_WIDTH;
  localparam int SUM_WIDTH     = PRODUCT_WIDTH + $clog2(PAIR+1);

  // ============================
  // TESTBENCH SIGNALS
  // ============================
  logic signed [PRODUCT_WIDTH-1:0] tb_product [0:PAIR];
  logic signed [SUM_WIDTH-1:0]     tb_sum;

  // ============================
  // DUT
  // ============================
  accumulator #(
    .DATA_WIDTH    (DATA_WIDTH),
    .TAP           (TAP),
    .PAIR_WIDTH    (PAIR_WIDTH),
    .PAIR          (PAIR),
    .COEF_WIDTH    (COEF_WIDTH),
    .PRODUCT_WIDTH (PRODUCT_WIDTH),
    .SUM_WIDTH     (SUM_WIDTH)
  ) dut (
    .i_product (tb_product),
    .o_sum     (tb_sum)
  );

  // ============================
  // CHECK TASK
  // ============================
  task check(string name);
    int i;
    logic signed [SUM_WIDTH-1:0] expected;

    begin
      expected = 0;

      for (i = 0; i <= PAIR; i++) begin
        expected += tb_product[i];
      end

      if (tb_sum === expected) begin
        $display("PASS: %s | sum = %0d", name, tb_sum);
      end else begin
        $display("FAIL: %s | expected = %0d, got = %0d",
                  name, expected, tb_sum);
      end
    end
  endtask

  // ============================
  // MAIN TEST
  // ============================
  initial begin
    int i;
    int test_id;

    $display("START ACCUMULATOR TEST");

    // run 10 test cases
    repeat (10) begin

      // random input
      for (i = 0; i <= PAIR; i++) begin
        tb_product[i] = $random >>> 24;
      end

      #1;

      // unique test name
      test_id++;
      check($sformatf("RANDOM_TEST_%0d", test_id));

    end

    $display("END TEST");
    $finish;
  end

endmodule