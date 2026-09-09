module calculadora_4bits (
    input        clk,
    input        ejecutar,
    input  [2:0] codigo,
    input        sel_op2,
    input  [3:0] op1,
    input  [3:0] op2_ext,
    output [3:0] resultado
);
    wire s0;
    wire s1;
    wire s2;

    wire [3:0] f;
    wire [3:0] x;
    wire [3:0] y;
    wire [3:0] sigma;

    wire c1;
    wire c2;
    wire c3;
    wire cout;

    wire [3:0] left_value;
    wire [3:0] right_value;
    wire [3:0] shift_value;
    wire [3:0] resultado_comb;

    buf (s0, codigo[0]);
    buf (s1, codigo[1]);
    buf (s2, codigo[2]);

    // Segundo operando: externo o resultado anterior.
    selector_operando so0 (.h(sel_op2), .b(op2_ext[0]), .r(resultado[0]), .f(f[0]));
    selector_operando so1 (.h(sel_op2), .b(op2_ext[1]), .r(resultado[1]), .f(f[1]));
    selector_operando so2 (.h(sel_op2), .b(op2_ext[2]), .r(resultado[2]), .f(f[2]));
    selector_operando so3 (.h(sel_op2), .b(op2_ext[3]), .r(resultado[3]), .f(f[3]));

    // Prepara X e Y para las operaciones 000..011.
    selector_suma ss0 (.s1(s1), .s0(s0), .a(op1[0]), .b(f[0]), .x(x[0]), .y(y[0]));
    selector_suma ss1 (.s1(s1), .s0(s0), .a(op1[1]), .b(f[1]), .x(x[1]), .y(y[1]));
    selector_suma ss2 (.s1(s1), .s0(s0), .a(op1[2]), .b(f[2]), .x(x[2]), .y(y[2]));
    selector_suma ss3 (.s1(s1), .s0(s0), .a(op1[3]), .b(f[3]), .x(x[3]), .y(y[3]));

    // Cin inicial = S1. Luego ripple carry Cout -> Cin.
    full_adder fa0 (.a(x[0]), .b(y[0]), .cin(s1), .sum(sigma[0]), .cout(c1));
    full_adder fa1 (.a(x[1]), .b(y[1]), .cin(c1), .sum(sigma[1]), .cout(c2));
    full_adder fa2 (.a(x[2]), .b(y[2]), .cin(c2), .sum(sigma[2]), .cout(c3));
    full_adder fa3 (.a(x[3]), .b(y[3]), .cin(c3), .sum(sigma[3]), .cout(cout));

    // Los shifts usan los dos bits menos significativos del segundo operando.
    shift_left4  shl (.a(op1), .amount(f[1:0]), .y(left_value));
    shift_right4 shr (.a(op1), .amount(f[1:0]), .y(right_value));

    selector_shift4 shsel (
        .left_value(left_value),
        .right_value(right_value),
        .s0(s0),
        .sh(shift_value)
    );

    selector_resultado4 rsel (
        .sigma(sigma),
        .shift_value(shift_value),
        .s2(s2),
        .r(resultado_comb)
    );

    // Solo se almacena un nuevo resultado cuando ejecutar=1.
    register4 reg_resultado (
        .clk(clk),
        .enable(ejecutar),
        .d(resultado_comb),
        .q(resultado)
    );
endmodule
