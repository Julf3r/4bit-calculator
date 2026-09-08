module selector_shift (
    input  [3:0] left,
    input  [3:0] right,
    input        s0,
    output [3:0] sh
);

    mux2 m0(left[0], right[0], s0, sh[0]);
    mux2 m1(left[1], right[1], s0, sh[1]);
    mux2 m2(left[2], right[2], s0, sh[2]);
    mux2 m3(left[3], right[3], s0, sh[3]);

endmodule