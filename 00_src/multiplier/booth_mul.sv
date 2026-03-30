module booth_mul #(
  parameter A_WIDTH = 17,
  parameter B_WIDTH = 16
)(
  input  logic signed [A_WIDTH-1:0] i_a,
  input  logic signed [B_WIDTH-
  1:0] i_b,
  output logic signed [A_WIDTH+B_WIDTH-1:0] o_p
);

  logic signed [A_WIDTH-1:0] p [0:B_WIDTH];
  logic        [B_WIDTH-1:0] b [0:B_WIDTH];
  logic                      q [0:B_WIDTH];

  assign p[0] = '0;
  assign b[0] = i_b;
  assign q[0] = 1'b0;

  genvar i;

  generate
    for(i=0;i<B_WIDTH;i++) begin : booth_stage
      booth_mul_pp #(
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH)
      ) u_pp (
        .i_a (i_a),
        .i_p (p[i]),
        .i_b (b[i]),
        .i_q (q[i]),
        .o_next_p (p[i+1]),
        .o_next_b (b[i+1]),
        .o_next_q (q[i+1])
      );

    end
  endgenerate

  assign o_p = {p[B_WIDTH], b[B_WIDTH]};

endmodule