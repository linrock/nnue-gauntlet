#!/bin/bash

function ordo_many() {
  ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- $*
}

nnue_name=$1
if [[ $nnue_name == *.nnue ]]; then
  echo 25k nodes
  ordo_many pgns/$nnue_name/*$nnue_name-25k*.pgn | sed 's/^/  /'
  echo STC 10+0.1
  ordo_many pgns/$nnue_name/*$nnue_name-stc*.pgn | sed 's/^/  /'
  echo LTC 60+0.6
  ordo_many pgns/$nnue_name/*$nnue_name-ltc*.pgn | sed 's/^/  /'
else
  ordo_many $*
fi
