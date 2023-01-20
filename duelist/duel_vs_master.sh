#!/bin/bash
if [ "$#" -ne 2 ]; then
  echo "Usage: ./duel_with_master.sh <nn_to_duel> <tc>"
  exit 0
fi

nn_to_duel=$1
tc=$2

case $2 in
  25k)
    tc_options="option.Hash=8 tc=10000+10000 nodes=25000"
    ;;
  stc)
    tc_options="option.Hash=16 tc=10+0.1"
    ;;
  ltc)
    tc_options="option.Hash=64 tc=60+0.6"
    ;;
  *)
    echo "tc must be one of: 25k, stc, ltc"
    exit 1
esac

c-chess-cli \
  -gauntlet -rounds 1 -games 1000 -concurrency 16 \
  -each option.Threads=1 timeout=20 $tc_options \
  -openings \
    file=/gauntlet/books/UHO_XXL_+0.90_+1.19.epd \
    order=random srand=${RANDOM}${RANDOM} \
  -repeat -resign count=3 score=700 -draw count=8 score=10 \
  -engine \
    cmd=stockfish name=master \
  -engine \
    cmd=stockfish name=$nn_to_duel option.EvalFile=$nn_to_duel \
  -pgn master-vs-${nn_to_duel}-${tc}.pgn 0
