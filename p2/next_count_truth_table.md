# Next-Count Truth Table

## MUX Selection

The next-count logic is implemented using a 2-to-1 MUX.

| run | MUX selection | next_count | Operation |
|-----|---------------|------------|-----------|
| 0 | count | count | HOLD |
| 1 | count + 1 | count + 1 (mod 16) | RUN |

## Representative Counter Values

| run | Current count | Next count | Operation |
|-----|---------------|------------|-----------|
| 0 | 0000 | 0000 | HOLD |
| 0 | 0101 | 0101 | HOLD |
| 0 | 1111 | 1111 | HOLD |
| 1 | 0000 | 0001 | Increment |
| 1 | 0001 | 0010 | Increment |
| 1 | 0010 | 0011 | Increment |
| 1 | 0011 | 0100 | Increment |
| 1 | 0100 | 0101 | Increment |
| 1 | 0101 | 0110 | Increment |
| 1 | 0110 | 0111 | Increment |
| 1 | 0111 | 1000 | Increment |
| 1 | 1000 | 1001 | Increment |
| 1 | 1001 | 1010 | Increment |
| 1 | 1010 | 1011 | Increment |
| 1 | 1011 | 1100 | Increment |
| 1 | 1100 | 1101 | Increment |
| 1 | 1101 | 1110 | Increment |
| 1 | 1110 | 1111 | Increment |
| 1 | 1111 | 0000 | Wrap-around |

## Logic Equation

```text
next_count = run ? (count + 1) : count
```

Since the counter stores only four bits, the carry beyond bit 3 is discarded. Therefore:

```text
1111 + 0001 = 1 0000
                  ^
                  discarded

stored count = 0000
```
