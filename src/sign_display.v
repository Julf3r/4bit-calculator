module sign_display (
    input sign,

    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g
);

    supply0 zero;

    buf (a, zero);
    buf (b, zero);
    buf (c, zero);
    buf (d, zero);
    buf (e, zero);
    buf (f, zero);

    buf (g, sign);

endmodule