#!/usr/bin/env bash

# Check the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

OPTIONS=rw,rprivate,nosuid,nodev
NAME=centreon-central

docker run --rm -t -d \
  --tmpfs /tmp:"${OPTIONS}" \
  --tmpfs /run:"${OPTIONS}" \
  --tmpfs /run/lock:"${OPTIONS}" \
  --tmpfs /var/log/journal:"${OPTIONS}" \
  --cgroupns=private \
  --name "${NAME}" --hostname "${NAME}" \
  -p "80:80" \
  centreon:central

nsenter -t $(docker inspect -f '{{.State.Pid}}' centreon-central) -m -p -C /bin/sh -c 'umount /sys/fs/cgroup/ && mount -t cgroup2 cgroup2 /sys/fs/cgroup/ -o rw ; pkill sleep'
