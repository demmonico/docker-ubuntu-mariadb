# Docker MariaDB-based image

## Description

Docker MariaDB-based image. Use as image for database container.


### Installs

- Ubuntu 14.04
- MariaDB 10.1
- curl, zip, unzip
- supervisor
- composer
- mc, rsync, htop


### Build arguments

- MARIADB_VER (default 10.1)


### Environment variables

- DB_NAME


## Build && push

### Build

Build image with MariaDB version specified.
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


## Change log

See the [CHANGELOG](CHANGELOG.md) file for change logs.
