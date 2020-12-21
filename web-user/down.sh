#!/usr/bin/env bash
user="$(whoami)"

named_apps="black-allthings-red \
  cad-allthings-red \
  allredchristmastraditions.allthings.red \
  library.allthings.red \
  lr.allthings.red \
  pic.allthings.red/pic.allthings.red"

for app in $named_apps
do
  processname="$(echo $app | cut -c -15)"
  running="$(ps -u $user | grep $processname | xargs)"
  pid=$(echo "$running" | grep -o '^[0-9]\+')
  if [ -n "$running" ]; then
    echo killing "$pid $app"
    kill $pid
  fi
done
