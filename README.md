# Docker Centreon 🐳
[Centreon](https://www.centreon.com/) is a network, system and application monitoring tool.  
This repository will guide you through the installation of a Centreon Central server using Docker.  

## Table of contents 📋
See below the top level parts of this README:

+ [Requirements](#requirements-)
+ [Getting Started](#getting-started-%EF%B8%8F)
+ [Contributing](#contributing-)
+ [Support](#support-%EF%B8%8F)
+ [Licence](#licence-)


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
The stack comes with a nginx container which needs a certificate and its private key as well as Diffie-Hellman parameters.

If needed, you can quickly generate a self-signed certificate as shown below:
```bash
openssl req -x509 -newkey rsa:4096 -nodes -keyout nginx/ssl/privkey.pem -out nginx/ssl/fullchain.pem -days 365 -subj '/CN=localhost' -addext "subjectAltName=DNS:pdns.local.intra,DNS:pihole.local.intra,IP:127.0.0.1,IP:0.0.0.0"
```

Regarding the D-H parameters you can generate them as follows:
```bash
openssl dhparam -out nginx/ssl/dhparams.pem 4096
```
*Depending on your machine, you might have time to grab a coffee* ☕

Finally, apply correct ownership (*www-data has id 33*)
```bash
chown -R $USER:33 nginx/ssl/
chmod 640 nginx/ssl/*.pem
```
*Compose does not support assigning ownership when mounting secrets.*

### Configuration
You can customize the timezone passed as a build argument in the Compose file *(l.7)*.  
Default value: `Europe/Amsterdam`.

### Build
To build the images, this simple Compose command will suffice: 
```bash
docker-compose build
```

### First setup
If you run Centreon for the first time, some additional setup is required, the following script will guide you through the installation of MariaDB.  
```bash
./setup.sh
```
Please set a secure root password and answer 'yes' to all questions, see the according [Centreon's documentation page](https://docs.centreon.com/docs/installation/installation-of-a-central-server/using-packages/#secure-the-database).  

You will then be required to complete the web installation, this is pretty straightforward, the [documentation page](https://docs.centreon.com/docs/installation/web-and-post-installation/#web-installation) may also help you.  
When asked to restart some services (step 9) you can simply run the following command: 
```bash
docker exec centreon-central systemctl restart cbd centengine gorgoned
```

### Start
To start the services, a convenient script is available, it helps setting up the cgroups filesystem in the container.  
```bash
./start.sh
```

## Docker, cgroups v2 and SystemD ⚠️
One inconvenience of Centreon is that [it's not really container-friendly](https://github.com/centreon/centreon/issues/6057) as it requires SystemD as an init system.  
Although it's possible to install the latter in a container, it's at the moment quite a journey to get it working due to an incompatibility with cgroups v2.  

Without getting too technical, SystemD expects the cgroup filesystem to be writable but this not the case using the default docker driver for cgroups v2. Thus, on recent systems with an up-to-date kernel and Docker version, this problem arises.  
The challenge was to run the container without having to mount the host's cgroup filesystem or to give additional privileges to the container.  
After some research the solution is to remount the filesystem from within the container with the correct permissions. This is why a convenient script replaces a simple Compose command.  

*You can find some references on this matter in the last section.*

## Contributing 🤝
Pull requests are welcome. For major changes, please open a discussion first to talk about what you would like to change.

## Support ⭐️
Give a ⭐️ if you like this project and want to support it!

## Licence 📃
[GNU General Public Licence v3.0](https://github.com/noxPHX/docker-centreon/blob/main/LICENSE)

## References 📚
https://serverfault.com/questions/1053187/systemd-fails-to-run-in-a-docker-container-when-using-cgroupv2-cgroupns-priva  
https://systemd.io/CONTAINER_INTERFACE/  
https://github.com/mviereck/x11docker/issues/349
