module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire axb;
    wire c1;
    wire c2;
    wire c3;

    xor (axb, a, b);
    xor (sum, axb, cin);

    and (c1, a, b);
    and (c2, b, cin);
    and (c3, a, cin);
    or  (cout, c1, c2, c3);
endmodule
