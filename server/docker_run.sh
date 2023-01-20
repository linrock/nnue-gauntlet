#!/bin/bash

docker run \
  -e PORT=6055 -p 6055:6055 \
  --mount type=bind,source="$(pwd)"/nn,target=/gauntlet/nn \
  -d nnue-gauntlet
