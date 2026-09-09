module mux2 (
    input  a,
    input  b,
    input  sel,
    output y
);
    wire nsel;
    wire ya;
    wire yb;

    not (nsel, sel);
    and (ya, a, nsel);
    and (yb, b, sel);
    or  (y, ya, yb);
endmodule
