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
- mc, rsync, htop, nano


### Build arguments

- DMB_DB_MARIADB_VER (default 10.1)
- DMB_CUSTOM_BUILD_COMMAND (will run if defined in the end of build)


### Environment variables

- DMC_DB_NAME
- DMC_DB_FILES_DIR (default `/var/lib/mysql`)
- DMC_INSTALL_DIR
- DMC_ROOT_PASSWD (on `run_once`)
- DMC_DM_USER  (on `run_once`)
- DMC_DM_PASSWD  (on `run_once`)
- DMC_CUSTOM_RUN_COMMAND
- DMC_CUSTOM_RUNONCE_COMMAND
- DMC_EXEC_NAME (pass container's name while `exec` cmd)
- DMC_CUSTOM_ADD_HOSTS (updating /etc/hosts; format `container:domain` or `IP:domain`; allow multiple separated by `;`)


## Build && push

### Build

Build image with default MariaDB version
```sh
docker build -t demmonico/ubuntu-mariadb --no-cache .
```
or build image with MariaDB version specified.
```sh
docker build -t demmonico/ubuntu-mariadb --build-arg DMB_DB_MARIADB_VER=10.1 --no-cache .
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
COPY install "${DMC_INSTALL_DIR}/"
  
# optional config DB
RUN yes | cp -rf "${DMC_INSTALL_DIR}/mariadb.cnf" /etc/mysql/my.cnf \
    && chmod 600 /etc/mysql/my.cnf
  
CMD ["/run.sh"]
```

### Docker Compose

```sh
...
db:
  image: demmonico/ubuntu-mariadb
  # or
  build: local_path_to_dockerfile
      
  environment:
    # optional
    - DMC_DB_NAME=test_db
    
  volumes:
    # optional custom configs
    - ./mariadb.cnf:/etc/mysql/my.cnf
...
```


## Change log

See the [CHANGELOG](CHANGELOG.md) file for change logs.
