day=$(date '+%Y-%m-%d')
pushd ~/
mkdir backup-config
cp ~/certs/*~/serverctl/config.toml backup-config
tar czf backup-config-$day.tar.gz backup-config
rm -rf backup-config
popd
