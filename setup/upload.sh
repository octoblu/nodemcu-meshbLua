#!/usr/bin/env bash

if [ -n "$1" ]
then
  TTYUSB=$1
else
  TTYUSB='/dev/ttyUSB0'
fi

LUATOOL='../luatool/luatool/luatool.py'
LUATOOLCMD="python ${LUATOOL} --port ${TTYUSB} --delay 0.08"

set -e

$LUATOOLCMD --src format.lua -d
(
  cd ../src
  for file in $(ls *.lua); do
    echo
    echo --- $file
    sleep 0.5
    # LUATOOLARGS='-c'
    if [ "$file" = "init.lua" ]
    then
      unset LUATOOLARGS
    fi
  	$LUATOOLCMD --src $file -v $LUATOOLARGS >/dev/null
  done
)
$LUATOOLCMD --src setup.lua -d
echo "upload successful"
