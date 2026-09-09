module selector_resultado4 (
    input  [3:0] sigma,
    input  [3:0] shift_value,
    input        s2,
    output [3:0] r
);
    // s2=0 -> aritmetica; s2=1 -> shift
    mux2 m0 (.a(sigma[0]), .b(shift_value[0]), .sel(s2), .y(r[0]));
    mux2 m1 (.a(sigma[1]), .b(shift_value[1]), .sel(s2), .y(r[1]));
    mux2 m2 (.a(sigma[2]), .b(shift_value[2]), .sel(s2), .y(r[2]));
    mux2 m3 (.a(sigma[3]), .b(shift_value[3]), .sel(s2), .y(r[3]));
endmodule
