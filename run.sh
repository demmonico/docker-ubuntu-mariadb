#!/bin/bash
#
# DEPRECATED
#
# This file has executed each time when container's starts
#
# tech-stack: ubuntu / mariadb
#
# @author demmonico
# @image ubuntu-mariadb
# @version v1.1



# define DB_NAME
if [ -z "${DB_NAME}" ]; then
  DB_NAME=${PROJECT}
fi


##### run once
if [ -f "${RUN_ONCE_FLAG}" ]; then
  # run script once
  source run_once.sh
  # rm flag
  /bin/rm -f ${RUN_ONCE_FLAG}
fi



##### run

### run custom script if exists
if [ ! -z ${CUSTOM_RUN_SCRIPT} ] && [ -f ${CUSTOM_RUN_SCRIPT} ] && [ -x ${CUSTOM_RUN_SCRIPT} ]
then
    /bin/bash ${CUSTOM_RUN_SCRIPT}
fi

### run supervisord
exec /usr/bin/supervisord -n
