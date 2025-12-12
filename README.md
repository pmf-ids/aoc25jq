
# Solving [Advent of Code 2025](https://adventofcode.com/2025/) in [jq](https://jqlang.org/)

- Each day's solution lives in its own, single, self‑contained `.jq` script file that can independently be processed by jq from the command-line
- A day's puzzle input can be read either from stdin or from a file passed as an argument
- The answers to each part of a day's puzzle are provided as an output stream
- Whether the input is interpreted and/or the output rendered as JSON or as raw text depends on that day's formatting of the input data and/or its expected result, and is declared explicitly in each file

## Execution

These solutions expect the JSON processor [jq](https://jqlang.org/) to be available in [version 1.8.1](https://github.com/jqlang/jq/releases/tag/jq-1.8.1) (released Jul 1, 2025). However, they should generally also work with other versions of jq, likely right out of the box, or at worst with some minor migrational adjustments.

### On Linux / macOS (in a POSIX‑compatible environment)

Every script file starts with a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)), e.g. `#!/usr/bin/env -S jq -Rnf`, which tells your OS how to invoke jq. So, just make the script file executable, e.g. using `chmod +x`, and run it with the puzzle data either redirected, or provided as an input file argument:

```sh
chmod +x solve.jq       # make it executable (only needed once)
./solve.jq input.txt    # or: ./solve.jq < input.txt
```

### On Windows (or any OS that supports calling jq explicitly)

Invoke the jq binary, e.g. `jq.exe`, and pass these arguments:
- all format flags for that day (find them in the script's header line)
- the `--from-file` (or `-f`) option followed by the script's file name
- the puzzle input's file name

For a script starting with `#!/usr/bin/env -S jq -Rnf`, the command could be:

```bat
jq.exe -R -n -f solve.jq input.txt
```

### Example (Day 07)

#### Script file `solve.jq`:

```jq
#!/usr/bin/env -S jq -Rf

reduce (inputs / "")[["^"]] as $row ([0, [explode[] % 2]];
  last as $mem | reduce $row[] as $pos (.; if $mem[$pos] > 0 then
    first += 1 | last[$pos + (-1,1)] += $mem[$pos] | last[$pos] = 0
  end)
) | first, (last | add)
```

#### Input file `example.txt`:

```
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
```

#### Execution:

Either one works on MyMachine™:
```sh
# Using the shebang
./solve.jq example.txt
```
```sh
# Calling jq explicitly
jq -Rf solve.jq example.txt
```

#### Output:

```
21
40
```

## Performance

Times were measured with [hyperfine](https://github.com/sharkdp/hyperfine) on MyMachine™ (1.7 GHz); the displayed value is the average over at least 10 runs. Note that jq is single-threaded and uses only one CPU core.

| Day           | Name                           | Runtime     |
|:-------------:|:-------------------------------|:------------|
| **01** | [Secret Entrance](01/solve.jq) | <code>███░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;229&nbsp;ms</code> |
| **02** | [Gift Shop](02/solve.jq) | <code>█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;&nbsp;&nbsp;4&nbsp;ms</code> |
| **03** | [Lobby](03/solve.jq) | <code>█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;&nbsp;45&nbsp;ms</code> |
| **04** | [Printing Department](04/solve.jq) | <code>████████████░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;930&nbsp;ms</code> |
| **05** | [Cafeteria](05/solve.jq) | <code>█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;&nbsp;&nbsp;8&nbsp;ms</code> |
| **06** | [Trash Compactor](06/solve.jq) | <code>█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;&nbsp;42&nbsp;ms</code> |
| **07** | [Laboratories](07/solve.jq) | <code>█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;&nbsp;31&nbsp;ms</code> |
| **08** | [Playground](08/solve.jq) | <code>██████████████████████████████&nbsp;2410&nbsp;ms</code> |
| **09** | [Movie Theater](09/solve.jq) | n/a |
| **10** | [Factory](10/solve.jq) | n/a |
| **11** | [Reactor](11/solve.jq) | <code>█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;&nbsp;16&nbsp;ms</code> |
| **12** | [Christmas Tree Farm](12/solve.jq) | <code>█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░&nbsp;&nbsp;&nbsp;67&nbsp;ms</code> |
|               | **Total time**                 | <code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3782&nbsp;ms</code>   |

