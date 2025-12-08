#!/usr/bin/env -S jq -Rnf

def box($b): [$b, .mem] | until(.[0] == .[1]; [last[first]] + .)[1:-1];

["[\(inputs)]" | fromjson] | . as $box | length as $num
| {$num, mem: [range($num)], lap: pow(10; $num | log10 | floor), que: [
    range(1; $num) as $i | range($i) as $j | [hypot(hypot(
      $box[$i][0] - $box[$j][0]; $box[$i][1] - $box[$j][1]
    ); $box[$i][2] - $box[$j][2]), $i, $j]
  ] | sort}

| [while(.num > 1;
    [box(.que[0][1,2])] as [$i,[$j0]] | .lap -= 1 | .que |= .[1:]
    | if $i[0] != $j0 then .mem[$i[]] = $j0 | .num -= 1 end
  ) | select(.lap == 0 or .num == 2)]

| [first | [box(range($num))[0]] | group_by(.)[] | length],
  [last | $box[.que[0][1,2]][0]] | reduce sort[-3:][] as $mul (1; . * $mul)
