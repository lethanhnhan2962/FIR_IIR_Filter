module coef_rom (
  output logic signed [15:0] o_coef [0:31]
);

  logic signed [15:0] coef [0:31];

  initial begin
    $readmemh("C:/Users/LNV/Documents/Xu_Ly_Tin_Hieu_So_Voi_FPGA/DSP_LAB2/02_dump/coef.hex", coef);
  end

  assign o_coef = coef;

endmodule