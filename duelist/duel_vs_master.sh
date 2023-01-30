#!/bin/bash
if [ "$#" -ne 3 ]; then
  echo "Usage: ./duel_with_master.sh <nn_to_duel> <tc> <pgn_filename>"
  exit 0
fi

nn_to_duel=$1
tc=$2
pgn_filename=$3

case $2 in
  25k)
    tc_options="option.Hash=8 tc=10000+10000 nodes=25000"
    num_games=1000
    ;;
  stc)
    tc_options="option.Hash=16 tc=10+0.1"
    num_games=250
    ;;
  ltc)
    tc_options="option.Hash=64 tc=60+0.6"
    num_games=50
    ;;
  *)
    echo "tc must be one of: 25k, stc, ltc"
    exit 1
esac

# randomly set the 1st and 2nd player in gauntlet matches
if [ $(( $RANDOM % 2 )) == 0 ]; then
  player1=master
  player1_engine="cmd=stockfish name=master"
  player2=$nn_to_duel
  player2_engine="cmd=stockfish name=$nn_to_duel option.EvalFile=$nn_to_duel"
else
  player1=$nn_to_duel
  player1_engine="cmd=stockfish name=$nn_to_duel option.EvalFile=$nn_to_duel"
  player2=master
  player2_engine="cmd=stockfish name=master"
fi

echo "Duel: $player1 vs $player2 @ $tc"
echo "PGN: $pgn_filename"

c-chess-cli \
  -gauntlet -rounds 1 -games $num_games -concurrency 16 \
  -each option.Threads=1 timeout=20 $tc_options \
  -openings \
    file=/gauntlet/books/UHO_XXL_+0.90_+1.19.epd \
    order=random srand=${RANDOM}${RANDOM} -repeat \
  -resign count=3 score=700 \
  -draw count=8 score=10 \
  -engine $player1_engine \
  -engine $player2_engine \
  -pgn $pgn_filename 0
