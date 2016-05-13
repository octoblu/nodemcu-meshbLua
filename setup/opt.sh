#!/usr/bin/env bash
mkdir -p ~/Projects/Cactuscon/nodemcu-meshblua/src/opt
rm ~/Projects/Cactuscon/nodemcu-meshblua/src/opt/*
(
  cd ../src
  for f in *.lua; do
    echo $f
    (
      cd ~/Projects/Cactuscon/luasrcdiet/
      lua5.1 LuaSrcDiet.lua \
        --quiet \
        --maximum \
        --noopt-numbers \
        --noopt-eols \
        -o ~/Projects/Cactuscon/nodemcu-meshblua/src/opt/$f \
        ~/Projects/Cactuscon/nodemcu-meshblua/src/$f
    )
  done
)
