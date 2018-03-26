#!/usr/bin/env bash
#
# This file has executed each time when container's starts
#
# tech-stack: ubuntu / mariadb
#
# @author demmonico
# @image ubuntu-mariadb
# @version v3.2


# start MySQL daemon
function startMysqld()
{
    # Start the MySQL daemon in the background.
    /usr/sbin/mysqld &
    mysql_pid=$!

    # FIX error with absent /var/run/mysqld/mysqld.sock
    if [ ! -S /var/run/mysqld/mysqld.sock ]; then
        [ ! -d /var/run/mysqld ] && mkdir /var/run/mysqld
        mkfifo /var/run/mysqld/mysqld.sock && chown -R mysql /var/run/mysqld
    fi

    # wait for MySQL starts
    until mysqladmin ping >/dev/null 2>&1; do
        echo -n "."; sleep 0.2
    done
}

function stopMysqld()
{
    # Tell the MySQL daemon to shutdown.
    mysqladmin shutdown

    # Wait for the MySQL daemon to exit.
    wait $mysql_pid
}



# define DMC_DB_NAME
if [ -z "${DMC_DB_NAME}" ]; then
  DMC_DB_NAME=${DM_PROJECT}
fi

# define ROOT_PWD
ROOT_PWD="${DMC_ROOT_PASSWD:-rootPasswd}"



##### run once
if [ -f "${DMC_RUN_ONCE_FLAG}" ]; then
  # run script once
  source run_once.sh
  # rm flag
  /bin/rm -f ${DMC_RUN_ONCE_FLAG}
fi



##### run

# try to set root password if it's empty (apply when database was replaced)
# Start the MySQL daemon in the background.
startMysqld
# change root password
mysqladmin -u root password "${ROOT_PWD}"
# Shutdown the MySQL daemon
stopMysqld



### run custom script if exists
CUSTOM_SCRIPT="${DMC_INSTALL_DIR}/custom.sh"
if [ -f ${CUSTOM_SCRIPT} ]; then
    chmod +x ${CUSTOM_SCRIPT} && source ${CUSTOM_SCRIPT}
fi
if [ ! -z "${DMC_CUSTOM_RUN_COMMAND}" ]; then
    eval ${DMC_CUSTOM_RUN_COMMAND}
fi



### FIX permissions
chown -R mysql:mysql ${DMC_DB_FILES_DIR}



### FIX cron start
cron



### run supervisord
exec /usr/bin/supervisord -n



### entrypoint
#exec /usr/bin/mysqld_safe

## recommended, but not tested
# bind stop Mysql on TERM signal
#trap "mysqladmin shutdown" TERM
# start Mysql in background
#mysqld_safe --bind-address=0.0.0.0 &
# wait for ending all child processes
#wait
