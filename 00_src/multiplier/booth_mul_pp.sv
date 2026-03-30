module booth_mul_pp #(
  parameter A_WIDTH = 17,
  parameter B_WIDTH = 16
)(
  input  logic signed [A_WIDTH-1:0] i_a,
  input  logic signed [A_WIDTH-1:0] i_p,
  input  logic        [B_WIDTH-1:0] i_b,
  input  logic                      i_q,
  output logic signed [A_WIDTH-1:0] o_next_p,
  output logic        [B_WIDTH-1:0] o_next_b,
  output logic                      o_next_q
);

  logic comp;
  logic add;
  logic signed [A_WIDTH-1:0] a_neg;
  logic signed [A_WIDTH-1:0] a_sel;
  logic signed [A_WIDTH-1:0] operand;
  logic signed [A_WIDTH-1:0] add_result;


  always_comb begin
    unique case ({i_b[0], i_q})

      2'b01: begin
        comp = 0;
        add  = 1;
      end

      2'b10: begin
        comp = 1;
        add  = 1;
      end

      default: begin
        comp = 0;
        add  = 0;
      end

    endcase
  end

  assign a_neg = ~i_a + 1;
  assign a_sel = comp ? a_neg : i_a;
  assign operand = add ? a_sel : '0;
  assign add_result = i_p + operand;
  assign o_next_p = {add_result[A_WIDTH-1], add_result[A_WIDTH-1:1]};
  assign o_next_b = {add_result[0], i_b[B_WIDTH-1:1]};
  assign o_next_q = i_b[0];

endmodule