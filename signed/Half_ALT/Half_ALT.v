module Half_ALT (a, b, sign, exp, frac_norm);
input [15:0]a;
input [15:0]b;

output sign;
output [5:0] exp;
output [20:0] frac_norm;

wire [6:0]c;
wire [6:0]d;

assign c=a[14:10] + 5'b10000;   // biasing
assign d=b[14:10] + 5'b10000;   // biasing

assign sign=a[15] ^ b[15];      // xor of sign

assign exp=c+d-6'b100000;       // unbiasing

wire [19:0] mant;

assign mant=a[9:0] * b[9:0];    // mantissa multiplication

assign frac_norm = {1'b0, mant};    // normalization

endmodule