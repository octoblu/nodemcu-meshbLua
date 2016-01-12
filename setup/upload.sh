#!/usr/bin/env bash

if [ -n "$1" ]
then
  TTYUSB=$1
else
  TTYUSB='/dev/ttyUSB0'
fi

LUATOOL='../luatool/luatool/luatool.py'
LUATOOLCMD="python ${LUATOOL} --port ${TTYUSB} --delay 0.02"

set -e

$LUATOOLCMD --src format.lua -d
(
  cd ../src
  for file in $(ls *.lua); do
    sleep 0.1
    LUATOOLARGS='-c'
    if [ "$file" = "init.lua" ]
    then
      unset LUATOOLARGS
    fi
  	$LUATOOLCMD --src $file $LUATOOLARGS
  done
)
$LUATOOLCMD --src setup.lua -d
echo "uploaded everything successful"
