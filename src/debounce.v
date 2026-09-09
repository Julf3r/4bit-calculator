module debounce #(
    parameter COUNT_MAX = 250000
)(
    input  clk,
    input  noisy,
    output reg clean
);

    reg [18:0] count;
    reg sync0;
    reg sync1;

    initial begin
        count = 0;
        clean = 0;
        sync0 = 0;
        sync1 = 0;
    end

    // Sincronización básica
    always @(posedge clk) begin
        sync0 <= noisy;
        sync1 <= sync0;
    end

    // Si el valor cambia, esperamos que permanezca estable
    always @(posedge clk) begin
        if (sync1 == clean) begin
            count <= 0;
        end
        else begin
            if (count == COUNT_MAX - 1) begin
                clean <= sync1;
                count <= 0;
            end
            else begin
                count <= count + 1;
            end
        end
    end

endmodule