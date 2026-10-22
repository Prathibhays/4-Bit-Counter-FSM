# 4-Bit Counter FSM with Run/Hold and 7-Segment Output

## Files
- `src/counter_fsm.v` — two-state RUN/HOLD FSM and 4-bit counter
- `src/hex_to_7seg.v` — combinational hexadecimal decoder
- `src/counter_top.v` — top-level integration
- `tb/counter_tb.v` — testbench and VCD generation

Segment bit order is `seg[6:0] = {a,b,c,d,e,f,g}`. Patterns are active-high for a common-cathode display.

## Compile and simulate (PowerShell)
Run these commands from the project root. Update the Icarus Verilog path if yours differs.

```powershell
& "C:\\iverilog\\bin\\iverilog.exe" -g2005 -s counter_tb -o counter_sim.exe src\\counter_fsm.v src\\hex_to_7seg.v src\\counter_top.v tb\\counter_tb.v
& "C:\\iverilog\\bin\\vvp.exe" .\\counter_sim.exe
```

The simulation writes `counter_fsm.vcd` into the current working directory.

If your Icarus Verilog version is installed elsewhere, replace `C:\\iverilog\\bin\\` with that folder. For a VCD waveform viewer, open it with GTKWave:
```powershell
gtkwave .\\counter_fsm.vcd
```

## State diagram
- HOLD -- `run=0` --> HOLD
- HOLD -- `run=1` --> RUN
- RUN -- `run=0` --> HOLD
- RUN -- `run=1` --> RUN

## Next-count truth table
| run | next count |
|---:|---|
| 0 | count |
| 1 | (count + 1) modulo 16 |

The `if (run)` counter branch implements the 2-to-1 MUX feeding the four counter flip-flops.
