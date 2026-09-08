module calculadora_4bits (
    input        clk,
    input        ejecutar,
    input  [2:0] codigo,
    input        sel_op2,
    input  [3:0] op1,
    input  [3:0] op2_ext,

    output [3:0] resultado
);

    wire [3:0] op2;
    wire [3:0] suma;
    wire [3:0] resta;
    wire [3:0] and_result;
    wire [3:0] or_result;
    wire [3:0] shift_left;
    wire [3:0] shift_right;

    // Selector de operando 2
    mux2 m_op2(op2_ext, op2_ext, sel_op2, op2);

    // Operaciones
    assign suma = op1 + op2;
    assign resta = op1 - op2;
    assign and_result = op1 & op2;
    assign or_result = op1 | op2;

    shift_left4 sl(op1, op2[1:0], shift_left);
    shift_right4 sr(op1, op2[1:0], shift_right);

    // Selector de resultado
    selector_shift ss(shift_left, shift_right, codigo[0], resultado);