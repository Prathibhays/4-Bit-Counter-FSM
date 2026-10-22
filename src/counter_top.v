`timescale 1ns/1ps

module counter_top (
    input  wire       clk,
    input  wire       reset,
    input  wire       run,
    output wire [3:0] count,
    output wire [6:0] seg
);
    counter_fsm u_counter (
        .clk(clk),
        .reset(reset),
        .run(run),
        .count(count)
    );

    hex_to_7seg u_decoder (
        .hex(count),
        .seg(seg)
    );
endmodule
