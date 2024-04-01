// Code your design here
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

// Behavioral floating-point multiplication
module mul (flp_a, flp_b, sign, exponent, exp_unbiased, exp_sum, prod, sum);
  input [15:0] flp_a, flp_b;
  output sign;
  output [4:0] exponent, exp_unbiased;
  output [5:0] exp_sum;
  output [9:0] prod;
  output [15:0] sum;

  // Variables used in an always block are declared as registers
  integer i;
  reg sign_a, sign_b;
  reg [4:0] exp_a, exp_b;
  reg [4:0] exp_a_bias, exp_b_bias;
  reg [5:0] exp_sum;
  reg [9:0] fract_a, fract_b;
  reg [19:0] prod_dbl;
  reg [9:0] prod;
  reg sign;
  reg [15:0] sum;
  reg [4:0] exponent, exp_unbiased;

  // Define sign, exponent, and fraction
  always @ (flp_a or flp_b) begin
    sign_a = flp_a[15];
    sign_b = flp_b[15];
    exp_a = flp_a[14:10];
    exp_b = flp_b[14:10];
    fract_a = flp_a[9:0];
    fract_b = flp_b[9:0];

    // Bias exponents
    exp_a_bias = exp_a + 5'b0111_1;
    exp_b_bias = exp_b + 5'b0111_1;

    // Add exponents
    exp_sum = exp_a_bias + exp_b_bias;

    // Remove one bias
    exponent = exp_sum - 5'b0111_1;
    exp_unbiased = exponent - 5'b0111_1;

    // Multiply fractions
    // if (flp_a != 0 || flp_b!=0) begin
    prod_dbl = fract_a * fract_b;
    prod = prod_dbl[19:10];

    // Postnormalize product
    if (prod == 0) begin
      sum = 16'b0;
    end else begin
      for (i = 0; i < 9; i = i + 1) begin
        if (prod[9] == 0) begin
          prod = prod << 1;
          exp_unbiased = exp_unbiased - 1;
        end
        sign = sign_a ^ sign_b;
        sum = {sign, exp_unbiased, prod};
      end
    end
  end
endmodule