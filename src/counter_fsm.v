`timescale 1ns/1ps

// 4-bit counter controlled by a 2-state Moore FSM.
// RUN: increment every rising clock edge.
// HOLD: preserve the current count.
module counter_fsm (
    input  wire       clk,
    input  wire       reset,   // synchronous, active high
    input  wire       run,
    output reg  [3:0] count
);

    localparam HOLD = 1'b0;
    localparam RUN  = 1'b1;

    reg state, next_state;

    // State register and counter register
    always @(posedge clk) begin
        if (reset) begin
            state <= HOLD;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            // MUX: run=1 selects count+1; run=0 selects count.
            if (run)
                count <= count + 4'b0001;
            else
                count <= count;
        end
    end

    // Moore FSM next-state logic
    always @(*) begin
        case (state)
            HOLD: next_state = run ? RUN : HOLD;
            RUN:  next_state = run ? RUN : HOLD;
            default: next_state = HOLD;
        endcase
    end

endmodule
