#!/bin/bash

cd nn
for nnue in $(ls ${1}*); do
  nnue_sha256=$(sha256sum $nnue)
  nnue_symlink=nn-${nnue_sha256:0:12}.nnue
  if [ ! -f $nnue_symlink ]; then
    ln -s $nnue $nnue_symlink
  fi
  ls -lth $nnue_symlink
done
