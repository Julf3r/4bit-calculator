# 4-Bit Calculator on FPGA

Proyecto 1 de **Arquitectura de Computadores** de la Universidad de los Andes.  
El objetivo es diseñar una calculadora de 4 bits en **Verilog**, utilizando lógica implementada mediante compuertas, simularla con un testbench y posteriormente implementarla en una **Nandland Go Board** con FPGA **Lattice iCE40 HX1K**.

## Integrantes

- Julián Rodríguez
- Alfonso Villanueva
- Manuel Caroca

## Operaciones soportadas

| Código | Operación | Comportamiento |
|---|---|---|
| `3'b000` | Reinicio | `R = 4'b0000` |
| `3'b001` | Suma | `R = A + B` |
| `3'b010` | Resta | `R = A - B` |
| `3'b011` | Resta inversa | `R = B - A` |
| `3'b100` | Shift left | `R = A << B[1:0]` |
| `3'b101` | Shift right | `R = A >> B[1:0]` |

Las expresiones anteriores describen únicamente el **comportamiento esperado**. La implementación combinacional no utiliza directamente operadores de alto nivel como `+`, `-`, `<<`, `>>`, `if`, `case` o `?:`.

Todos los cálculos utilizan 4 bits. En caso de overflow, se conservan los cuatro bits menos significativos.

## Arquitectura

El núcleo de la calculadora recibe:

- `op1`: primer operando de 4 bits;
- `op2_ext`: segundo operando externo de 4 bits;
- `codigo`: selector de operación de 3 bits;
- `sel_op2`: selecciona entre `op2_ext` y el resultado almacenado previamente;
- `ejecutar`: habilita el almacenamiento del nuevo resultado;
- `clk`: reloj del registro de resultado.

La arquitectura general es:

```text
op2_ext ─────────────┐
                     ▼
resultado ───► selector_operando
                     │
                     ▼
               segundo operando
                     │
          ┌──────────┴───────────┐
          │                      │
          ▼                      ▼
   selector_suma           shift left/right
          │                      │
       X, Y, Cin                  │
          │                      │
          ▼                      │
   Full Adders x4                │
    Cout -> Cin                  │
          │                      │
        sigma                    │
          └──────────┬───────────┘
                     ▼
             selector_resultado
                     │
              resultado_comb
                     │
                     ▼
                 register4
                     │
                     ▼
                 resultado
```

### Operaciones aritméticas

Las cuatro operaciones con `codigo[2] = 0` utilizan los mismos cuatro full adders.

| `codigo[1:0]` | X | Y | `Cin` inicial | Operación |
|---|---|---|---|---|
| `00` | `0` | `0` | `0` | Reinicio |
| `01` | `A` | `B` | `0` | Suma |
| `10` | `A` | `~B` | `1` | Resta |
| `11` | `~A` | `B` | `1` | Resta inversa |

Las restas se implementan mediante complemento a dos.

### Shifts

Los desplazamientos se implementan mediante multiplexores construidos con compuertas. No se utilizan los operadores `<<` ni `>>`.

`B[1:0]` determina la cantidad de posiciones:

```text
00 -> 0 posiciones
01 -> 1 posición
10 -> 2 posiciones
11 -> 3 posiciones
```

Los espacios vacíos se rellenan con ceros.

## Estructura actual del repositorio

```text
4bit-calculator/
├── README.md
├── Makefile
├── .gitignore
│
├── src/
│   ├── calculadora_4bits.v
│   ├── full_adder.v
│   ├── mux2.v
│   ├── mux4.v
│   ├── mux4_1bit.v
│   ├── register4.v
│   ├── selector_operando.v
│   ├── selector_resultado.v
│   ├── selector_resultado4.v
│   ├── selector_shift.v
│   ├── selector_shift4.v
│   ├── selector_suma.v
│   ├── shift_left4.v
│   └── shift_right4.v
│
├── tb/
│   ├── calculadora_4bits_tb_basico.sv
│   └── calculadora_4bits_tb_completo.sv
│
├── build/
├── constraints/
└── docs/
```

`src/` contiene los módulos sintetizables del circuito.  
`tb/` contiene los testbenches y se utiliza únicamente para simulación.  
`build/` contiene archivos generados durante la compilación/simulación.

## Restricciones de implementación

La lógica combinacional se implementa utilizando primitivas de compuertas de Verilog, entre ellas:

```text
and
or
not
xor
nand
nor
xnor
buf
```

No se utilizan directamente en la implementación combinacional:

```text
+
-
<
>
<=
>=
<<
>>
?:
if
case
```

Por ejemplo, la suma se implementa mediante cuatro `full_adder` conectados como un **ripple-carry adder**:

```text
Cin -> FA0 -> FA1 -> FA2 -> FA3
        |      |      |      |
       S0     S1     S2     S3
```

## Requisitos para simulación

En Ubuntu/WSL:

```bash
sudo apt update
sudo apt install -y iverilog gtkwave make
```

## Ejecutar los tests

Desde la raíz del repositorio:

### Testbench básico

```bash
make basic
```

Comprueba principalmente las operaciones aritméticas básicas y casos con números negativos y overflow.

### Testbench completo

```bash
make full
```

Comprueba:

- reinicio;
- suma;
- resta;
- resta inversa;
- shift left;
- shift right;
- reutilización del resultado anterior mediante `sel_op2`.

## Visualización en GTKWave

Los testbenches generan archivos `.vcd` con las señales de la simulación.

Después de ejecutar el testbench completo:

```bash
gtkwave calculadora_4bits_tb_completo.vcd
```

Se recomienda observar al menos:

```text
clk
ejecutar
codigo
sel_op2
op1
op2_ext
resultado
```

También pueden observarse señales internas del DUT, como:

```text
f
x
y
sigma
left_value
right_value
shift_value
resultado_comb
```

Estas señales permiten seguir el recorrido de los operandos por los selectores, full adders, shifters y registro de resultado.

## Testbench

El testbench básico se encuentra en:

```text
tb/calculadora_4bits_tb_basico.sv
```

El testbench completo se encuentra en:

```text
tb/calculadora_4bits_tb_completo.sv
```

Los testbenches están escritos en **SystemVerilog**, por lo que Icarus Verilog se ejecuta con soporte `-g2012`.

El testbench no forma parte del hardware sintetizado.

## Estado actual

Actualmente se encuentra implementado y probado mediante simulación el **núcleo lógico de la calculadora**, incluyendo:

- suma;
- resta;
- resta inversa;
- shift left;
- shift right;
- reinicio;
- registro de resultado;
- reutilización del resultado anterior.

La integración física con la Go Board —control mediante botones, displays de siete segmentos, LEDs, constraints de pines y programación de la FPGA— corresponde a la siguiente etapa del proyecto.

## FPGA

La placa objetivo es:

```text
Nandland Go Board
Lattice iCE40 HX1K
ICE40HX1K-VQ100
```

La disposición de botones utilizada por el proyecto es:

```text
SW1   SW3
SW2   SW4
```

con la interfaz requerida:

```text
SW1 -> incrementar
SW2 -> disminuir
SW3 -> confirmar
SW4 -> utilizar resultado anterior
```

Para la implementación física se utilizará APIO junto con el toolchain open-source para iCE40.

## Documentación

El informe del proyecto incluye el desarrollo lógico utilizado para obtener la implementación, incluyendo:

- arquitectura general;
- tablas de verdad;
- mapas de Karnaugh;
- expresiones booleanas;
- full adder;
- selección de operaciones;
- desplazamientos;
- selectores;
- implementación mediante compuertas;
- resultados de simulación.

## Curso

**Arquitectura de Computadores**  
Universidad de los Andes  
Semestre 2026-2
