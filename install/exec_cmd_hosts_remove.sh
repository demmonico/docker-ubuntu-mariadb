#!/usr/bin/env bash
#
# Remove hosts script for DM's containers
#
# @author demmonico
# @link https://github.com/demmonico
#
# FORMAT:
#   ./script HOST_NAME
#


# import
function hostsRemove()
{
    local HOST_NAME=$1

    if [ ! -z "$( cat /etc/hosts | grep -P "[[:space:]]${HOST_NAME}[[:space:]]?" )" ]; then
        sed "/^[0-9.]*[\t ]*${HOST_NAME}\s*$/d" /etc/hosts | sudo tee /etc/hosts >/dev/null 2>&1
    fi
}

hostsRemove $1
