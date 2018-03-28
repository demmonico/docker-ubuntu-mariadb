# 3.3.0 (2018-03-28)

- small fixes
- add default `root` user password
- add special `dm` user to make `docker exec` under no-root user by default
- add env var `DMC_CUSTOM_RUN_COMMAND` and `DMC_CUSTOM_RUNONCE_COMMAND`
- add env var `DMC_EXEC_NAME`
- add lib scripts for export/import database dump
- add lib scripts for updating /etc/hosts
- add env var `DMC_CUSTOM_ADD_HOSTS` for updating /etc/hosts


# 3.2 (2018-03-22)

- link to a new image version [docker-ubuntu-apache-php](https://github.com/demmonico/docker-ubuntu-apache-php) (v3.2)
- DM* prefixed and renamed
- FIX `mysqladmin` fail linked with `sock` file
- FIX `mysql` user permissions via set UID from `DM_USER`
- add env var `DMC_DB_FILES_DIR`


# 2.0 (2017-11-30)

- refactor structure of image source folder, add version of image format, add new format version
- add install dir import
- push to [DockerHub](https://hub.docker.com/r/demmonico/ubuntu-mariadb/)


# 1.1

- First release
