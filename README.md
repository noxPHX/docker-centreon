# Docker Centreon 🐳
[Centreon](https://www.centreon.com/) is a network, system and application monitoring tool.  
This repository will guide you through the installation of a Centreon Central server using Docker.  

## Requirements 🧰
Only [Docker](https://docs.docker.com/get-docker/) and [Compose](https://docs.docker.com/compose/) are required, the following versions are the minimal requirements:

| Tool          | Version |
|:-------------:|:-------:|
| Docker        |  20.10  |
| Compose       |  1.29   |

*The container requires a kernel that supports cgroups v2, to ensure they are supported you can run and check the result of the following command: `grep cgroup2 /proc/filesystems`.*  
*More information about this in the dedicated section: []()*

## Getting Started 🛠️
Fetch the code from the repository and enter the folder.

```bash
git clone https://github.com/noxPHX/docker-centreon.git && cd docker-centreon
```

### SSL

### Configuration
You can customize the timezone passed as a build argument in the Compose file *(l.7)*.  
Default value: `Europe/Amsterdam`.

### Build
```bash
docker-compose build
```

### First setup
```bash
./setup.sh
```
MariaDB  
https://docs.centreon.com/docs/installation/web-and-post-installation/#web-installation

```bash
docker exec centreon-central systemctl restart cbd centengine gorgoned
```

### Start
```bash
./start.sh
```

## Notes
No sshd

## Contributing 🤝
Pull requests are welcome. For major changes, please open a discussion first to talk about what you would like to change.

## Support ⭐️
Give a ⭐️ if you like this project and want to support it!

## Licence 📃
[GNU General Public Licence v3.0](https://github.com/noxPHX/docker-centreon/blob/main/LICENSE)

## Doc
https://docs.centreon.com/docs/installation/installation-of-a-remote-server/using-packages/  
https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva  
https://systemd.io/CONTAINER_INTERFACE/  
https://github.com/mviereck/x11docker/issues/349
