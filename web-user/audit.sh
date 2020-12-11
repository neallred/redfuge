user=web
disk_usage=$(du -m --total --summarize /home/$user | tail -1 | grep -o '[0-9]\+')
disk_limit=100 # in MB
if [ $disk_usage -gt $disk_limit ]; then
  echo "$disk_usage MB used (threshold is 100MB)"
fi

processes=$(ps -u $user --no-headers)
process_count=$(echo "$processes" | wc -l)
process_limit=7
if [ $process_count -gt $process_limit ]; then
  echo "running $process_count processes (threshold is $process_limit):"
  echo "$processes"
fi
