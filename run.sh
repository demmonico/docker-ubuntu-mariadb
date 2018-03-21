#!/usr/bin/env bash
#
# This file has executed each time when container's starts
#
# tech-stack: ubuntu / mariadb
#
# @author demmonico
# @image ubuntu-mariadb
# @version v3.2



# define DMC_DB_NAME
if [ -z "${DMC_DB_NAME}" ]; then
  DMC_DB_NAME=${DM_PROJECT}
fi



##### run once
if [ -f "${DMC_RUN_ONCE_FLAG}" ]; then
  # run script once
  source run_once.sh
  # rm flag
  /bin/rm -f ${DMC_RUN_ONCE_FLAG}
fi



##### run

### run custom script if exists
CUSTOM_SCRIPT="${DMC_INSTALL_DIR}/custom.sh"
if [ -f ${CUSTOM_SCRIPT} ]; then
    chmod +x ${CUSTOM_SCRIPT} && source ${CUSTOM_SCRIPT}
fi

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
