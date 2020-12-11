user=web
user_home="/home/$user"
apps_dir="$user_home/apps"

if [ -f "$apps_dir" ]; then
  true
else
  echo copying apps dir
  sudo cp -r ~/apps $user_home
  sudo cp ./up.sh ./down.sh $apps_dir
  sudo chown -R $user:$user $apps_dir
fi
