# Docker MariaDB-based image

## Description

Docker MariaDB-based image. Use as image for database container. 
Was developed for using with [Docker Manager](https://github.com/demmonico/docker-manager/). 
But could be used separately.
You could pull image from here and build locally either pull from [Docker Hub](https://hub.docker.com/r/demmonico/ubuntu-mariadb/) directly.


### Installs

- Ubuntu 14.04
- MariaDB 10.1
- curl, zip, unzip
- supervisor
- mc, rsync, htop


### Build arguments

- MARIADB_VER (default 10.1)
- CUSTOM_BUILD_COMMAND (will run if defined in the end of build)


### Environment variables

- DB_NAME
- INSTALL_DIR


## Build && push

### Build

Build image with default MariaDB version
```sh
docker build -t demmonico/ubuntu-mariadb --no-cache .
```
or build image with MariaDB version specified.
```sh
docker build -t demmonico/ubuntu-mariadb --build-arg MARIADB_VER=10.1 --no-cache .
```

### Make tag

```sh
docker tag IMAGE_ID demmonico/ubuntu-mariadb:10.1
```

### Push image to Docker Hub

```sh
docker push demmonico/ubuntu-mariadb
```
or with tag
```sh
docker push demmonico/ubuntu-mariadb:10.1
```


## Usage

### Dockerfile

```sh
FROM demmonico/ubuntu-mariadb:10.1
  
# optional copy files to install container
COPY install "${INSTALL_DIR}/"
  
# optional config DB
RUN yes | cp -rf "${INSTALL_DIR}/mariadb.cnf" /etc/mysql/my.cnf \
    && chmod 600 /etc/mysql/my.cnf
  
CMD ["/run.sh"]
```

### Docker Compose

```sh
...
image: demmonico/ubuntu-mariadb
  
# optional
environment:
  - DB_NAME=test_db
  
volumes:
  # db tables
  - ./db/data:/var/lib/mysql
  # optional custom configs
  - ./mariadb.cnf:/etc/mysql/my.cnf
  
# provides values for ENV variables VIRTUAL_HOST, PROJECT, HOST_USER_NAME, HOST_USER_ID
env_file:
  - host.env
...
```


## Change log

See the [CHANGELOG](CHANGELOG.md) file for change logs.
