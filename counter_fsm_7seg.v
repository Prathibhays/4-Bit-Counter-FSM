`timescale 1ns/1ps
// 4-bit RUN/HOLD counter with common-cathode 7-segment output.
// seg[6:0] = {a,b,c,d,e,f,g}; active high.

module counter_fsm_7seg(
    input clk, reset, run,
    output reg [3:0] count,
    output [6:0] seg
);
    localparam HOLD = 1'b0, RUN = 1'b1;
    reg state, next_state;
    wire [3:0] incremented_count;
    wire [3:0] count_d;

    // Moore FSM: state indicates RUN or HOLD.
    always @(*) begin
        case (state)
            HOLD:    next_state = run ? RUN : HOLD;
            RUN:     next_state = run ? RUN : HOLD;
            default: next_state = HOLD;
        endcase
    end

    // 2-to-1 mux: run=1 selects count+1; run=0 selects count.
    assign incremented_count = count + 4'b0001;
    assign count_d = run ? incremented_count : count;

    // Synchronous, active-high reset.
    always @(posedge clk) begin
        if (reset) begin
            state <= HOLD;
            count <= 4'b0000;
        end else begin
            state <= next_state;
            count <= count_d;
        end
    end

    hex7seg_decoder decoder(.hex(count), .seg(seg));
endmodule

module hex7seg_decoder(
    input [3:0] hex,
    output reg [6:0] seg
);
    // Common cathode, active high; bit order {a,b,c,d,e,f,g}.
    always @(*) begin
        case (hex)
            4'h0: seg = 7'b1111110;
            4'h1: seg = 7'b0110000;
            4'h2: seg = 7'b1101101;
            4'h3: seg = 7'b1111001;
            4'h4: seg = 7'b0110011;
            4'h5: seg = 7'b1011011;
            4'h6: seg = 7'b1011111;
            4'h7: seg = 7'b1110000;
            4'h8: seg = 7'b1111111;
            4'h9: seg = 7'b1111011;
            4'hA: seg = 7'b1110111;
            4'hB: seg = 7'b0011111;
            4'hC: seg = 7'b1001110;
            4'hD: seg = 7'b0111101;
            4'hE: seg = 7'b1001111;
            4'hF: seg = 7'b1000111;
            default: seg = 7'b0000000;
        endcase
    end
endmodule
