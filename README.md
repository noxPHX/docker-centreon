# centreon

```
docker build -t centreon:test .
docker run -d -p "80:80" --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup --cgroupns=host centreon:test
```
## Doc
https://docs.centreon.com/docs/installation/installation-of-a-remote-server/using-packages/
https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva
https://systemd.io/CONTAINER_INTERFACE/
