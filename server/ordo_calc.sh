#!/bin/bash

# pgn_file=$1
# ordo -q -J -p $pgn_file -a 0 --anchor=master --draw-auto --white-auto -s 100

ordo -q -J -a 0 --anchor=master --draw-auto --white-auto -s 100 -- $*
