module shift_left4 (
    input  [3:0] a,
    input  [1:0] amount,
    output [3:0] y
);

    wire zero;
    supply0 zero;

    mux4 m3(
        a[3], a[2], a[1], a[0],
        amount[0], amount[1],
        y[3]
    );

    mux4 m2(
        a[2], a[1], a[0], zero,
        amount[0], amount[1],
        y[2]
    );

    mux4 m1(
        a[1], a[0], zero, zero,
        amount[0], amount[1],
        y[1]
    );

    mux4 m0(
        a[0], zero, zero, zero,
        amount[0], amount[1],
        y[0]
    );

endmodule