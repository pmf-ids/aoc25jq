#!/usr/bin/env -S jq -Rnf

def rec($n): if $n > length then empty elif $n == 0 then "" else
  .[indices("\(9 - range(9))")[]:] | .[:1] + (.[1:] | rec($n - 1))
end;

[inputs] | (2,12) as $w | map(first(rec($w)) | tonumber) | add
