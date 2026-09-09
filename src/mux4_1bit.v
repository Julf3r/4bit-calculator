module mux4_1bit (
    input  z0,
    input  z1,
    input  z2,
    input  z3,
    input  b0,
    input  b1,
    output y
);
    wire r0;
    wire r1;

    mux2 m0 (.a(z0), .b(z1), .sel(b0), .y(r0));
    mux2 m1 (.a(z2), .b(z3), .sel(b0), .y(r1));
    mux2 m2 (.a(r0), .b(r1), .sel(b1), .y(y));
endmodule
