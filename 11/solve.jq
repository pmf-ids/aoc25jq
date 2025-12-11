#!/usr/bin/env -S jq -Rnf

[inputs | {key: .[:3], value: .[5:] / " "}] | from_entries as $g

| def f($p): if .[$p] then . elif $g[$p] then
    reduce $g[$p][] as $n (.; f($n)) | .[$p] = add(.[$g[$p][]])
  else .[$p] = 0 end; def f($p;$q): {$q: 1} | f($p)[$p];

(["you"], ["svr"] + (["dac", "fft"] | ., reverse)) + ["out"]
| reduce while(has(1); .[1:]) as [$p,$q] (1; . * f($p;$q)) | select(. > 0)
