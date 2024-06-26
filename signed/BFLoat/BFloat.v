`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30/01/2024
// Design Name:
// Module Name: mul
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

// Behavioral floating-point multiplication module
module mul (
  input [15:0] flp_a,
  input [15:0] flp_b,
  output sign,
  output [7:0] exponent,
  output [7:0] exp_unbiased,
  output [8:0] exp_sum,
  output [6:0] prod,
  output [15:0] sum
);

  // Variables used in an always block are declared as registers
  integer i;
  reg sign_a, sign_b;
  reg [7:0] exp_a, exp_b;
  reg [7:0] exp_a_bias, exp_b_bias;
  reg [8:0] exp_sum;
  reg [6:0] fract_a, fract_b;
  reg [13:0] prod_dbl;
  reg [6:0] prod;
  reg sign;
  reg [15:0] sum;
  reg [7:0] exponent, exp_unbiased;

  // Define sign, exponent, and fraction
  always @ (flp_a or flp_b) begin
    sign_a = flp_a[15];
    sign_b = flp_b[15];
    exp_a = flp_a[14:7];
    exp_b = flp_b[14:7];
    fract_a = flp_a[6:0];
    fract_b = flp_b[6:0];

    // Bias exponents
    exp_a_bias = exp_a + 8'b0111_1111;
    exp_b_bias = exp_b + 8'b0111_1111;

    // Add exponents
    exp_sum = exp_a_bias + exp_b_bias;

    // Remove one bias
    exponent = exp_sum - 8'b0111_1111;
    exp_unbiased = exponent - 8'b0111_1111;

    // Multiply fractions
    // if (flp_a != 0 || flp_b != 0) begin
    prod_dbl = fract_a * fract_b;
    prod = prod_dbl[13:7];

    // Postnormalize product
    if (prod == 0) begin
      sum = 16'b0;
    end else begin
      for (i = 0; i < 6; i = i + 1) begin
        if (prod[6] == 0) begin
          prod = prod << 1;
          exp_unbiased = exp_unbiased - 1;
        end
        sign = sign_a ^ sign_b;
        sum = {sign, exp_unbiased, prod};
      end
    end
  end
endmodule