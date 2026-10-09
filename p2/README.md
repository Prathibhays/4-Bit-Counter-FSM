# Person 2 - 4-Bit Counter + MUX

This folder contains the complete Person 2 contribution for the
4-Bit Counter FSM with RUN/HOLD Control and 7-Segment Output project.

## Contents

- `counter_fsm.sv` - 4-bit counter with 2:1 MUX and four D flip-flops
- `counter_fsm_tb.sv` - testbench for reset, RUN, HOLD and wrap-around
- `mux_counter_diagram.svg` - MUX/counter architecture diagram
- `dff_diagram.svg` - four D flip-flop diagram
- `next_count_truth_table.md` - next-count truth table
- `modulo_16_explanation.md` - modulo-16 explanation
- `person2_notes.md` - contribution summary

## Compile

Using Icarus Verilog:

```bash
iverilog -g2012 -o counter_sim counter_fsm.sv counter_fsm_tb.sv
vvp counter_sim
```

The testbench should report PASS for reset, counting, HOLD and
1111 -> 0000 wrap-around.

## Module

```text
counter_fsm(
    clk,
    reset,
    run,
    count[3:0]
)
```

## Important

The reset is synchronous and active-high.
The 2:1 MUX is controlled by `run`:

- `run = 0`: select `count`
- `run = 1`: select `count + 1`
