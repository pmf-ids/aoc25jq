#!/usr/bin/env -S jq -Rnf

[inputs / ""] | [last | map(select(. != " ")), [
  [paths(. != " ")[]] | while(has(0); .[1:]) | {start: .[0], end: .[1]}
]] as [$ops, $col] | .[:-1] | map([.[$col[]]]) | transpose | ., map(transpose)

| [$ops, map(map(add | trim | tonumber? // empty))] | add(transpose[]
    | add(select(first == "+")[1][]) // reduce last[] as $n (1; . * $n)
  )
