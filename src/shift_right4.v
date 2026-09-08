module shift_right4 (
    input  [3:0] a,
    input  [1:0] amount,
    output [3:0] y
);

    wire zero;
    supply0 zero;

    // y[3]: A3,0,0,0
    mux4 m3(
        a[3], zero, zero, zero,
        amount[0], amount[1],
        y[3]
    );

    // y[2]: A2,A3,0,0
    mux4 m2(
        a[2], a[3], zero, zero,
        amount[0], amount[1],
        y[2]
    );

    // y[1]: A1,A2,A3,0
    mux4 m1(
        a[1], a[2], a[3], zero,
        amount[0], amount[1],
        y[1]
    );

    // y[0]: A0,A1,A2,A3
    mux4 m0(
        a[0], a[1], a[2], a[3],
        amount[0], amount[1],
        y[0]
    );

endmodule