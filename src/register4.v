module register4 (
    input        clk,
    input        ejecutar,
    input  [3:0] nuevo,
    output reg [3:0] q
);

    wire [3:0] next_q;

    mux2 m0(q[0], nuevo[0], ejecutar, next_q[0]);
    mux2 m1(q[1], nuevo[1], ejecutar, next_q[1]);
    mux2 m2(q[2], nuevo[2], ejecutar, next_q[2]);
    mux2 m3(q[3], nuevo[3], ejecutar, next_q[3]);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule