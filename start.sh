#!/usr/bin/env bash

# Check the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

UUID=$(cat ./machine-id)
export UUID

docker-compose up -d

nsenter -t "$(docker inspect -f '{{.State.Pid}}' centreon-central)" -m -p -C /bin/sh -c 'umount /sys/fs/cgroup/ && mount -t cgroup2 cgroup2 /sys/fs/cgroup/ -o rw ; pkill sleep'
