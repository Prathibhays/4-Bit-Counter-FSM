// ============================================================
// 4-Bit Counter with RUN/HOLD Control
// Person 2 - Counter + 2:1 MUX + 4 D Flip-Flops
//
// Inputs:
//   clk   : Clock
//   reset : Synchronous, active-high reset
//   run   : RUN/HOLD control
//
// Output:
//   count : 4-bit modulo-16 counter
//
// Behavior:
//   run = 1 -> count increments by 1 every rising clock edge
//   run = 0 -> count holds its current value
//   reset = 1 -> count becomes 0000 at the next rising edge
// ============================================================

module counter_fsm (
    input  logic       clk,
    input  logic       reset,
    input  logic       run,
    output logic [3:0] count
);

    logic [3:0] next_count;

    // 2-to-1 MUX:
    // run = 0 -> select current count (HOLD)
    // run = 1 -> select count + 1 (RUN)
    assign next_count = run ? (count + 4'b0001) : count;

    // Four D flip-flops with synchronous active-high reset
    always_ff @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else
            count <= next_count;
    end

endmodule
