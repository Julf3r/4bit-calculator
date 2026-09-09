module counter4 (
    input        clk,
    input        up,
    input        down,
    output reg [3:0] q
);

    wire n0, n1, n2;

    wire up_only;
    wire down_only;
    wire move;

    wire t1_up, t1_down;
    wire t2_up, t2_down;
    wire t3_up, t3_down;

    wire t1, t2, t3;

    wire [3:0] d;

    // Estado inicial
    initial q = 4'b0000;

    // Si UP y DOWN se presionan simultáneamente,
    // no se realiza movimiento.
    wire not_up;
    wire not_down;

    not (not_up, up);
    not (not_down, down);

    and (up_only,   up,   not_down);
    and (down_only, down, not_up);

    or (move, up_only, down_only);

    // Complementos de Q
    not (n0, q[0]);
    not (n1, q[1]);
    not (n2, q[2]);

    // D0 = Q0 XOR (UP + DOWN)
    xor (d[0], q[0], move);

    // D1 = Q1 XOR (UP*Q0 + DOWN*~Q0)
    and (t1_up,   up_only,   q[0]);
    and (t1_down, down_only, n0);
    or  (t1, t1_up, t1_down);
    xor (d[1], q[1], t1);

    // D2 = Q2 XOR (UP*Q0*Q1 + DOWN*~Q0*~Q1)
    and (t2_up,   up_only,   q[0], q[1]);
    and (t2_down, down_only, n0, n1);
    or  (t2, t2_up, t2_down);
    xor (d[2], q[2], t2);

    // D3 = Q3 XOR
    //      (UP*Q0*Q1*Q2 + DOWN*~Q0*~Q1*~Q2)
    and (t3_up,   up_only,   q[0], q[1], q[2]);
    and (t3_down, down_only, n0, n1, n2);
    or  (t3, t3_up, t3_down);
    xor (d[3], q[3], t3);

    always @(posedge clk) begin
        q <= d;
    end

endmodule