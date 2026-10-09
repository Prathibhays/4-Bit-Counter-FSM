# Person 2 Contribution

## Responsibility

- 4-bit counter
- 2-to-1 MUX next-count logic
- Four D flip-flops
- Synchronous active-high reset
- Modulo-16 wrap-around
- Counter-specific verification

## Main Module

`counter_fsm.sv`

## Testbench

`counter_fsm_tb.sv`

## Hardware Concept

```text
                count + 1
                    |
                    v
               +---------+
 count ------->|  2:1    |----> next_count
               |   MUX   |
               +----+----+
                    |
                   run
                    |
                    v
              +-------------+
              | 4 D Flip-   |
              |   Flops     |
              +------+------+
                     |
                     v
                  count[3:0]
                     |
                     +------ feedback to MUX
```

## Module Interface

```text
clk   : clock
reset : synchronous active-high reset
run   : RUN/HOLD control
count : 4-bit counter output
```

## Expected Behavior

```text
reset = 1 → 0000
run = 0   → HOLD
run = 1   → increment
1111 + 1  → 0000
```
