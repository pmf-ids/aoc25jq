#!/usr/bin/env -S jq -Rsf

gsub("L";"-") | [scan("-?\\d+") | tonumber]

| reduce .[] as $p ([50, [0,0]]; first += $p | [
    (first % 100 + 100) % 100, [
      last[0] + if first % 100 == 0 then 1 else 0 end,
      last[1] + (first | fabs / 100 | trunc) +
      if $p < first and first <= 0 then 1 else 0 end
    ]
  ]) | last[]
