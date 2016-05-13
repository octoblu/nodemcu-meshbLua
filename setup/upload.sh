#!/usr/bin/env bash

if [ -n "$1" ]
then
  TTYUSB=$1
  shift
else
  TTYUSB='/dev/ttyUSB0'
fi

if [ -n "$1" ]
then
  TEAM=$1
  shift
else
  TEAM="black"
fi

if [[ -n "$@" ]]
then
  FILE=$@
else
  FILE=*.lua
fi

LUATOOL='/Users/erik/Projects/Octoblu/nodemcu-meshbLua/luatool/luatool/luatool.py'
LUATOOLCMD="python ${LUATOOL} --baud 115200 --port ${TTYUSB} --delay 0.01"

set -e

$LUATOOLCMD --src pre-upload.lua -d
(
  cd ../src
  for file in $(ls $FILE); do
    echo
    echo --- $file
    sleep 0.1
    LUATOOLARGS='-c'
    if [[ "$file" =~ (^|/)init.lua$ ]]
    then
      unset LUATOOLARGS
    fi
  	$LUATOOLCMD --src $file -v $LUATOOLARGS >/dev/null
  done
)
echo $TEAM > ../src/.team.data
$LUATOOLCMD --src ../src/.team.data -v
$LUATOOLCMD --src ../src/.salt -v
$LUATOOLCMD --src post-upload.lua -d
echo "upload successful"
