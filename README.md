# centreon

```
docker build -t centreon:test .
docker run -d -p "80:80" --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup --cgroupns=host centreon:test
```
