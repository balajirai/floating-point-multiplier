// testbench for Half_ALT

module tb;
    reg [15:0]a;
    reg [15:0] b;

    wire sum;
    wire[4:0] exp;
    wire[19:0] mant;

    Half_ALT inst(a,b,sum,exp,mant);

    initial
    begin
        a=16'b1000111111100000;
        b=16'b1000101111100001;
        #100 a=16'b0000111111100001;b=16'b1000101111100001;
    end

    always @(a or b)begin
        $monitor("a=%b b=%b sum=%b",a,b,sum);
        $display("Result: %d", mant);
    end
endmodule