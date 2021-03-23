#!/usr/bin/env bash

for X in assets/img/newgalleries/*/*.*; do
  echo "Converting $X";
  ./tools/images/resize.sh -o -i "$X";
  echo "Done";
done
