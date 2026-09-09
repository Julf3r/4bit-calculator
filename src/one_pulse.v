module one_pulse (
    input  clk,
    input  signal_in,
    output pulse
);

    reg previous;

    initial previous = 1'b0;

    always @(posedge clk) begin
        previous <= signal_in;
    end

    assign pulse = signal_in & ~previous;

endmodule