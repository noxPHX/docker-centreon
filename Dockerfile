FROM debian:11

#################################
# SystemD-enabled container setup
#################################

ENV container docker

RUN apt-get update && \
    apt-get -y install systemd

# Mask useless services in containers
RUN for service in \
    ntp \
    getty \
    console-getty \
    apt-daily \
    apt-daily.timer \
    apt-daily-upgrade \
    apt-daily-upgrade.timer \
    unattended-upgrades \
    systemd-udevd \
    systemd-logind \
    systemd-user-sessions \
    systemd-initctl.socket \
    systemd-update-utmp-runlevel \
    systemd-ask-password-wall.path \
    ;do systemctl mask $service; done

VOLUME [ "/tmp", "/run", "/run/lock", "/var/log/journal" ]

STOPSIGNAL SIGRTMIN+3

CMD sleep infinity; exec /sbin/init

#################################
# Centreon install
#################################

RUN apt-get -y install \
    cron \
    wget \
    gnupg2 \
    locales \
    lsb-release \
    openssh-client \
    ca-certificates \
    apt-transport-https \
    software-properties-common && \
    update-locale

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list && \
    wget -O- https://packages.sury.org/php/apt.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/php.gpg  > /dev/null 2>&1 && \
    echo "deb https://apt.centreon.com/repository/22.04/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/centreon.list && \
    wget -O- https://apt-key.centreon.com | gpg --dearmor | tee /etc/apt/trusted.gpg.d/centreon.gpg > /dev/null 2>&1 && \
    apt-get update && \
    apt-get -y install centreon && \
    rm -rf /var/lib/apt/lists/*

ARG TZ

RUN echo "date.timezone = ${TZ}" > /etc/php/8.0/mods-available/centreon.ini && \
    sed -i 's/^agentaddress.*$/agentaddress 127.0.0.1/' /etc/snmp/snmpd.conf && \
    systemctl enable php8.0-fpm apache2 centreon cbd centengine gorgoned centreontrapd snmpd snmptrapd
