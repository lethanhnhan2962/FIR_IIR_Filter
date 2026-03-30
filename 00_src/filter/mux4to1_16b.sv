module mux4to1_16b (
  input  logic [ 1:0] i_sel,
  input  logic [15:0] i_d0,
  input  logic [15:0] i_d1,
  input  logic [15:0] i_d2,
  input  logic [15:0] i_d3,
  output logic [15:0] o_y
);

  always_comb begin
    case (i_sel)
      2'b00:   o_y = i_d0;
      2'b01:   o_y = i_d1;
      2'b10:   o_y = i_d2;
      2'b11:   o_y = i_d3;
      default: o_y = 16'b0;
    endcase
  end

endmodule