module go_board_top (
    input i_Clk,

    input i_Switch_1,
    input i_Switch_2,
    input i_Switch_3,
    input i_Switch_4,

    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4,

    output o_Segment1_A,
    output o_Segment1_B,
    output o_Segment1_C,
    output o_Segment1_D,
    output o_Segment1_E,
    output o_Segment1_F,
    output o_Segment1_G,

    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G
);

    // ============================================================
    // BOTONES
    //
    // SW1 = incrementar
    // SW2 = disminuir
    // SW3 = confirmar
    // SW4 = usar resultado anterior
    // ============================================================

    wire sw1_clean;
    wire sw2_clean;
    wire sw3_clean;
    wire sw4_clean;

    debounce #(.COUNT_MAX(250000)) db1 (
        .clk(i_Clk),
        .noisy(i_Switch_1),
        .clean(sw1_clean)
    );

    debounce #(.COUNT_MAX(250000)) db2 (
        .clk(i_Clk),
        .noisy(i_Switch_2),
        .clean(sw2_clean)
    );

    debounce #(.COUNT_MAX(250000)) db3 (
        .clk(i_Clk),
        .noisy(i_Switch_3),
        .clean(sw3_clean)
    );

    debounce #(.COUNT_MAX(250000)) db4 (
        .clk(i_Clk),
        .noisy(i_Switch_4),
        .clean(sw4_clean)
    );


    // ------------------------------------------------------------
    // Convertir cada pulsación en un pulso de un solo clock
    // ------------------------------------------------------------

    wire sw1_pulse;
    wire sw2_pulse;
    wire sw3_pulse;
    wire sw4_pulse;

    one_pulse p1 (
        .clk(i_Clk),
        .signal_in(sw1_clean),
        .pulse(sw1_pulse)
    );

    one_pulse p2 (
        .clk(i_Clk),
        .signal_in(sw2_clean),
        .pulse(sw2_pulse)
    );

    one_pulse p3 (
        .clk(i_Clk),
        .signal_in(sw3_clean),
        .pulse(sw3_pulse)
    );

    one_pulse p4 (
        .clk(i_Clk),
        .signal_in(sw4_clean),
        .pulse(sw4_pulse)
    );


    // ============================================================
    // CONTROLADOR DE ESTADOS
    //
    // 00 -> seleccionar operación
    // 01 -> seleccionar OP1
    // 10 -> seleccionar OP2
    // 11 -> mostrar resultado
    // ============================================================

    wire [1:0] state;

    wire edit_operation;
    wire edit_op1;
    wire edit_op2;
    wire show_result;

    wire ejecutar;
    wire sel_op2;

    controller ctrl (
        .clk(i_Clk),

        .confirm(sw3_pulse),
        .use_previous(sw4_pulse),

        .state(state),

        .edit_operation(edit_operation),
        .edit_op1(edit_op1),
        .edit_op2(edit_op2),
        .show_result(show_result),

        .ejecutar(ejecutar),
        .sel_op2(sel_op2)
    );


    // ============================================================
    // HABILITACIÓN UP / DOWN SEGÚN ESTADO
    // ============================================================

    wire operation_up;
    wire operation_down;

    wire op1_up;
    wire op1_down;

    wire op2_up;
    wire op2_down;

    and (operation_up,
         sw1_pulse,
         edit_operation);

    and (operation_down,
         sw2_pulse,
         edit_operation);


    and (op1_up,
         sw1_pulse,
         edit_op1);

    and (op1_down,
         sw2_pulse,
         edit_op1);


    and (op2_up,
         sw1_pulse,
         edit_op2);

    and (op2_down,
         sw2_pulse,
         edit_op2);


    // ============================================================
    // REGISTROS / CONTADORES
    // ============================================================

    wire [2:0] codigo;
    wire [3:0] op1;
    wire [3:0] op2;

    operation_counter operation_reg (
        .clk(i_Clk),
        .up(operation_up),
        .down(operation_down),
        .q(codigo)
    );

    counter4 op1_reg (
        .clk(i_Clk),
        .up(op1_up),
        .down(op1_down),
        .q(op1)
    );

    counter4 op2_reg (
        .clk(i_Clk),
        .up(op2_up),
        .down(op2_down),
        .q(op2)
    );


    // ============================================================
    // CALCULADORA
    // ============================================================

    wire [3:0] resultado;

    calculadora_4bits calc (
        .clk(i_Clk),

        .ejecutar(ejecutar),

        .codigo(codigo),
        .sel_op2(sel_op2),

        .op1(op1),
        .op2_ext(op2),

        .resultado(resultado)
    );


    // ============================================================
    // OP2 QUE SE MOSTRARÁ
    //
    // Si SW4 fue presionado, mostramos resultado anterior
    // en lugar del OP2 manual.
    // ============================================================

    wire [3:0] op2_mostrado;

    selector_operando op2_display_0 (
        .h(sel_op2),
        .b(op2[0]),
        .r(resultado[0]),
        .f(op2_mostrado[0])
    );

    selector_operando op2_display_1 (
        .h(sel_op2),
        .b(op2[1]),
        .r(resultado[1]),
        .f(op2_mostrado[1])
    );

    selector_operando op2_display_2 (
        .h(sel_op2),
        .b(op2[2]),
        .r(resultado[2]),
        .f(op2_mostrado[2])
    );

    selector_operando op2_display_3 (
        .h(sel_op2),
        .b(op2[3]),
        .r(resultado[3]),
        .f(op2_mostrado[3])
    );


    // ============================================================
    // VALOR A MOSTRAR
    //
    // estado 00 -> 0
    // estado 01 -> OP1
    // estado 10 -> OP2
    // estado 11 -> resultado
    // ============================================================

    wire [3:0] display_value;

    display_selector display_sel (
        .state(state),
        .op1(op1),
        .op2(op2_mostrado),
        .result(resultado),
        .value(display_value)
    );


    // ============================================================
    // DISPLAY HEXADECIMAL
    // ============================================================

    wire hex_a;
    wire hex_b;
    wire hex_c;
    wire hex_d;
    wire hex_e;
    wire hex_f;
    wire hex_g;

    hex7seg hex_display (
        .value(display_value),

        .a(hex_a),
        .b(hex_b),
        .c(hex_c),
        .d(hex_d),
        .e(hex_e),
        .f(hex_f),
        .g(hex_g)
    );


    // ============================================================
    // DISPLAY DEL SIGNO
    // ============================================================

    wire sign_a;
    wire sign_b;
    wire sign_c;
    wire sign_d;
    wire sign_e;
    wire sign_f;
    wire sign_g;

    sign_display sign (
        .sign(display_value[3]),

        .a(sign_a),
        .b(sign_b),
        .c(sign_c),
        .d(sign_d),
        .e(sign_e),
        .f(sign_f),
        .g(sign_g)
    );


    // ============================================================
    // LEDs
    //
    // LED1 LED2 LED3 muestran S2 S1 S0
    // ============================================================

    supply0 zero;

    buf (o_LED_1, codigo[2]);
    buf (o_LED_2, codigo[1]);
    buf (o_LED_3, codigo[0]);

    buf (o_LED_4, zero);


    // ============================================================
    // SALIDAS FÍSICAS 7-SEGMENT
    //
    // Go Board usa segmentos active-low.
    //
    // Segment1 = display superior = signo
    // Segment2 = display inferior = hexadecimal
    // ============================================================

    not (o_Segment1_A, sign_a);
    not (o_Segment1_B, sign_b);
    not (o_Segment1_C, sign_c);
    not (o_Segment1_D, sign_d);
    not (o_Segment1_E, sign_e);
    not (o_Segment1_F, sign_f);
    not (o_Segment1_G, sign_g);

    not (o_Segment2_A, hex_a);
    not (o_Segment2_B, hex_b);
    not (o_Segment2_C, hex_c);
    not (o_Segment2_D, hex_d);
    not (o_Segment2_E, hex_e);
    not (o_Segment2_F, hex_f);
    not (o_Segment2_G, hex_g);

endmodule