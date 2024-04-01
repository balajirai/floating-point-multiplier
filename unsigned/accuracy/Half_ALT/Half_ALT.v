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
module mul (flp_a, flp_b, exponent, exp_unbiased, exp_sum, prod, sum);
  input [15:0] flp_a, flp_b;
  output [4:0] exponent, exp_unbiased;
  output [5:0] exp_sum;
  output [10:0] prod;
  output [15:0] sum;

  // Variables used in an always block are declared as registers
  integer i;
  reg [4:0] exp_a, exp_b;
  reg [4:0] exp_a_bias, exp_b_bias;
  reg [5:0] exp_sum;
  reg [10:0] fract_a, fract_b;
  reg [21:0] prod_dbl;
  reg [10:0] prod;
  reg [15:0] sum;
  reg [4:0] exponent, exp_unbiased;

  // Define sign, exponent, and fraction
  always @ (flp_a or flp_b) begin
    exp_a = flp_a[15:11];
    exp_b = flp_b[15:11];
    fract_a = flp_a[10:0];
    fract_b = flp_b[10:0];

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
    prod = prod_dbl[21:11];

    // Postnormalize product
    if (prod == 0) begin
      sum = 16'b0;
    end else begin
      for (i = 0; i < 10; i = i + 1) begin
        if (prod[10] == 0) begin
          prod = prod << 1;
          exp_unbiased = exp_unbiased - 1;
        end
        sum = {exp_unbiased, prod};
      end
    end
  end
endmodule