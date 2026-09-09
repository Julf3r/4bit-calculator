module selector_shift4 (
    input  [3:0] left_value,
    input  [3:0] right_value,
    input        s0,
    output [3:0] sh
);
    // codigo 100 -> s0=0 -> left
    // codigo 101 -> s0=1 -> right
    mux2 m0 (.a(left_value[0]), .b(right_value[0]), .sel(s0), .y(sh[0]));
    mux2 m1 (.a(left_value[1]), .b(right_value[1]), .sel(s0), .y(sh[1]));
    mux2 m2 (.a(left_value[2]), .b(right_value[2]), .sel(s0), .y(sh[2]));
    mux2 m3 (.a(left_value[3]), .b(right_value[3]), .sel(s0), .y(sh[3]));
endmodule
