LEVEL-2 PROBLEM 2: 4-Bit Counter FSM with RUN/HOLD and 7-Segment Output
========================================================================

FILES
-----
counter_fsm_7seg.v       RTL design: FSM, counter mux, decoder
tb_counter_fsm_7seg.v    Testbench; creates counter_fsm_7seg.vcd
README.txt               Instructions and report reference

INTERFACE
---------
Inputs: clk, reset (synchronous active-high), run
Outputs: count[3:0], seg[6:0]
Display: common-cathode, active-high, seg[6:0]={a,b,c,d,e,f,g}.

FSM STATE DIAGRAM (text)
------------------------
             run=1                 run=1
       +--------------> RUN <----------------+
       |                  |                  |
       |                  | run=0            | run=1
       |                  v                  |
      HOLD <--------------+------------------+
       ^       run=0
       +------- HOLD self-loop (run=0)

All transitions:
  HOLD --run=0--> HOLD
  HOLD --run=1--> RUN
  RUN  --run=0--> HOLD
  RUN  --run=1--> RUN

NEXT-COUNT / MUX
----------------
run | next_count
----+----------------------
 0  | count (hold current)
 1  | count + 1 (modulo 16)

A 4-bit incrementer calculates count+1. Four 2:1 muxes select
between count+1 and count using run as the select signal. Their
outputs connect to the D inputs of four D flip-flops. The Q outputs
are count[3:0]. Reset synchronously clears count and sets FSM state
to HOLD.

7-SEGMENT TRUTH TABLE
---------------------
Common cathode, active high; bit order {a,b,c,d,e,f,g}.

Hex | a b c d e f g | seg[6:0]
----+---------------+---------
 0  | 1 1 1 1 1 1 0 | 1111110
 1  | 0 1 1 0 0 0 0 | 0110000
 2  | 1 1 0 1 1 0 1 | 1101101
 3  | 1 1 1 1 0 0 1 | 1111001
 4  | 0 1 1 0 0 1 1 | 0110011
 5  | 1 0 1 1 0 1 1 | 1011011
 6  | 1 0 1 1 1 1 1 | 1011111
 7  | 1 1 1 0 0 0 0 | 1110000
 8  | 1 1 1 1 1 1 1 | 1111111
 9  | 1 1 1 1 0 1 1 | 1111011
 A  | 1 1 1 0 1 1 1 | 1110111
 b  | 0 0 1 1 1 1 1 | 0011111
 C  | 1 0 0 1 1 1 0 | 1001110
 d  | 0 1 1 1 1 0 1 | 0111101
 E  | 1 0 0 1 1 1 1 | 1001111
 F  | 1 0 0 0 1 1 1 | 1000111

RUN IN WINDOWS POWERSHELL
-------------------------
Put both .v files in the same folder. Open PowerShell in that folder.
Example if extracted under Downloads:

  cd "$HOME\Downloads\counter_fsm_7segment_iverilog"

Compile (matching your C:\iverilog\bin installation):

  & "C:\iverilog\bin\iverilog.exe" -o test counter_fsm_7seg.v tb_counter_fsm_7seg.v

Run:

  & "C:\iverilog\bin\vvp.exe" test

Open GTKWave:

  & "C:\iverilog\bin\gtkwave.exe" counter_fsm_7seg.vcd

If Icarus tools are already on PATH, use iverilog, vvp and gtkwave
without their full paths.

GTKWave SIGNALS
----------------
Expand tb_counter_fsm_7seg and add:
  clk, reset, run, count, seg
Also expand dut to inspect:
  dut.state, dut.next_state, dut.incremented_count, dut.count_d

EXPECTED TEST RESULT
--------------------
The testbench checks synchronous reset, RUN increments, HOLD behavior,
resume after HOLD, all counter values, F-to-0 wraparound, and matching
7-segment patterns. Successful completion prints:

  ALL COUNTER AND DISPLAY TESTS PASSED.

The RTL uses Verilog-2001 constructs and runs with Icarus Verilog.
