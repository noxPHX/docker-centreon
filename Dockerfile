FROM debian:11

ENV container docker

RUN apt-get update && \
    apt-get -y install \
    lsb-release ca-certificates apt-transport-https software-properties-common wget gnupg2 systemd

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list && \
    wget -O- https://packages.sury.org/php/apt.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/php.gpg  > /dev/null 2>&1 && \
    echo "deb https://apt.centreon.com/repository/22.04/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/centreon.list && \
    wget -O- https://apt-key.centreon.com | gpg --dearmor | tee /etc/apt/trusted.gpg.d/centreon.gpg > /dev/null 2>&1 && \
    apt-get update

RUN apt-get -y install centreon

RUN echo "date.timezone = Europe/Amsterdam" > /etc/php/8.0/mods-available/centreon.ini

RUN systemctl enable php8.0-fpm apache2 centreon cbd centengine gorgoned centreontrapd snmpd snmptrapd

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

STOPSIGNAL SIGRTMIN+3

CMD [ "/sbin/init" ]
