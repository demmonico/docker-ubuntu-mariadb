# Dockerfile for build app container
#
# tech-stack: ubuntu / mariadb
#
# @author demmonico
# @image ubuntu-mariadb
# @version v3.2


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
ENV DMC_DB_NAME=''

# additional files required to run container
ENV DMC_INSTALL_DIR="/dm-install"


### INSTALL SOFTWARE
ARG DMB_DB_MARIADB_VER='10.1'
RUN apt-get -yqq update \
    && apt-get -yqq install software-properties-common \
    && apt-get -yqq update \

    # curl, zip, unzip
    && apt-get install -yqq --force-yes --no-install-recommends curl zip unzip \

    # DB server
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db \
    && add-apt-repository "deb [arch=amd64,i386,ppc64el] http://www.ftp.saix.net/DB/mariadb/repo/${DMB_DB_MARIADB_VER}/ubuntu trusty main" \
    && apt-get -yqq update \
    && apt-get -yqq install mariadb-server \
    # configure DB
    && chown -R mysql:mysql /var/lib/mysql \

    # demonisation for docker
    && apt-get -yqq install supervisor && mkdir -p /var/log/supervisor \

    # mc, rsync and other utils
    && apt-get -yqq install mc rsync htop nano



### UPDATE & RUN PROJECT

EXPOSE 3306

# copy supervisord config file
COPY supervisord.conf /etc/supervisor/supervisord.conf

# config DB
COPY mariadb.cnf /etc/mysql/my.cnf
RUN chmod 600 /etc/mysql/my.cnf
COPY mariadb-debian.cnf /etc/mysql/debian.cnf

# copy and init run_once script
COPY run_once.sh /run_once.sh
ENV DMC_RUN_ONCE_FLAG="/run_once_flag"
RUN tee "${DMC_RUN_ONCE_FLAG}" && chmod +x /run_once.sh

# run custom run command if defined
ARG DMB_CUSTOM_BUILD_COMMAND
RUN ${DMB_CUSTOM_BUILD_COMMAND:-":"}



# clean temporary and unused folders and caches
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql



# copy and init run script
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]
