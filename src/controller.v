module controller (
    input clk,
    input confirm,
    input use_previous,

    output [1:0] state,
    output edit_operation,
    output edit_op1,
    output edit_op2,
    output show_result,
    output ejecutar,
    output sel_op2
);

    reg [1:0] state_reg;
    reg sel_op2_reg;

    initial begin
        state_reg = 2'b00;
        sel_op2_reg = 1'b0;
    end

    buf (state[0], state_reg[0]);
    buf (state[1], state_reg[1]);
    buf (sel_op2, sel_op2_reg);

    // ============================================================
    // DECODIFICACIÓN DE ESTADOS
    //
    // 00 = seleccionar operación
    // 01 = seleccionar OP1
    // 10 = seleccionar OP2
    // 11 = mostrar resultado
    // ============================================================

    wire not_s0;
    wire not_s1;

    not (not_s0, state_reg[0]);
    not (not_s1, state_reg[1]);

    and (edit_operation, not_s1, not_s0);
    and (edit_op1,       not_s1, state_reg[0]);
    and (edit_op2,       state_reg[1], not_s0);
    and (show_result,    state_reg[1], state_reg[0]);

    // ============================================================
    // SIGUIENTE ESTADO
    //
    // Cada confirm hace:
    // 00 -> 01 -> 10 -> 11 -> 00
    // ============================================================

    wire next_s0;
    wire next_s1;
    wire toggle_s1;

    xor (next_s0, state_reg[0], confirm);

    and (toggle_s1, confirm, state_reg[0]);
    xor (next_s1, state_reg[1], toggle_s1);

    always @(posedge clk) begin
        state_reg[0] <= next_s0;
        state_reg[1] <= next_s1;
    end

    // ============================================================
    // EJECUTAR
    //
    // Ejecuta cuando confirmamos OP2 (estado 10)
    // ============================================================

    and (ejecutar, confirm, edit_op2);

    // ============================================================
    // USAR RESULTADO ANTERIOR
    //
    // SW4 en estado 10 -> sel_op2 = 1
    // Confirm desde resultado -> vuelve a 0
    // ============================================================

    wire set_previous;
    wire clear_previous;
    wire sel_or_set;
    wire not_clear;
    wire next_sel_op2;

    and (set_previous, use_previous, edit_op2);
    and (clear_previous, confirm, show_result);

    or  (sel_or_set, sel_op2_reg, set_previous);
    not (not_clear, clear_previous);
    and (next_sel_op2, sel_or_set, not_clear);

    always @(posedge clk) begin
        sel_op2_reg <= next_sel_op2;
    end

endmodule