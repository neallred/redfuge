#!/usr/bin/env bash

make_cmd_blacklist() {
  local cmd_whitelist="[ ] bash cd curl cut echo env exit false grep groups kill logout ls ps python3 true whoami xargs"

  # Can't whitelist a file if its folder is blacklisted.
  # So construct the blacklist more manually.
  local cmd_dirs_blacklist="/usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/games /snap/bin"
  local cmd_blacklist=""
  for d in $cmd_dirs_blacklist
  do
    cmd_blacklist="$cmd_blacklist $(ls $d)"
  done

  cmd_blacklist=$(echo "$cmd_blacklist" | sort -u)
  for c in $cmd_whitelist
  do
    if [ "$c" = "[" ]; then
      cmd_blacklist=$(echo $cmd_blacklist | sed "s/\[//")
    else
      cmd_blacklist=$(echo $cmd_blacklist | sed "s/$c//g")
    fi
  done

  cmd_blacklist="$(which $cmd_blacklist) $(which apt apt-get cp dd ed gunzip gzip ip journalctl less ln mkdir more mount mv nano nmap ping red scp sed setfacl ssh su sudo systemctl tar touch vi vim wget yes)"

  echo $cmd_blacklist
}

user_exists="$(cat /etc/passwd | grep -o '^web')"
deny_ssh="$(cat /etc/ssh/sshd_config | grep -o '^DenyUsers web')"
user=web

if [ -z "$user_exists" ]; then
  echo 'adding "$user" user'
  sudo adduser --shell /bin/bash --gecos "" $user
  sudo usermod -a -G nosu $user

  if [ -z "$deny_ssh" ]; then
    echo "disallowing $user user ssh login"
    echo "DenyUsers $user" | sudo tee --append /etc/ssh/sshd_config > /dev/null
    sudo systemctl restart sshd
  fi

  echo "blacklisting unneeded commands"
  for c in $(make_cmd_blacklist)
  do
    sudo setfacl -m u:$user:--- $c
  done

  echo "run copy-apps.sh to bootstrap user. Then log in as user and run up.sh"
fi
