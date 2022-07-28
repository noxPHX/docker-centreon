#!/usr/bin/env bash

# Check the script is run as by a user with docker's rights
if [ "$EUID" -ne 0 ]; then
  if ! id -nGz "$USER" | grep -qzxF docker; then
    echo "Please run with docker's rights (either run as root or add yourself to the docker group)"
    exit 1
  fi
fi

options=rw,rprivate,nosuid,nodev

docker run --rm \
  --tmpfs /tmp:$options \
  --tmpfs /run:$options \
  --tmpfs /run/lock:$options \
  --tmpfs /var/log/journal:$options \
  -v /sys/fs/cgroup:/sys/fs/cgroup --cgroupns=host --name centreon-central --hostname centreon-central -p "80:80" -t -d centreon:central
