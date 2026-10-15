`timescale 1ns/1ps
module counter_top (
    input logic clk, reset, run,
    output logic [3:0] count,
    output logic [6:0] seg
);
    counter_fsm u_counter (
        .clk(clk), .reset(reset), .run(run), .count(count)
    );
    hex_to_7seg u_decoder (
        .hex(count), .seg(seg)
    );
endmodule
