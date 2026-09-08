module mux4 (
    input z0,
    input z1,
    input z2,
    input z3,
    input b0,
    input b1,
    output y
);

    wire r0;
    wire r1;

    mux2 m0(z0, z1, b0, r0);
    mux2 m1(z2, z3, b0, r1);

    mux2 m2(r0, r1, b1, y);

endmodule