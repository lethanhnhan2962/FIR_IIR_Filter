h = Num;   % vector hệ số FIR của bạn

% 🔒 đảm bảo đúng 63 taps
h = h(1:63);

% 🔥 scale sang Q15
h_q15 = round(h * 2^15);

% 🔥 convert sang int16
h_int16 = int16(h_q15);

% 🔥 convert sang hex 16-bit
h_hex = dec2hex(typecast(h_int16, 'uint16'), 4);

% 🔥 ghi ra file coef.hex
fid = fopen('coef.hex', 'w');
for i = 1:length(h_hex)
    fprintf(fid, '%s\n', h_hex(i,:));
end
fclose(fid);