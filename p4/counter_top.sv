module counter_top (
    input  logic       clk,
    input  logic       reset,
    input  logic       run,
    output logic [3:0] count,
    output logic [6:0] seg
);

    counter_fsm counter_inst (
        .clk   (clk),
        .reset (reset),
        .run   (run),
        .count (count)
    );

    hex_to_7seg decoder_inst (
        .count (count),
        .seg   (seg)
    );

endmodule
