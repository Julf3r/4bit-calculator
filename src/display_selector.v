module display_selector (
    input  [1:0] state,
    input  [3:0] op1,
    input  [3:0] op2,
    input  [3:0] result,
    output [3:0] value
);

    supply0 zero;

    mux4_1bit m0(
        .z0(zero),
        .z1(op1[0]),
        .z2(op2[0]),
        .z3(result[0]),
        .b0(state[0]),
        .b1(state[1]),
        .y(value[0])
    );

    mux4_1bit m1(
        .z0(zero),
        .z1(op1[1]),
        .z2(op2[1]),
        .z3(result[1]),
        .b0(state[0]),
        .b1(state[1]),
        .y(value[1])
    );

    mux4_1bit m2(
        .z0(zero),
        .z1(op1[2]),
        .z2(op2[2]),
        .z3(result[2]),
        .b0(state[0]),
        .b1(state[1]),
        .y(value[2])
    );

    mux4_1bit m3(
        .z0(zero),
        .z1(op1[3]),
        .z2(op2[3]),
        .z3(result[3]),
        .b0(state[0]),
        .b1(state[1]),
        .y(value[3])
    );

endmodule