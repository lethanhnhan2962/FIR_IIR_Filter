module d_ff #(
  parameter DATA_WIDTH = 16
)(
  input  logic                         i_clk,
  input  logic                         i_rst_n,
  input  logic signed [DATA_WIDTH-1:0] i_d,
  output logic signed [DATA_WIDTH-1:0] o_q
);

  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      o_q <= '0;
    end else begin
      o_q <= i_d;
	 end
  end
  
endmodule