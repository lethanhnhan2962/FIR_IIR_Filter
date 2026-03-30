module symmetric_fir #(
  parameter int DATA_WIDTH    = 16,
  parameter int TAP           = 63,
  parameter int PAIR_WIDTH    = DATA_WIDTH + 1,
  parameter int PAIR          = TAP / 2,
  parameter int COEF_WIDTH    = 16,
  parameter int PRODUCT_WIDTH = PAIR_WIDTH + COEF_WIDTH,
  parameter int SUM_WIDTH     = PRODUCT_WIDTH + $clog2(PAIR+1)
)(
  input  logic                         i_sample_clk,
  input  logic                         i_rst_n,
  input  logic signed [DATA_WIDTH-1:0] i_sample,
  output logic signed [DATA_WIDTH-1:0] o_fir_data
);

  genvar i;

  // =============================================
  // 1. DELAY LINE
  // =============================================
  logic signed [DATA_WIDTH-1:0] delay_sample[0:TAP-1];

  delay_line #(
    .DATA_WIDTH     (DATA_WIDTH),
	 .TAP            (TAP)
  ) u_delay_line (
    .i_clk          (i_sample_clk),
    .i_rst_n        (i_rst_n),
    .i_sample       (i_sample),
    .o_delay_sample (delay_sample)
  );

  // =============================================
  // 2. PRE-ADDER
  // =============================================
  logic signed [PAIR_WIDTH-1:0] pair_sum[0:PAIR];

  pre_adder #(
    .DATA_WIDTH     (DATA_WIDTH),
    .TAP            (TAP),
    .PAIR_WIDTH     (PAIR_WIDTH),
    .PAIR           (PAIR)
  ) u_pre_adder (
    .i_delay_sample (delay_sample),
    .o_pair_sum     (pair_sum)
  );

  // =============================================
  // 3. COEFFICIENT ROM
  // =============================================
  logic signed [COEF_WIDTH-1:0] coef[0:PAIR];

  coef_rom u_coef_rom (
    .o_coef  (coef)
  );

  // =============================================
  // 4. MULTIPLIER
  // =============================================
  logic signed [PRODUCT_WIDTH-1:0] product[0:PAIR];

  multiplier #(
    .DATA_WIDTH    (DATA_WIDTH),
    .TAP           (TAP),
	 .PAIR_WIDTH    (PAIR_WIDTH),
	 .PAIR          (PAIR),
	 .COEF_WIDTH    (COEF_WIDTH),
    .PRODUCT_WIDTH (PRODUCT_WIDTH)
  ) u_multiplier (
    .i_pair_sum    (pair_sum),
    .i_coef        (coef),
    .o_product     (product)
  );

  // =============================================
  // 5. ACCUMULATOR
  // =============================================
  logic signed [SUM_WIDTH-1:0] sum;

  accumulator #(
    .DATA_WIDTH    (DATA_WIDTH),
    .TAP           (TAP),
	 .PAIR_WIDTH    (PAIR_WIDTH),
	 .PAIR          (PAIR),
	 .COEF_WIDTH    (COEF_WIDTH),
    .PRODUCT_WIDTH (PRODUCT_WIDTH),
	 .SUM_WIDTH     (SUM_WIDTH)
  ) u_accumulator (
    .i_product     (product),
    .o_sum         (sum)
  );

  assign o_fir_data = sum[DATA_WIDTH-1+15:15];

endmodule
