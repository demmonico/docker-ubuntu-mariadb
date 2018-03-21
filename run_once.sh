#!/usr/bin/env bash
#
# This file has executed after container's builds
#
# tech-stack: ubuntu / mariadb
#
# @author demmonico
# @image ubuntu-mariadb
# @version v3.2



### users

# set root password
echo "root:${DMC_ROOT_PASSWD:-rootPasswd}" | chpasswd

# add dm user, set password, add to www-data group
DMC_DM_USER="${DMC_DM_USER:-dm}"
useradd -m ${DMC_DM_USER} && \
    usermod -a -G root ${DMC_DM_USER} && \
    adduser dm sudo && \
    echo "${DMC_DM_USER}:${DMC_DM_PASSWD:-${DMC_DM_USER}Passwd}" | chpasswd



# colored term
PS1="PS1='\[\033[01;35m\]\t\[\033[00m\] \${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;35m\]\${VIRTUAL_HOST}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '"
# prepare to sed
PS1=$( echo ${PS1} | sed 's/\\/\\\\/g' )
# replace colors
declare -a RC_FILES=("/root/.bashrc" "/home/${DMC_DM_USER}/.bashrc")
for RC_FILE in "${RC_FILES[@]}"
do
    START=$( cat ${RC_FILE} | sed "/^# set a fancy prompt/,\$d" )
    END=$( cat ${RC_FILE} | sed "/^# enable color support/,\$!d" )
    echo -e "${START}\n\n# set a fancy prompt\n${PS1}\n\n${END}" > ${RC_FILE}
done



### init DB
if [ ! -d /var/lib/mysql/mysql ]; then

    # set permissions
    chown mysql:mysql /var/lib/mysql

    # init system tables
    mysql_install_db --user=mysql --ldata=/var/lib/mysql/ --basedir=/usr

    # Start the MySQL daemon in the background.
    /usr/sbin/mysqld &
    mysql_pid=$!

    until mysqladmin ping >/dev/null 2>&1; do
      echo -n "."; sleep 0.2
    done

    # Permit root login without password from outside container.
    mysql -e "CREATE USER 'root'@'%' IDENTIFIED BY '';"
    mysql -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;"

    # create the default database
    mysql -e "CREATE DATABASE ${DMC_DB_NAME};"

    # import database from SQL if exists
    FILE_IMPORT="/var/lib/mysql/${DMC_DB_NAME}.sql"
    if [ -f ${FILE_IMPORT} ]
    then
        mysql ${DMC_DB_NAME} < ${FILE_IMPORT}
    fi

    # Tell the MySQL daemon to shutdown.
    mysqladmin shutdown

    # Wait for the MySQL daemon to exit.
    wait $mysql_pid

fi



### run custom script if exists
CUSTOM_ONCE_SCRIPT="${DMC_INSTALL_DIR}/custom_once.sh"
if [ -f ${CUSTOM_ONCE_SCRIPT} ]; then
    chmod +x ${CUSTOM_ONCE_SCRIPT} && source ${CUSTOM_ONCE_SCRIPT}
fi
if [ ! -z "${DMC_CUSTOM_RUNONCE_COMMAND}" ]; then
    eval ${DMC_CUSTOM_RUNONCE_COMMAND}
fi
