#!/bin/bash

ls -1 nn/*.nnue | sed 's|nn/||g' | xargs -n1 ./ordo_calc.sh
