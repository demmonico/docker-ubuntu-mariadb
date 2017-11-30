# Dockerfile for build app container
#
# tech-stack: ubuntu / mariadb
#
# @author demmonico
# @image ubuntu-mariadb
# @version v2.0


FROM ubuntu:14.04
MAINTAINER demmonico@gmail.com


### ENV CONFIG
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# for mc
ENV TERM xterm

# dafault name of internal DB
ENV DB_NAME=''

# additional files required to run container (from version v2.0)
ENV INSTALL_DIR="/docker-install"


### INSTALL SOFTWARE
ARG MARIADB_VER='10.1'
RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get update \

    # curl, zip, unzip
    && apt-get install -y --force-yes  --no-install-recommends curl zip unzip \

    # DB server
    && apt-get install -y software-properties-common \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db \
    && add-apt-repository "deb [arch=amd64,i386,ppc64el] http://www.ftp.saix.net/DB/mariadb/repo/${MARIADB_VER}/ubuntu trusty main" \
    && apt-get update \
    && apt-get install -y mariadb-server \
    # configure DB
    && chown -R mysql:mysql /var/lib/mysql \

    # demonisation for docker
    && apt-get install -y supervisor \

    # mc, rsync and other utils
    && apt-get -qq update && apt-get -qq -y install mc rsync htop \

    # clear apt etc
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql \
    && mkdir -p /var/log/supervisor


# config DB
COPY mariadb.cnf /etc/mysql/my.cnf
RUN chmod 600 /etc/mysql/my.cnf
COPY mariadb-debian.cnf /etc/mysql/debian.cnf


EXPOSE 3306


### UPDATE & RUN PROJECT

# copy supervisord config file
COPY supervisord.conf /etc/supervisor/supervisord.conf

# copy and init run_once script
COPY run_once.sh /run_once.sh
ENV RUN_ONCE_FLAG="/run_once_flag"
RUN tee "${RUN_ONCE_FLAG}" && chmod +x /run_once.sh

# run custom run command if defined
ARG CUSTOM_BUILD_COMMAND
RUN ${CUSTOM_BUILD_COMMAND:-":"}

# copy and init run script
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]