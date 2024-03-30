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
  output [5:0] exponent,
  output [6:0] exp_unbiased,
  output [6:0] exp_sum,
  output [8:0] prod,
  output [15:0] sum
);

  // Variables used in an always block are declared as registers
  reg sign_a, sign_b;
  reg [5:0] exp_a, exp_b;
  reg [5:0] exp_a_bias, exp_b_bias;
  reg [6:0] exp_sum;
  reg [8:0] fract_a, fract_b;
  reg [17:0] prod_dbl;
  reg [8:0] prod;
  reg sign;
  reg [15:0] sum;
  reg [5:0] exponent, exp_unbiased;

  // Define sign, exponent, and fraction
  always @ (flp_a or flp_b) begin
    sign_a = flp_a[15];
    sign_b = flp_b[15];
    exp_a = flp_a[14:9];
    exp_b = flp_b[14:9];
    fract_a = flp_a[8:0];
    fract_b = flp_b[8:0];

    // Bias exponents
    exp_a_bias = exp_a + 6'b0111_11;
    exp_b_bias = exp_b + 6'b0111_11;

    // Add exponents
    exp_sum = exp_a_bias + exp_b_bias;

    // Remove one bias
    exponent = exp_sum - 6'b0111_11;
    exp_unbiased = exponent - 6'b0111_11;

    // Multiply fractions
    // if (flp_a != 0 || flp_b != 0) begin
    prod_dbl = fract_a * fract_b;
    prod = prod_dbl[17:9];

    // Postnormalize product
    while (prod[8] == 0) begin
      prod = prod << 1;
      exp_unbiased = exp_unbiased - 1;
    end

    sign = sign_a ^ sign_b;
    if (prod == 0) begin 
      sum = 16'b0;
    end
    else begin
      sum = {sign, exp_unbiased, prod};
    end
  end
endmodule