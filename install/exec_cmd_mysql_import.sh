#!/usr/bin/env bash
#
# Import script for MySQL/MariaDB DM's containers
#
# @author demmonico
# @link https://github.com/demmonico
# @image ubuntu-mariadb
#
# FORMAT:
#   ./script FILENAME
#


# import
function mysqlImport()
{
    local FILENAME=$1
    local FILE="${DMC_DB_FILES_DIR}/${FILENAME}"
    [ ! -f "${FILE}" ] && echo "Import file (${FILE}) doesn't exists" && exit 1

    local DB_NAME="${DMC_DB_NAME:-${DM_PROJECT}}"
    local ROOT_PWD="${DMC_ROOT_PASSWD:-rootPasswd}"
    local PARAMS="-u root -p${ROOT_PWD} ${DB_NAME}"

    if [[ "${FILE}" == *".gz" ]]; then
        zcat "${FILE}" | mysql ${PARAMS}
    else
        mysql ${PARAMS} < "${FILE}"
    fi
}

mysqlImport $1
