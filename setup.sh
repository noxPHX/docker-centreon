#!/usr/bin/env bash

set -e

# Check the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

./start.sh

echo
echo "Running mysql_secure_installation"
echo "Please set a secure root password and answer 'yes' to all questions"
echo "See:"
echo "https://docs.centreon.com/docs/installation/installation-of-a-central-server/using-packages/#secure-the-database"
echo

docker exec -it centreon-central mysql_secure_installation

echo
echo "Setup done!"
echo "Please proceed now with the web installation"
echo "See:"
echo "https://docs.centreon.com/docs/installation/web-and-post-installation/#web-installation"
echo
