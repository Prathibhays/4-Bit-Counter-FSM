`timescale 1ns/1ps
module counter_tb;
    logic clk = 1'b0;
    logic reset = 1'b0;
    logic run = 1'b0;
    logic [3:0] count;
    logic [6:0] seg;

    logic [3:0] decoder_hex;
    logic [6:0] decoder_seg;

    counter_top dut (
        .clk(clk), .reset(reset), .run(run), .count(count), .seg(seg)
    );
    hex_to_7seg decoder_check (.hex(decoder_hex), .seg(decoder_seg));

    always #5 clk = ~clk;

    task automatic check_count(input logic [3:0] expected, input string label_text);
        begin
            #1;
            if (count !== expected) begin
                $display("FAIL: %s expected=%h got=%h at %0t",
                         label_text, expected, count, $time);
                $fatal(1);
            end else begin
                $display("PASS: %s count=%h seg=%b at %0t",
                         label_text, count, seg, $time);
            end
        end
    endtask

    task automatic check_decoder(input logic [3:0] value,
                                  input logic [6:0] expected);
        begin
            decoder_hex = value;
            #1;
            if (decoder_seg !== expected) begin
                $display("FAIL: decoder hex=%h expected=%b got=%b",
                         value, expected, decoder_seg);
                $fatal(1);
            end else begin
                $display("PASS: decoder hex=%h seg=%b", value, decoder_seg);
            end
        end
    endtask

    integer i;
    initial begin
        $dumpfile("counter_fsm.vcd");
        $dumpvars(0, counter_tb);
        decoder_hex = 4'h0;

        // Synchronous reset
        reset = 1'b1;
        run = 1'b0;
        @(posedge clk);
        check_count(4'h0, "synchronous reset");
        reset = 1'b0;

        // HOLD at zero
        repeat (3) begin
            @(posedge clk);
            check_count(4'h0, "HOLD keeps count");
        end

        // RUN increments
        run = 1'b1;
        for (i = 1; i <= 5; i = i + 1) begin
            @(posedge clk);
            check_count(i[3:0], "RUN increments");
        end

        // HOLD preserves current value
        run = 1'b0;
        repeat (3) begin
            @(posedge clk);
            check_count(4'h5, "HOLD preserves count");
        end

        // Reset, then count through F and wrap to 0
        reset = 1'b1;
        @(posedge clk);
        check_count(4'h0, "reset before wrap test");
        reset = 1'b0;
        run = 1'b1;
        for (i = 1; i <= 15; i = i + 1) begin
            @(posedge clk);
            check_count(i[3:0], "count toward F");
        end
        @(posedge clk);
        check_count(4'h0, "wrap F to 0");

        // Full 16-value decoder truth-table test
        check_decoder(4'h0, 7'b1111110);
        check_decoder(4'h1, 7'b0110000);
        check_decoder(4'h2, 7'b1101101);
        check_decoder(4'h3, 7'b1111001);
        check_decoder(4'h4, 7'b0110011);
        check_decoder(4'h5, 7'b1011011);
        check_decoder(4'h6, 7'b1011111);
        check_decoder(4'h7, 7'b1110000);
        check_decoder(4'h8, 7'b1111111);
        check_decoder(4'h9, 7'b1111011);
        check_decoder(4'hA, 7'b1110111);
        check_decoder(4'hB, 7'b0011111);
        check_decoder(4'hC, 7'b1001110);
        check_decoder(4'hD, 7'b0111101);
        check_decoder(4'hE, 7'b1001111);
        check_decoder(4'hF, 7'b1000111);

        $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
