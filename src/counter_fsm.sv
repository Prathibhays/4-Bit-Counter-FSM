`timescale 1ns/1ps
module counter_fsm (
    input logic clk, reset, run,
    output logic [3:0] count
);
    localparam logic HOLD = 1'b0;
    localparam logic RUN  = 1'b1;
    logic state, next_state;
    logic [3:0] next_count;

    always_comb begin
        case (state)
            HOLD: next_state = run ? RUN : HOLD;
            RUN:  next_state = run ? RUN : HOLD;
            default: next_state = HOLD;
        endcase
    end

    // 2-to-1 MUX: run=1 selects count+1; run=0 selects count.
    always_comb begin
        if (run) next_count = count + 4'd1;
        else     next_count = count;
    end

    // Synchronous active-high reset.
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= HOLD;
            count <= 4'd0;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end
endmodule
