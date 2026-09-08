module selector_resultado (
    input  sigma,
    input  shift,
    input  s2,
    output r
);

    mux2 m(
        sigma,
        shift,
        s2,
        r
    );

endmodule