#!/usr/bin/env -S jq -Rnf

[inputs / ""] | [paths(. == "@")] | [.[] as $p | [bsearch($p
  | first += (-1,1), (first += (-1,1) | last += (-1,1)), last += (-1,1)
) | select(. >= 0)]] | [map(0), .]

| [last[] | select(length < 4)],
  until(first == []; reduce first[[0]][] as $i ([[], last];
    if last[$i] | . and length < 4 then reduce last[$i][] as $j (.;
      first[$j] = 0 | last[$j] -= [$i]
    ) | last[$i] = null end
  ))[1][[null]]

| length
