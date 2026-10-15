# 7-Segment Decoder Truth Table

Convention: `seg[6:0] = {a,b,c,d,e,f,g}`; common-cathode, active-high.

| Hex | seg[6:0] | Lit segments |
|---:|---|---|
| 0 | `1111110` | abcdef |
| 1 | `0110000` | bc |
| 2 | `1101101` | abdeg |
| 3 | `1111001` | abcdg |
| 4 | `0110011` | bcfg |
| 5 | `1011011` | acdfg |
| 6 | `1011111` | acdefg |
| 7 | `1110000` | abc |
| 8 | `1111111` | abcdefg |
| 9 | `1111011` | abcdfg |
| A | `1110111` | abcefg |
| b | `0011111` | cdefg |
| C | `1001110` | adef |
| d | `0111101` | bcdeg |
| E | `1001111` | adefg |
| F | `1000111` | aefg |
