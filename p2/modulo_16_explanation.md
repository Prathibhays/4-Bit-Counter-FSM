# Modulo-16 Counter Explanation

A 4-bit binary number can represent 16 different values:

```text
0000 through 1111
0      through 15
```

Therefore, a 4-bit counter operates modulo 16.

When `run = 1`, the counter increments:

```text
0000 → 0001 → 0010 → ... → 1110 → 1111
```

After `1111`, adding 1 produces:

```text
  1111
+ 0001
-------
1 0000
```

The counter has only four storage bits (`count[3:0]`), so the fifth carry bit is discarded:

```text
1 0000
  ↓
0000
```

Thus:

```text
1111 → 0000
```

This is called modulo-16 wrap-around.

## RUN/HOLD Behavior

When `run = 1`:

```text
next_count = count + 1
```

When `run = 0`:

```text
next_count = count
```

The 2-to-1 MUX selects which value is loaded into the four D flip-flops at the rising edge of `clk`.

## Reset

The reset is synchronous and active-high.

At a rising edge of `clk`:

```text
reset = 1 → count = 0000
reset = 0 → normal RUN/HOLD operation
```

Because reset is synchronous, changing `reset` between clock edges does not immediately change the counter.
