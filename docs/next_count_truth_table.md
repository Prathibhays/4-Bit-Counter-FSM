# Next-count logic truth table

| run | MUX select | Selected input | Next count |
|---:|---:|---|---|
| 0 | 0 | `count[3:0]` | `count` |
| 1 | 1 | `count + 4'd1` | `(count + 1) mod 16` |

The 4-bit MUX output feeds the D input of each of the four flip-flops. On a rising edge, reset overrides the MUX and synchronously clears the counter.
