module selector_operando (
    input  h,
    input  b,
    input  r,
    output f
);

    wire not_h;
    wire use_b;
    wire use_r;

    not (not_h, h);

    and (use_b, not_h, b);
    and (use_r, h, r);

    or (f, use_b, use_r);

endmodule