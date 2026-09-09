`timescale 1ns/1ps

module calculadora_4bits_tb_completo;
    logic clk;
    logic ejecutar;
    logic [2:0] codigo;
    logic sel_op2;
    logic [3:0] op1;
    logic [3:0] op2_ext;
    logic [3:0] resultado;

    calculadora_4bits dut (
        .clk(clk),
        .ejecutar(ejecutar),
        .codigo(codigo),
        .sel_op2(sel_op2),
        .op1(op1),
        .op2_ext(op2_ext),
        .resultado(resultado)
    );

    localparam RESET = 3'b000;
    localparam SUMA  = 3'b001;
    localparam RESTA = 3'b010;
    localparam RINV  = 3'b011;
    localparam SHL   = 3'b100;
    localparam SHR   = 3'b101;

    always #5 clk = ~clk;

    task automatic ejecutar_pulso;
        begin
            ejecutar = 1'b1;
            @(posedge clk);
            #1;
            ejecutar = 1'b0;
            @(posedge clk);
            #1;
        end
    endtask

    task automatic probar_ext;
        input [2:0] cod;
        input [3:0] a;
        input [3:0] b;
        input [3:0] esperado;
        input string nombre;
        begin
            codigo  = cod;
            sel_op2 = 1'b0;
            op1     = a;
            op2_ext = b;
            ejecutar_pulso();

            if (resultado !== esperado) begin
                $display("FAIL %s", nombre);
                $display(" esperado=%b obtenido=%b", esperado, resultado);
                $fatal;
            end
            $display("PASS %s -> %b", nombre, resultado);
        end
    endtask

    initial begin
        $dumpfile("calculadora_4bits_tb_completo.vcd");
        $dumpvars(0, calculadora_4bits_tb_completo);

        clk = 1'b0;
        ejecutar = 1'b0;
        codigo = RESET;
        sel_op2 = 1'b0;
        op1 = 4'b0000;
        op2_ext = 4'b0000;

        repeat (2) @(posedge clk);

        probar_ext(RESET, 4'b1111, 4'b1111, 4'b0000, "reset");
        probar_ext(SUMA,  4'b0011, 4'b0100, 4'b0111, "3 + 4 = 7");
        probar_ext(SUMA,  4'b1110, 4'b0011, 4'b0001, "-2 + 3 = 1");
        probar_ext(RESTA, 4'b0010, 4'b0101, 4'b1101, "2 - 5 = -3");
        probar_ext(RINV,  4'b0010, 4'b0101, 4'b0011, "5 - 2 = 3 (inversa)");

        probar_ext(SHL, 4'b0011, 4'b0010, 4'b1100, "0011 << 2");
        probar_ext(SHR, 4'b1100, 4'b0010, 4'b0011, "1100 >> 2");
        probar_ext(SHL, 4'b1011, 4'b0011, 4'b1000, "1011 << 3");
        probar_ext(SHR, 4'b1011, 4'b0011, 4'b0001, "1011 >> 3");

        // Feedback: primero 3+2=5, luego 1 + resultado_anterior = 6.
        probar_ext(SUMA, 4'b0011, 4'b0010, 4'b0101, "feedback paso 1: 3+2=5");
        codigo  = SUMA;
        sel_op2 = 1'b1;
        op1     = 4'b0001;
        op2_ext = 4'b1111; // debe ignorarse
        ejecutar_pulso();
        if (resultado !== 4'b0110) begin
            $display("FAIL feedback: esperado=0110 obtenido=%b", resultado);
            $fatal;
        end
        $display("PASS feedback: 1 + resultado_anterior(5) = %b", resultado);

        $display("TODOS LOS TESTS PASARON");
        $finish;
    end
endmodule
