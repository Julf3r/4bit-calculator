module shift_right4 (
    input  [3:0] a,
    input  [1:0] amount,
    output [3:0] y
);
    supply0 zero;

    // amount 00 -> A
    // amount 01 -> 0 A3 A2 A1
    // amount 10 -> 0 0 A3 A2
    // amount 11 -> 0 0 0 A3
    mux4_1bit m3 (.z0(a[3]), .z1(zero), .z2(zero), .z3(zero), .b0(amount[0]), .b1(amount[1]), .y(y[3]));
    mux4_1bit m2 (.z0(a[2]), .z1(a[3]), .z2(zero), .z3(zero), .b0(amount[0]), .b1(amount[1]), .y(y[2]));
    mux4_1bit m1 (.z0(a[1]), .z1(a[2]), .z2(a[3]), .z3(zero), .b0(amount[0]), .b1(amount[1]), .y(y[1]));
    mux4_1bit m0 (.z0(a[0]), .z1(a[1]), .z2(a[2]), .z3(a[3]), .b0(amount[0]), .b1(amount[1]), .y(y[0]));
endmodule
