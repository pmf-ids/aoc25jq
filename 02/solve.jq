#!/usr/bin/env -S jq -Rf

[splits(",") / "-" | map(tonumber)] as $in

| [[[1],1], [[2],1], [[3,2,1],1], [[4],3], [[5,2,1]] | first, .]

| [transpose[] | add(foreach .[] as $s (10; . * 10;
    ($s | numbers | exp10 - 1) as $p | ((. - 1) / $p) as $q
    | [$s - 1 | (exp10, $p) * $q] | $in[] as [$a, $b]
    | [fmax(first; $a / $q | ceil * $q), fmin(last; $b)]
    | select(. == sort) | ((last - first) / $q | trunc) as $n
    | first * ($n + 1) + $q * ($n + 1) * $n / 2
  ))]

| first, add - last * 2
