#!/bin/bash

function ordo_many() {
  ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- $*
}

if [[ $1 == *.nnue ]]; then
  echo 25k nodes
  ordo_many pgns/*$1-25k*.pgn
  echo STC 10+0.1
  ordo_many pgns/*$1-stc*.pgn
  echo LTC 60+0.6
  ordo_many pgns/*$1-ltc*.pgn
else
  ordo_many $*
fi
