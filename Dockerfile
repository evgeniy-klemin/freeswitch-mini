# vim:set ft=dockerfile:
FROM debian:stretch

ARG CONT_IMG_VER=1.10-0.1.0
ENV CONT_IMG_VER $CONT_IMG_VER

# explicitly set user/group IDs
RUN groupadd -r freeswitch --gid=1000 && useradd -r -g freeswitch --uid=1000 freeswitch

RUN apt-get update && apt-get install -y --no-install-recommends gnupg dirmngr && rm -rf /var/lib/apt/lists/*
# grab gosu for easy step-down from root
RUN gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
    gpg --keyserver keyserver.ubuntu.com --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
    gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && apt-get purge -y --auto-remove ca-certificates wget

# make the "en_US.UTF-8" locale so freeswitch will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ENV FS_MAJOR 1.8

RUN sed -i "s/stretch main/stretch main contrib non-free/" /etc/apt/sources.list

RUN apt-get update && apt-get install -y curl \
    && curl https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add - \
    && echo "deb http://files.freeswitch.org/repo/deb/freeswitch-$FS_MAJOR/ stretch main" > /etc/apt/sources.list.d/freeswitch.list \
    && apt-get purge -y --auto-remove curl

RUN apt-get update && apt-get install -y --force-yes freeswitch-all \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Clean up
RUN apt-get autoremove

COPY docker/docker-entrypoint.sh /

## Ports
# Open the container up to the world.
### 8021 fs_cli, 5060 5061 5080 5081 sip and sips, 64535-65535 rtp
EXPOSE 8021/tcp
EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5061/tcp 5061/udp 5081/tcp 5081/udp
EXPOSE 7443/tcp
EXPOSE 5071/udp 5071/tcp
EXPOSE 16384-16394/udp

# Volumes
## Freeswitch Configuration
VOLUME ["/etc/freeswitch"]
## Tmp so we can get core dumps out
VOLUME ["/tmp"]

# Limits Configuration
COPY docker/freeswitch.limits.conf /etc/security/limits.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["freeswitch"]
