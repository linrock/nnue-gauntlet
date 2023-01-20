#!/bin/bash

function ordo_many() {
  ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- $*
}

if [[ $1 == *.nnue ]]; then
  ordo_many pgns/*$1-25k*.pgn
  ordo_many pgns/*$1-stc*.pgn
  ordo_many pgns/*$1-ltc*.pgn
else
  ordo_many $*
fi
