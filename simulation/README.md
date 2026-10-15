# Simulation

From the project root in Windows CMD, compile and run:

```bat
C:\iverilog12\bin\iverilog.exe -g2012 -s counter_tb -o counter_sim.exe src\counter_fsm.sv src\hex_to_7seg.sv src\counter_top.sv tb\counter_tb.sv
C:\iverilog12\bin\vvp.exe counter_sim.exe
```

If Icarus Verilog is installed in another folder, replace `C:\iverilog12\bin\` with your actual `bin` path. A successful run ends with `ALL TESTS PASSED`.
