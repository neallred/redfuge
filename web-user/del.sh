#!/usr/bin/env bash

user=web
user_exists="$(cat /etc/passwd | grep -o '^web')"
deny_ssh="$(cat /etc/ssh/sshd_config | grep -o 'DenyUsers web')"
caller=$(whoami)

if [ -n "$user_exists" ]; then
  if [ -n "$deny_ssh" ]; then
    sudo sed -i /DenyUsers\ $user/d /etc/ssh/sshd_config
    sudo systemctl restart sshd
  fi
  sudo killall -9 -u $user

  day=$(date '+%Y-%m-%d')
  sudo tar -C /home/$caller -czf ~/$user-home-$day.tar.gz /home/$user
  sudo crontab -r -u $user
  sudo deluser --remove-home $user
fi
