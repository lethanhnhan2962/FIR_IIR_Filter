module multiplier #(
  parameter int DATA_WIDTH    = 16,
  parameter int TAP           = 11,
  parameter int PAIR_WIDTH    = DATA_WIDTH + 1,
  parameter int PAIR          = TAP/2,
  parameter int COEF_WIDTH    = 16,
  parameter int PRODUCT_WIDTH = PAIR_WIDTH + COEF_WIDTH
)(
  input  logic signed [   PAIR_WIDTH-1:0] i_pair_sum[0:PAIR],
  input  logic signed [   COEF_WIDTH-1:0]     i_coef[0:PAIR],
  output logic signed [PRODUCT_WIDTH-1:0]  o_product[0:PAIR]
);
  
  genvar i;
  generate
    for (i = 0; i <= PAIR; i++) begin : gen_mul
      booth_mul #(
        .A_WIDTH (PAIR_WIDTH),
		  .B_WIDTH (COEF_WIDTH)
      ) u_booth_mul (
        .i_a (i_pair_sum[i]),
        .i_b (    i_coef[i]),
        .o_p ( o_product[i])
      );
		
    end
  endgenerate
  
endmodule