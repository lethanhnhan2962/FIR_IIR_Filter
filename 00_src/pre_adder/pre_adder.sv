module pre_adder #(
  parameter int DATA_WIDTH = 16,
  parameter int TAP        = 11,
  parameter int PAIR_WIDTH = DATA_WIDTH + 1,
  parameter int PAIR       = TAP/2
)(
  input  logic signed [DATA_WIDTH-1:0] i_delay_sample [0:TAP-1],
  output logic signed [PAIR_WIDTH-1:0] o_pair_sum     [0:PAIR]
);

  genvar i;

  generate
    for (i = 0; i < PAIR; i++) begin : gen_pair_adder
      adder #(
        .DATA_WIDTH(DATA_WIDTH),
        .SUM_WIDTH (PAIR_WIDTH)
      ) u_adder (
        .a (i_delay_sample[i]),
        .b (i_delay_sample[TAP-1-i]),
        .s (o_pair_sum[i])
      );
    end
  endgenerate

  assign o_pair_sum[PAIR] = i_delay_sample[PAIR];

endmodule