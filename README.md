# 4-Bit Counter FSM with Run/Hold Control and 7-Segment Output

## Behavior
- `run=1`: FSM is in RUN and increments on every rising clock edge.
- `run=0`: FSM is in HOLD and retains the count.
- `reset=1`: synchronous, active-high reset clears count to `0000`.
- Count wraps from `1111` to `0000`.
- `seg[6:0]` is an active-high common-cathode pattern in `{a,b,c,d,e,f,g}` order.

## Project files
- `src/counter_fsm.sv`: FSM, next-count logic, and 4-bit register.
- `src/hex_to_7seg.sv`: 16-value combinational hexadecimal decoder.
- `src/counter_top.sv`: connects the counter and decoder.
- `tb/counter_tb.sv`: tests reset, increment, hold, wrap, and all decoder patterns.
- `docs/`: state diagram description, next-count table, and 7-segment truth table.

## State transitions
| Current state | run | Next state |
|---|---:|---|
| HOLD | 0 | HOLD (self-loop) |
| HOLD | 1 | RUN |
| RUN | 0 | HOLD |
| RUN | 1 | RUN (self-loop) |

## Next-count MUX
| run | Selected input | Next count |
|---:|---|---|
| 0 | `count` | `count` |
| 1 | `count + 1` | `(count + 1) mod 16` |

## Run simulation on Windows CMD
Run these commands from the project root, adjusting the install path if yours differs:

```bat
C:\iverilog12\bin\iverilog.exe -g2012 -s counter_tb -o counter_sim.exe src\counter_fsm.sv src\hex_to_7seg.sv src\counter_top.sv tb\counter_tb.sv
C:\iverilog12\bin\vvp.exe counter_sim.exe
```

The final output should say `ALL TESTS PASSED`. The simulation also creates `counter_fsm.vcd`, which can be opened with GTKWave.
