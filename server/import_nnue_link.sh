#!/bin/bash

nnue_link=$1
exp_path=$(echo $nnue_link | grep -oE "experiment_[^/]*")
nnue_name=$(echo $nnue_link | grep -oE "nn-epoch[0-9]+\.nnue")

if [ ! -z $exp_path -a ! -z $nnue_name ]; then
  echo $exp_path
  mkdir nn/$exp_path 2>/dev/null
  if [ -f nn/$exp_path/$nnue_name ]; then
    echo $nnue_name already exists in nn/$exp_path
  else
    echo nn/$exp_path/$nnue_name
    curl -sL -k "$nnue_link" > nn/$exp_path/$nnue_name
    echo Downloaded to nn/$exp_path/$nnue_name
  fi
  ls -lth nn/$exp_path/$nnue_name
  sha256sum=$(sha256sum nn/$exp_path/$nnue_name)
  nnue_symlink_name=nn-${sha256sum:0:12}.nnue
  echo $nnue_symlink_name
  cd nn
  ln -s $exp_path/$nnue_name $nnue_symlink_name
  ls -lth $nnue_symlink_name
fi
