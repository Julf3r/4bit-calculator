# 4-Bit Calculator on FPGA

Proyecto 1 de **Arquitectura de Computadores**: diseño e implementación de una calculadora de 4 bits en **Verilog** para una **Lattice iCE40 HX1K** de la **Nandland Go Board**.

## Objetivo

Implementar una calculadora capaz de operar con números de 4 bits, incluyendo números negativos en complemento a dos, recorriendo el flujo completo de diseño digital:

- diseño mediante tablas de verdad y mapas de Karnaugh;
- implementación de lógica mediante compuertas;
- descripción del circuito en Verilog;
- simulación mediante testbench;
- visualización de señales en GTKWave;
- síntesis, programación y demostración en la FPGA.

## Operaciones soportadas

| Código | Operación | Resultado |
|---|---|---|
| `3'b000` | Reinicio | `R = 4'b0000` |
| `3'b001` | Suma | `R = A + B` |
| `3'b010` | Resta | `R = A - B` |
| `3'b011` | Resta inversa | `R = B - A` |
| `3'b100` | Shift left | `R = A << B[1:0]` |
| `3'b101` | Shift right | `R = A >> B[1:0]` |

Todos los cálculos utilizan 4 bits. En caso de overflow, se conservan únicamente los cuatro bits menos significativos del resultado.

> **Importante:** las expresiones anteriores describen el comportamiento esperado. La lógica combinacional sintetizable del proyecto se implementa exclusivamente mediante compuertas lógicas permitidas por el enunciado, sin utilizar directamente operadores de alto nivel como `+`, `-`, `<<`, `>>`, `if`, `case` o `?:`.

## Estructura del repositorio

```text
4bit-calculator/
├── README.md
├── apio.ini
├── .gitignore
│
├── src/
│   ├── calculator.v
│   ├── alu.v
│   ├── full_adder.v
│   └── seven_segment.v
│
├── tb/
│   ├── calculator_tb.v
│   ├── alu_tb.v
│   └── full_adder_tb.v
│
├── constraints/
│   └── go_board.pcf
│
├── docs/
│   ├── truth_tables.md
│   ├── karnaugh.md
│   └── architecture.md
│
├── report/
│   └── report.pdf
│
└── build/
```

- `src/`: módulos Verilog sintetizables que forman el circuito real.
- `tb/`: testbenches utilizados únicamente para simulación.
- `constraints/`: asignación entre señales del diseño y pines físicos de la Go Board.
- `docs/`: tablas de verdad, mapas de Karnaugh, expresiones booleanas y documentación de arquitectura.
- `report/`: informe final en PDF.
- `build/`: archivos generados durante simulación y síntesis. No se versionan en Git.

## Arquitectura general

La calculadora recibe:

- `op1`: primer operando de 4 bits;
- `operation`: selector de operación de 3 bits;
- `op2`: segundo operando externo de 4 bits;
- un selector que permite utilizar como segundo operando `op2` o el resultado anterior;
- una señal de confirmación/ejecución.

El resultado se almacena en un registro de 4 bits para permitir utilizarlo posteriormente como segundo operando.

Una posible jerarquía de módulos es:

```text
calculator
├── alu
│   ├── full_adder / adder
│   ├── subtractor
│   ├── shifter
│   └── selección de operación
├── result_register
├── input/control logic
└── seven_segment
```

## Restricciones de implementación

La lógica combinacional debe implementarse utilizando exclusivamente primitivas de compuertas de Verilog:

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

No deben utilizarse directamente en la lógica combinacional sintetizable:

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

Por ejemplo, la suma de 4 bits debe construirse a partir de sumadores implementados mediante compuertas, en lugar de escribirse como:

```verilog
assign result = A + B; // No permitido para la implementación de la operación
```

## Herramientas

El proyecto puede trabajarse desde WSL utilizando:

- Icarus Verilog (`iverilog`) para simulación;
- GTKWave para visualizar señales;
- Yosys para síntesis;
- nextpnr-ice40 para place-and-route;
- Project IceStorm para generar el bitstream;
- APIO como interfaz para automatizar el flujo de FPGA.

## Instalación en WSL

```bash
sudo apt update
sudo apt install -y \
    iverilog \
    gtkwave \
    yosys \
    nextpnr-ice40 \
    fpga-icestorm \
    python3 \
    python3-pip \
    python3-venv
```

Para APIO:

```bash
python3 -m venv ~/.venvs/apio
source ~/.venvs/apio/bin/activate
pip install --upgrade pip
pip install apio
```

Cada vez que se abra una nueva terminal y se quiera usar APIO:

```bash
source ~/.venvs/apio/bin/activate
```

## Simulación

### Calculadora completa

Desde la raíz del repositorio:

```bash
mkdir -p build

iverilog \
    -o build/calculator_tb \
    src/*.v \
    tb/calculator_tb.v

vvp build/calculator_tb
```

El testbench debe generar un archivo VCD, por ejemplo:

```verilog
initial begin
    $dumpfile("build/calculator.vcd");
    $dumpvars(0, calculator_tb);
end
```

Para visualizar las señales:

```bash
gtkwave build/calculator.vcd
```

### Testbench de un módulo individual

Ejemplo para `full_adder`:

```bash
iverilog \
    -o build/full_adder_tb \
    src/full_adder.v \
    tb/full_adder_tb.v

vvp build/full_adder_tb

gtkwave build/full_adder.vcd
```

## Build para FPGA

Si el proyecto está configurado mediante APIO:

```bash
apio build
```

Para programar la Go Board:

```bash
apio upload
```

La placa debe estar conectada por USB y disponible dentro de WSL antes de ejecutar `apio upload`.

## Interfaz física de la Go Board

La demostración utiliza los cuatro botones de la placa:

- **superior izquierdo:** incrementar el valor seleccionado;
- **inferior izquierdo:** disminuir el valor seleccionado;
- **superior derecho:** confirmar/ingresar el valor seleccionado;
- **inferior derecho:** utilizar el resultado de la operación anterior como segundo operando.

El flujo de entrada es:

1. seleccionar la operación;
2. mostrar el código de operación en los LED;
3. ingresar el primer operando;
4. ingresar el segundo operando;
5. ejecutar la operación;
6. mostrar el resultado en los displays de siete segmentos.

El primer display indica el signo y el segundo muestra el valor en hexadecimal.

Después de mostrar el resultado, una nueva pulsación del botón de confirmación devuelve la calculadora al estado inicial.

## Testbench

El testbench principal se encuentra en:

```text
tb/calculator_tb.v
```

Durante la demostración, los valores y las operaciones indicados por el profesor deben ingresarse en este testbench antes de ejecutar la simulación y visualizarla en GTKWave.

El testbench no forma parte del hardware sintetizado y, por lo tanto, no debe incluirse como fuente para la implementación física de la FPGA.

## Documentación

El informe del proyecto debe incluir, como mínimo:

- diseño general y arquitectura de la calculadora;
- tablas de verdad;
- mapas de Karnaugh;
- expresiones booleanas obtenidas;
- implementación de las operaciones mediante compuertas;
- resultados relevantes de simulación.

## Autores

- Julián  Rodríguez
- Alfonso Villanueva
- Manuel Caroca

## Curso

**Arquitectura de Computadores**  
Universidad de los Andes  
Semestre 2026-2
