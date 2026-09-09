module selector_suma (
    input  s1,
    input  s0,
    input  a,
    input  b,
    output x,
    output y
);
    wire sxor;
    wire na;
    wire nb;
    wire ns0;
    wire x1;
    wire x2;
    wire y1;
    wire y2;

    // Ecuaciones derivadas en las notas:
    // X = A(S1 xor S0) + S1*S0*~A
    // Y = S0*B + S1*~S0*~B
    xor (sxor, s1, s0);
    not (na, a);
    not (nb, b);
    not (ns0, s0);

    and (x1, a, sxor);
    and (x2, s1, s0, na);
    or  (x, x1, x2);

    and (y1, s0, b);
    and (y2, s1, ns0, nb);
    or  (y, y1, y2);
endmodule
