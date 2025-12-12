#!/usr/bin/env -S jq -Rrnf

[limit(6; inputs | add(limit(4; inputs)) | [explode[] % 2])] as $spc
| [inputs | [scan("\\d+") | tonumber] | [.[0] * .[1], .[2:]]]

| reduce .[] as [$avl, $num] ([0, length]; [last -= 1, ., first += 1][
    [$num, $spc] | [transpose[] | [first * (last | add, length)]]
    | [transpose[] | add - 0.5] | bsearch($avl) | fmax(.; -. - 1)
  ])

| unique | join("-")
