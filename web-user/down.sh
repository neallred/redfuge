#!/usr/bin/env bash
user="$(whoami)"

named_apps="black-allthings-red \
  allredchristmastraditions.allthings.red \
  library.allthings.red \
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

# anonymous apps
cad_running="$(curl -s localhost:1025 2> /dev/null)"
if [ -n "$cad_running" ]; then
  running="$(ps x | grep "python3.*1025" | xargs)"
  pid=$(echo "$running" | grep -o '^[0-9]\+')
  echo "killing $pid cad.allthings.red"
  kill $pid
fi