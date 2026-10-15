# Simulation Instructions

## Requirements

- Icarus Verilog with SystemVerilog support
- A terminal opened at the project root

## Compile

```powershell
iverilog -g2012 -o counter_sim.exe src/counter_fsm.sv src/hex_to_7seg.sv src/counter_top.sv tb/counter_tb.sv
```

## Run

```powershell
vvp counter_sim.exe
```

## Verification

Check the testbench output for:

- Reset behavior
- RUN and HOLD functionality
- Counter increment and rollover
- Seven-segment decoder output

The design is considered verified only after the testbench produces the expected results.
