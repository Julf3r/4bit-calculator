module selector_operando (
    input  h,
    input  b,
    input  r,
    output f
);
    // h = 0 -> operando externo b
    // h = 1 -> resultado anterior r
    mux2 m0 (
        .a(b),
        .b(r),
        .sel(h),
        .y(f)
    );
endmodule
