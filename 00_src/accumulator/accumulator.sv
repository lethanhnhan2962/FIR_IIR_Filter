module accumulator #(
  parameter int DATA_WIDTH    = 16,
  parameter int TAP           = 11,
  parameter int PAIR_WIDTH    = DATA_WIDTH + 1,
  parameter int PAIR          = TAP/2,
  parameter int COEF_WIDTH    = 16,
  parameter int PRODUCT_WIDTH = PAIR_WIDTH + COEF_WIDTH,
  parameter int SUM_WIDTH     = PRODUCT_WIDTH + $clog2(PAIR+1)
)(
  input  logic signed [PRODUCT_WIDTH-1:0] i_product [0:PAIR],
  output logic signed [SUM_WIDTH-1:0]     o_sum
);

  logic signed [SUM_WIDTH-1:0] sum        [0:PAIR+1];
  logic signed [SUM_WIDTH-1:0] product_ext[0:PAIR];

  genvar k;
  generate
    for (k = 0; k <= PAIR; k++) begin : EXTEND_PRODUCT
      assign product_ext[k] = {{(SUM_WIDTH-PRODUCT_WIDTH){i_product[k][PRODUCT_WIDTH-1]}}, i_product[k]};
    end
  endgenerate

  assign sum[0] = '0;

  genvar i;
  generate
    for (i = 0; i <= PAIR; i++) begin : SUM_OF_PRODUCT
      adder #(
        .DATA_WIDTH(SUM_WIDTH),
        .SUM_WIDTH (SUM_WIDTH)
      ) u_adder (
        .a (sum[i]),
        .b (product_ext[i]),
        .s (sum[i+1])
      );

    end
  endgenerate

  // ============================
  // OUTPUT
  // ============================
  assign o_sum = sum[PAIR+1];

endmodule