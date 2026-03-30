module adder #(
  parameter int DATA_WIDTH = 16,
  parameter int SUM_WIDTH  = DATA_WIDTH + 1
)(
  input  logic signed [DATA_WIDTH-1:0] a,
  input  logic signed [DATA_WIDTH-1:0] b,
  output logic signed [ SUM_WIDTH-1:0] s
);

  assign s = a + b;

endmodule