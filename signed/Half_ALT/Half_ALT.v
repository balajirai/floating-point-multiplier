module Half_ALT(a,b,sign,exp,mant);
    input [15:0]a;
    input [15:0]b;

    output sign;
    output [5:0] exp;
    output [19:0] mant;

    wire [6:0]c;
    wire [6:0]d;
    
    assign c=a[14:10]+5'b01111;
    assign d=b[14:10]+5'b01111;
    assign sign=a[15]^b[15];
    assign exp=c+d-5'b11110;
    assign mant=a[9:0]*b[9:0];
endmodule