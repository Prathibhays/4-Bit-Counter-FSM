`timescale 1ns/1ps
module tb_counter_fsm_7seg;
    reg clk, reset, run;
    wire [3:0] count;
    wire [6:0] seg;
    reg [3:0] expected_count;
    integer errors, i;

    counter_fsm_7seg dut(
        .clk(clk), .reset(reset), .run(run),
        .count(count), .seg(seg)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    function [6:0] expected_segments;
        input [3:0] value;
        begin
            case (value)
                4'h0: expected_segments=7'b1111110;
                4'h1: expected_segments=7'b0110000;
                4'h2: expected_segments=7'b1101101;
                4'h3: expected_segments=7'b1111001;
                4'h4: expected_segments=7'b0110011;
                4'h5: expected_segments=7'b1011011;
                4'h6: expected_segments=7'b1011111;
                4'h7: expected_segments=7'b1110000;
                4'h8: expected_segments=7'b1111111;
                4'h9: expected_segments=7'b1111011;
                4'hA: expected_segments=7'b1110111;
                4'hB: expected_segments=7'b0011111;
                4'hC: expected_segments=7'b1001110;
                4'hD: expected_segments=7'b0111101;
                4'hE: expected_segments=7'b1001111;
                4'hF: expected_segments=7'b1000111;
                default: expected_segments=7'b0000000;
            endcase
        end
    endfunction

    task check;
        input [3:0] wanted;
        begin
            if (count !== wanted) begin
                errors = errors + 1;
                $display("FAIL count expected=%h actual=%h at %0t",
                         wanted, count, $time);
            end
            if (seg !== expected_segments(wanted)) begin
                errors = errors + 1;
                $display("FAIL seg for count=%h expected=%b actual=%b",
                         wanted, expected_segments(wanted), seg);
            end
            if ((count === wanted) && (seg === expected_segments(wanted)))
                $display("PASS count=%h seg=%b run=%b reset=%b",
                         count, seg, run, reset);
        end
    endtask

    task tick;
        input [3:0] wanted;
        begin
            @(posedge clk);
            #1;
            check(wanted);
        end
    endtask

    initial begin
        $dumpfile("counter_fsm_7seg.vcd");
        $dumpvars(0, tb_counter_fsm_7seg);
        errors = 0;
        reset = 1'b1;
        run = 1'b0;
        tick(4'h0);
        reset = 1'b0;

        // Count while RUN.
        run = 1'b1;
        tick(4'h1);
        tick(4'h2);
        tick(4'h3);
        tick(4'h4);

        // Hold the current value for multiple clocks.
        run = 1'b0;
        tick(4'h4);
        tick(4'h4);
        tick(4'h4);

        // Resume counting.
        run = 1'b1;
        tick(4'h5);
        tick(4'h6);

        // Reset, then verify every value including F -> 0 wraparound.
        reset = 1'b1;
        run = 1'b0;
        tick(4'h0);
        reset = 1'b0;
        run = 1'b1;
        expected_count = 4'h0;
        for (i = 0; i < 16; i = i + 1) begin
            expected_count = expected_count + 4'h1;
            tick(expected_count);
        end

        // Verify HOLD after wraparound.
        run = 1'b0;
        tick(4'h0);
        tick(4'h0);

        if (errors == 0)
            $display("\nALL COUNTER AND DISPLAY TESTS PASSED.");
        else
            $display("\nTESTS FAILED: %0d error(s).", errors);
        #10;
        $finish;
    end
endmodule
