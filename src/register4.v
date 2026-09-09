module register4 (
    input        clk,
    input        enable,
    input  [3:0] d,
    output reg [3:0] q
);
    wire [3:0] next_q;

    // enable selecciona entre mantener q o cargar d.
    mux2 m0 (.a(q[0]), .b(d[0]), .sel(enable), .y(next_q[0]));
    mux2 m1 (.a(q[1]), .b(d[1]), .sel(enable), .y(next_q[1]));
    mux2 m2 (.a(q[2]), .b(d[2]), .sel(enable), .y(next_q[2]));
    mux2 m3 (.a(q[3]), .b(d[3]), .sel(enable), .y(next_q[3]));

    always @(posedge clk) begin
        q = next_q;
    end
endmodule
