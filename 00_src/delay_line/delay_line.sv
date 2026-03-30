module delay_line #(
  parameter TAP = 11,
  parameter DATA_WIDTH = 16
)(
  input  logic                         i_clk,
  input  logic                         i_rst_n,
  input  logic signed [DATA_WIDTH-1:0] i_sample,
  output logic signed [DATA_WIDTH-1:0] o_delay_sample[0:TAP-1]
);

  logic signed [DATA_WIDTH-1:0] delay_sample[0:TAP-1];
  
  assign delay_sample[0] = i_sample;

  genvar i;
  generate
    for (i = 0; i < TAP-1; i++) begin : gen_delay
      d_ff #(
        .DATA_WIDTH(DATA_WIDTH)
      ) d_ff_inst (
        .i_clk   (i_clk),
        .i_rst_n (i_rst_n),
        .i_d     (delay_sample[i]),
        .o_q     (delay_sample[i+1])
      );
    end
  endgenerate

  assign o_delay_sample = delay_sample;

endmodule