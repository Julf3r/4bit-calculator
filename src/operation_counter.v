module operation_counter (
    input        clk,
    input        up,
    input        down,
    output reg [2:0] q
);

    wire nq2, nq1, nq0;

    wire s0, s1, s2, s3, s4, s5;

    wire up2, up1, up0;
    wire dn2, dn1, dn0;

    wire up_only;
    wire down_only;
    wire hold;

    wire not_up;
    wire not_down;

    wire [2:0] d;

    initial q = 3'b000;

    not (not_up, up);
    not (not_down, down);

    and (up_only,   up,   not_down);
    and (down_only, down, not_up);

    // hold = ni UP ni DOWN, o ambos a la vez
    nor (hold, up_only, down_only);

    // Decodificar estado actual
    not (nq2, q[2]);
    not (nq1, q[1]);
    not (nq0, q[0]);

    and (s0, nq2, nq1, nq0); // 000
    and (s1, nq2, nq1, q[0]); // 001
    and (s2, nq2, q[1], nq0); // 010
    and (s3, nq2, q[1], q[0]); // 011
    and (s4, q[2], nq1, nq0); // 100
    and (s5, q[2], nq1, q[0]); // 101


    // ---------------------------
    // Próximo estado para UP
    //
    // 0→1
    // 1→2
    // 2→3
    // 3→4
    // 4→5
    // 5→0
    // ---------------------------

    or (up2, s3, s4);
    or (up1, s1, s2);
    or (up0, s0, s2, s4);


    // ---------------------------
    // Próximo estado para DOWN
    //
    // 0→5
    // 1→0
    // 2→1
    // 3→2
    // 4→3
    // 5→4
    // ---------------------------

    or (dn2, s0, s5);
    or (dn1, s3, s4);
    or (dn0, s0, s2, s4);


    // ---------------------------
    // Selección hold / up / down
    // ---------------------------

    wire h0, u0, d0;
    wire h1, u1, d1;
    wire h2, u2, d2;

    and (h0, hold, q[0]);
    and (u0, up_only, up0);
    and (d0, down_only, dn0);
    or  (d[0], h0, u0, d0);

    and (h1, hold, q[1]);
    and (u1, up_only, up1);
    and (d1, down_only, dn1);
    or  (d[1], h1, u1, d1);

    and (h2, hold, q[2]);
    and (u2, up_only, up2);
    and (d2, down_only, dn2);
    or  (d[2], h2, u2, d2);

    always @(posedge clk) begin
        q <= d;
    end

endmodule