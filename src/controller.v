module controller (
    input clk,

    input confirm,
    input use_previous,

    output reg [1:0] state,

    output edit_operation,
    output edit_op1,
    output edit_op2,
    output show_result,

    output ejecutar,
    output reg sel_op2
);

    wire e1;
    wire e0;

    wire ne1;
    wire ne0;

    wire st00;
    wire st01;
    wire st10;
    wire st11;

    wire [1:0] next_state;

    initial begin
        state   = 2'b00;
        sel_op2 = 1'b0;
    end

    buf (e1, state[1]);
    buf (e0, state[0]);

    not (ne1, e1);
    not (ne0, e0);


    // Decodificación de estados

    and (st00, ne1, ne0);
    and (st01, ne1, e0);
    and (st10, e1, ne0);
    and (st11, e1, e0);

    buf (edit_operation, st00);
    buf (edit_op1,       st01);
    buf (edit_op2,       st10);
    buf (show_result,    st11);


    // -------------------------------------------------
    // Máquina de estados
    //
    // Cada confirm hace +1 módulo 4.
    // -------------------------------------------------

    wire toggle0;
    wire toggle1;

    buf (toggle0, confirm);

    and (toggle1, confirm, e0);

    xor (next_state[0], e0, toggle0);
    xor (next_state[1], e1, toggle1);


    // -------------------------------------------------
    // Ejecutar operación
    //
    // Solo cuando se confirma OP2:
    // estado 10 + confirm
    // -------------------------------------------------

    and (ejecutar, confirm, st10);


    // -------------------------------------------------
    // Uso de resultado previo como OP2
    //
    // SW4 solamente tiene efecto durante estado 10.
    // Una vez activado queda en 1 hasta terminar
    // la operación.
    // -------------------------------------------------

    wire set_previous;
    wire clear_previous;

    wire not_clear;

    wire keep_previous;
    wire next_previous;

    and (set_previous,
         use_previous,
         st10);

    // Al confirmar resultado y volver 11 -> 00,
    // limpiamos sel_op2.
    and (clear_previous,
         confirm,
         st11);

    not (not_clear, clear_previous);

    and (keep_previous,
         sel_op2,
         not_clear);

    or (next_previous,
        keep_previous,
        set_previous);


    always @(posedge clk) begin
        state   <= next_state;
        sel_op2 <= next_previous;
    end

endmodule