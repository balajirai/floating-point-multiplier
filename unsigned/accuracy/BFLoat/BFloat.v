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
  output [7:0] exponent,
  output [7:0] exp_unbiased,
  output [8:0] exp_sum,
  output [7:0] prod,
  output [15:0] sum
);

  // Variables used in an always block are declared as registers
  reg [7:0] exp_a, exp_b;
  reg [7:0] exp_a_bias, exp_b_bias;
  reg [8:0] exp_sum;
  reg [7:0] fract_a, fract_b;
  reg [15:0] prod_dbl;
  reg [7:0] prod;
  reg [15:0] sum;
  reg [7:0] exponent, exp_unbiased;

  // Define sign, exponent, and fraction
  always @ (flp_a or flp_b) begin
    exp_a = flp_a[15:8];
    exp_b = flp_b[15:8];
    fract_a = flp_a[7:0];
    fract_b = flp_b[7:0];

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
    prod = prod_dbl[15:8];

    // Postnormalize product
    while (prod[7] == 0) begin
      prod = prod << 1;
      exp_unbiased = exp_unbiased - 1;
    end

    if (prod == 0) begin 
      sum = 16'b0;
    end
    else begin
      sum = {exp_unbiased, prod};
    end
  end
endmodule
