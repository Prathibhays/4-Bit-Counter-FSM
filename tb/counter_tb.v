`timescale 1ns/1ps

module counter_tb;
    reg clk = 1'b0;
    reg reset = 1'b0;
    reg run = 1'b0;
    wire [3:0] count;
    wire [6:0] seg;

    integer errors = 0;
    integer i;

    counter_top dut (
        .clk(clk),
        .reset(reset),
        .run(run),
        .count(count),
        .seg(seg)
    );

    always #5 clk = ~clk;

    // Generates counter_fsm.vcd for GTKWave.
    initial begin
        $dumpfile("counter_fsm.vcd");
        $dumpvars(0, counter_tb);
    end

    task check_count;
        input [3:0] expected;
        input [255:0] test_name;
        begin
            if (count !== expected) begin
                $display("FAIL: %0s expected=%h actual=%h at time %0t",
                         test_name, expected, count, $time);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s count=%h at time %0t",
                         test_name, count, $time);
            end
        end
    endtask

    initial begin
        $display("Starting 4-bit counter FSM testbench");

        // Synchronous reset: assert before a rising edge.
        @(negedge clk);
        reset = 1'b1;
        run = 1'b0;
        @(posedge clk);
        #1;
        check_count(4'h0, "synchronous reset clears count");

        @(negedge clk);
        reset = 1'b0;
        run = 1'b1;

        // Check incrementing from 1 through 15.
        for (i = 1; i <= 15; i = i + 1) begin
            @(posedge clk);
            #1;
            check_count(i[3:0], "RUN increments count");
        end

        // Next RUN clock edge must wrap F -> 0.
        @(posedge clk);
        #1;
        check_count(4'h0, "counter wraps F to 0");

        // HOLD must preserve count.
        @(negedge clk);
        run = 1'b0;
        @(posedge clk);
        #1;
        check_count(4'h0, "HOLD keeps count unchanged");

        // Increment a few cycles, then verify hold at a nonzero value.
        @(negedge clk);
        run = 1'b1;
        repeat (3) begin
            @(posedge clk);
            #1;
        end
        check_count(4'h3, "RUN reaches 3");

        @(negedge clk);
        run = 1'b0;
        repeat (3) begin
            @(posedge clk);
            #1;
            check_count(4'h3, "HOLD preserves nonzero count");
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);

        #10;
        $finish;
    end
endmodule
