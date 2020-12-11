ssh_conf="/etc/ssh/sshd_config"
su_conf="/etc/pam.d/su"
has_root_login=$(grep '^PermitRootLogin no' $ssh_conf)
has_su_nosu=$(grep '^auth.*required.*pam_wheel.so.*deny.*group=nosu' $su_conf)
has_nosu=$(grep '^nosu:' /etc/group)

if [ -z "$has_root_login" ]; then
  echo 'disabling root login'
  echo 'PermitRootLogin no' | sudo tee --append $ssh_conf > /dev/null
fi

if [ -z "$has_nosu" ]; then
  echo 'adding nosu group'
  sudo groupadd nosu
fi

if [ -z "$has_su_nosu" ]; then
  echo 'disabling su for nosu group'
  echo 'auth       required   pam_wheel.so deny group=nosu' | sudo tee --append $su_conf > /dev/null
fi
