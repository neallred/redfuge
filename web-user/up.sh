#!/usr/bin/env bash
user="$(whoami)"
apps_dir="/home/$user/apps"

launch_static() {
  local app=$1
  local port=$2
  local processname="$(echo $app | cut -c -15)"
  local running="$(ps -u $user | grep $processname)"
  if [ -z "$running" ]; then
    echo launching $app
    $apps_dir/$app $port &
  fi
}

# [applications.Black]
launch_static black-allthings-red 1024

# [applications.Cad]
cad_running="$(curl -s localhost:1025 2> /dev/null)"
if [ -z "$cad_running" ]; then
  cd $apps_dir/cad.allthings.red
  echo launching cad.allthings.red
  python3 -m http.server 1025 > /dev/null 2>&1 &
fi

# [applications.Christmas]
launch_static allredchristmastraditions.allthings.red 1026

# [applications.Emby]
# don't need to do anything

# [applications.Library]
launch_static library.allthings.red 1027

# [applications.Pic]
PIC_DIR=$apps_dir/pic.allthings.red/pics launch_static pic.allthings.red/pic.allthings.red 1028

# Sozu reverse proxy
sozu_running="$(ps ax | grep '[s]ozu')"
if [ -z "$sozu_running" ]; then
  echo "Run the following in tmux to start the reverse proxy"
  echo "sudo $apps_dir/sozu start -c $apps_dir/config.toml &"
fi
