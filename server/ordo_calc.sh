#!/bin/bash

# pgn_file=$1
# ordo -q -J -p $pgn_file -a 0 --anchor=master --draw-auto --white-auto -s 100

if [[ $1 == *.nnue ]]; then
  ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- pgns/*$1-25k*.pgn
  ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- pgns/*$1-stc*.pgn
  ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- pgns/*$1-ltc*.pgn
else
  ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- $*
fi
