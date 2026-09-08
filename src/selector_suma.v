module selector_suma (
    input  s1,
    input  s0,
    input  a,
    input  b,
    output x,
    output y,
    output cin0
);

    wire s_xor;
    wire not_a;
    wire not_b;
    wire not_s0;

    wire x1, x2;
    wire y1, y2;

    xor (s_xor, s1, s0);

    not (not_a, a);
    not (not_b, b);
    not (not_s0, s0);

    // X = A(S1 xor S0) + S1*S0*~A
    and (x1, a, s_xor);
    and (x2, s1, s0, not_a);
    or  (x, x1, x2);

    // Y = S0*B + S1*~S0*~B
    and (y1, s0, b);
    and (y2, s1, not_s0, not_b);
    or  (y, y1, y2);

    // Cin inicial = S1
    buf (cin0, s1);

endmodule