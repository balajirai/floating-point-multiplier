// Code your testbench here
// or browse Examples
module mul1();
  reg [15:0] flp_a, flp_b;
  wire [4:0] exponent, exp_unbiased;
  wire [5:0] exp_sum;
  wire [10:0] prod;
  wire [15:0] sum ;
  mul mu(flp_a, flp_b, exponent, exp_unbiased, exp_sum, prod,sum);
	initial
      begin
        flp_a = 16'b1010101010101010;     flp_b = 16'b1100110011001100; 
       #10;
$display("flp_a = %f, flp_b = %f",flp_a,flp_b);
$display("exponent = %b, exp_unbiased = %b,exp_sum = %b",exponent, exp_unbiased, exp_sum);
$display("prod = %b, sum = %f", prod, sum);
    // End simulation
    $finish;
      end
endmodule