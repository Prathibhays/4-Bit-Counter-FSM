// ============================================================
// Testbench for counter_fsm
// Person 2 - Counter Verification
//
// Tests:
//   1. Synchronous reset
//   2. Counting while run = 1
//   3. Holding while run = 0
//   4. Modulo-16 wrap: 1111 -> 0000
// ============================================================

`timescale 1ns/1ps

module counter_fsm_tb;

    logic       clk;
    logic       reset;
    logic       run;
    logic [3:0] count;

    // DUT
    counter_fsm dut (
        .clk   (clk),
        .reset (reset),
        .run   (run),
        .count (count)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    // Helper task for checking the count
    task automatic check_count(
        input logic [3:0] expected,
        input string test_name
    );
        begin
            if (count !== expected)
                $error("FAIL: %s | Expected %b, Got %b",
                       test_name, expected, count);
            else
                $display("PASS: %s | count = %b",
                         test_name, count);
        end
    endtask

    initial begin
        // Initial conditions
        clk   = 1'b0;
        reset = 1'b1;
        run   = 1'b0;

        // ----------------------------------------------------
        // TEST 1: Synchronous Reset
        // ----------------------------------------------------
        @(posedge clk);
        #1;
        check_count(4'b0000, "Synchronous reset");

        // Release reset
        reset = 1'b0;

        // ----------------------------------------------------
        // TEST 2: RUN - Counter increments
        // ----------------------------------------------------
        run = 1'b1;

        @(posedge clk);
        #1;
        check_count(4'b0001, "RUN: 0000 -> 0001");

        @(posedge clk);
        #1;
        check_count(4'b0010, "RUN: 0001 -> 0010");

        @(posedge clk);
        #1;
        check_count(4'b0011, "RUN: 0010 -> 0011");

        @(posedge clk);
        #1;
        check_count(4'b0100, "RUN: 0011 -> 0100");

        // ----------------------------------------------------
        // TEST 3: HOLD - Counter does not change
        // ----------------------------------------------------
        run = 1'b0;

        @(posedge clk);
        #1;
        check_count(4'b0100, "HOLD: count remains 0100");

        @(posedge clk);
        #1;
        check_count(4'b0100, "HOLD: count remains 0100");

        @(posedge clk);
        #1;
        check_count(4'b0100, "HOLD: count remains 0100");

        // ----------------------------------------------------
        // TEST 4: Continue RUN until 1111
        // ----------------------------------------------------
        run = 1'b1;

        // 0100 -> 0101 -> ... -> 1111
        repeat (11) begin
            @(posedge clk);
            #1;
        end

        check_count(4'b1111, "RUN: reached maximum 1111");

        // ----------------------------------------------------
        // TEST 5: Modulo-16 Wrap
        // ----------------------------------------------------
        @(posedge clk);
        #1;
        check_count(4'b0000, "WRAP: 1111 -> 0000");

        // ----------------------------------------------------
        // TEST 6: Continue after wrap
        // ----------------------------------------------------
        @(posedge clk);
        #1;
        check_count(4'b0001, "After wrap: 0000 -> 0001");

        $display("");
        $display("==============================================");
        $display("All Person 2 counter tests completed.");
        $display("==============================================");

        $finish;
    end

endmodule
