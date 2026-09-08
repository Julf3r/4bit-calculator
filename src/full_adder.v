module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

    wire xor_ab;
    wire c1, c2, c3;

    xor (xor_ab, a, b);
    xor (sum, xor_ab, cin);

    and (c1, a, b);
    and (c2, b, cin);
    and (c3, a, cin);

    or (cout, c1, c2, c3);

endmodule