#!/usr/bin/env bash
#
# Create DB dump lib for MySQL/MariaDB DM's containers
#
# @author demmonico
# @link https://github.com/demmonico
# @image ubuntu-mariadb
#


# create DB dump
function mysqlDumpCreate()
{
    local formatOutput='sql'
    local DB_NAME=${DMC_DB_NAME:-${DM_PROJECT}}
    local FILE=`date +${DMC_DB_FILES_DIR}/${DB_NAME}_%Y-%m-%d_%H-%M-%S.sql`
    local ROOT_PWD="${DMC_ROOT_PASSWD:-rootPasswd}"
    local PARAMS="-u root -p${ROOT_PWD} --default-character-set=utf8 --single-transaction --add-drop-database --add-drop-table"

    if [ "${formatOutput}" == 'gzip' ]; then
        FILE="${FILE}.gz"
        sudo mysqldump ${PARAMS} --databases ${DB_NAME} | gzip > "${FILE}" && sudo chown mysql:mysql "${FILE}"
    else
        sudo mysqldump ${PARAMS} --databases ${DB_NAME} > "${FILE}" && sudo chown mysql:mysql "${FILE}"
    fi
}

mysqlDumpCreate $1
