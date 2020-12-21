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

# [applications.Emby] not managed through web user

launch_static black-allthings-red 1024
launch_static cad-allthings-red 1025
launch_static allredchristmastraditions.allthings.red 1026
launch_static library.allthings.red 1027
launch_static lr-allthings-red 1028
PIC_DIR=$apps_dir/pic.allthings.red/pics launch_static pic.allthings.red/pic.allthings.red 1029

# Sozu reverse proxy
sozu_running="$(ps ax | grep '[s]ozu')"
if [ -z "$sozu_running" ]; then
  echo "Run the following in tmux to start the reverse proxy"
  echo "sudo $apps_dir/sozu start -c $apps_dir/config.toml &"
fi
