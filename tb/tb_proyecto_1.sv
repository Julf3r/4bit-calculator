`timescale 1ns/1ps

module calculadora_4bits_tb;

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

  localparam REINICIO      = 3'b000;
  localparam SUMA          = 3'b001;
  localparam RESTA         = 3'b010;
  localparam RESTA_INVERSA = 3'b011;
  localparam SL            = 3'b100;
  localparam SR            = 3'b101;

  always #5 clk = ~clk;

  int total_tests = 0;
  int tests_aprobados = 0;

  function automatic [3:0] esperado(
    input [2:0] cod,
    input [3:0] a,
    input [3:0] b
  );
    begin
      case (cod)
        REINICIO:      esperado = 4'b0000;
        SUMA:          esperado = a + b;
        RESTA:         esperado = a - b;
        RESTA_INVERSA: esperado = b - a;
        SL:            esperado = a << b[1:0];
        SR:            esperado = a >> b[1:0];
        default:       esperado = 4'b0000;
      endcase
    end
  endfunction

  task automatic pulso_ejecutar;
    begin
      ejecutar = 1'b1;
      @(posedge clk);
      #1;
      ejecutar = 1'b0;
      @(posedge clk);
      #1;
    end
  endtask

  task automatic probar(
    input [2:0] cod,
    input [3:0] a,
    input [3:0] b,
    input string nombre
  );
    logic [3:0] exp;
    begin
      exp     = esperado(cod, a, b);
      codigo  = cod;
      sel_op2 = 1'b0;
      op1     = a;
      op2_ext = b;

      pulso_ejecutar();

      total_tests = total_tests + 1;
      if (resultado !== exp) begin
        $display("FAIL %s: codigo=%b op1=%b op2=%b esperado=%b obtenido=%b",
                 nombre, cod, a, b, exp, resultado);
      end else begin
        tests_aprobados = tests_aprobados + 1;
        $display("PASS %s: resultado=%b", nombre, resultado);
      end
    end
  endtask

  initial begin
    $dumpfile("calculadora_4bits_tb.vcd");
    $dumpvars(0, calculadora_4bits_tb);

    clk = 0;
    ejecutar = 0;
    codigo = 0;
    sel_op2 = 0;
    op1 = 0;
    op2_ext = 0;

    repeat (2) @(posedge clk);

    probar(REINICIO,      4'b1111, 4'b1111, "reinicio");
    probar(SUMA,          4'b0011, 4'b0100, "3 + 4 = 7");
    probar(SUMA,          4'b1110, 4'b0011, "-2 + 3 = 1");
    probar(SUMA,          4'b0111, 4'b0011, "overflow 7 + 3");
    probar(RESTA,         4'b0101, 4'b0010, "5 - 2 = 3");
    probar(RESTA,         4'b0010, 4'b0101, "2 - 5 = -3");
    probar(RESTA,         4'b1011, 4'b1110, "-5 - (-2) = -3");
    probar(RESTA_INVERSA, 4'b1010, 4'b0001, "1 - (-6) = 7");
    probar(RESTA_INVERSA, 4'b0111, 4'b1000, "overflow -8 - 7 = -15");
    probar(SL,            4'b0011, 4'b0000, "shift left 0");
    probar(SL,            4'b0011, 4'b0001, "shift left 1");
    probar(SL,            4'b0011, 4'b0011, "shift left 3 truncado");
    probar(SR,            4'b1100, 4'b0000, "shift right 0");
    probar(SR,            4'b1100, 4'b0001, "shift right 1");
    probar(SR,            4'b1100, 4'b0011, "shift right 3");

    probar(SUMA, 4'b0010, 4'b0011, "guardar resultado previo 5");

    codigo  = RESTA;
    sel_op2 = 1'b0;
    op1     = 4'b1111;
    op2_ext = 4'b1111;
    repeat (3) @(posedge clk);
    #1;

    total_tests = total_tests + 1;
    if (resultado !== 4'b0101) begin
      $display("FAIL registro: resultado cambio sin ejecutar. obtenido=%b", resultado);
    end else begin
      tests_aprobados = tests_aprobados + 1;
      $display("PASS registro mantiene valor sin ejecutar");
    end


    codigo  = RESTA;
    sel_op2 = 1'b1;
    op1     = 4'b0111;
    op2_ext = 4'b0000;

    pulso_ejecutar();

    total_tests = total_tests + 1;
    if (resultado !== 4'b0010) begin
      $display("FAIL op2 previo: esperado=0010 obtenido=%b", resultado);
    end else begin
      tests_aprobados = tests_aprobados + 1;
      $display("PASS op2 previo: 7 - 5 = 2");
    end

    probar(REINICIO, 4'b1010, 4'b0110, "reinicio despues de una operacion");

    $display("Testbenchs aprobados: %0d/%0d", tests_aprobados, total_tests);
    $finish;
  end

endmodule
