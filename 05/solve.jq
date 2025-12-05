#!/usr/bin/env -S jq -Rnf

[inputs / "-" | map(tonumber)] | group_by(length) | [.[1][][]] as $ids

| last | reduce sort[] as $rng ([];
    . + $rng | if .[-3] >= .[-2] then .[-3:] |= [max] end
  )
| add(bsearch($ids[]) | fmax(.; -. - 1) % 2), (. + [length / 2]
    | until(length == 1; .[-3:] |= [add - 2 * first])[]
  )
