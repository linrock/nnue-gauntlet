#!/bin/bash

# tc=25k
# tc_options="option.Hash=8 tc=10000+10000 nodes=25000"

# tc=stc
# tc_options="option.Hash=16 tc=10+0.1"

tc=ltc
tc_options="option.Hash=64 tc=60+0.6"

nn_to_test=nn-epoch759.nnue

/root/c-chess-cli/c-chess-cli \
  -gauntlet -rounds 1 -games 1000 -concurrency 16 \
  -each option.Threads=1 timeout=20 $tc_options \
  -openings \
    file=/root/books/UHO_XXL_+0.90_+1.19.epd \
    order=random srand=${RANDOM}${RANDOM} \
  -repeat -resign count=3 score=700 -draw count=8 score=10 \
  -engine \
    cmd=/root/Stockfish/src/stockfish \
    name=master \
  -engine \
    cmd=/root/Stockfish/src/stockfish \
    name=$nn_to_test \
    option.EvalFile=/root/$nn_to_test \
  -pgn master-vs-${nn_to_test}-${tc}.pgn 0
