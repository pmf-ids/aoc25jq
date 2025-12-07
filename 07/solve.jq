#!/usr/bin/env -S jq -Rf

reduce (inputs / "")[["^"]] as $row ([0, [explode[] % 2]];
  last as $mem | reduce $row[] as $pos (.; if $mem[$pos] > 0 then
    first += 1 | last[$pos + (-1,1)] += $mem[$pos] | last[$pos] = 0
  end)
) | first, (last | add)
