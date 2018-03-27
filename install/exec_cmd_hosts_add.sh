#!/usr/bin/env bash
#
# Add hosts script for DM's containers
#
# @author demmonico
# @link https://github.com/demmonico
#
# FORMAT:
#   ./script HOST_IP_OR_CONTAINER_NAME HOST_NAME
#


# import
function hostsAdd()
{
    local HOST_IP=$1
    local HOST_NAME=$2

    # if doesn't match IP then try to find by container name
    [[ ${HOST_IP} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || HOST_IP=$( getent hosts "${HOST_IP}" | awk '{ print $1 }' )

    if [ -z "${HOST_IP}" ]; then
        echo "Unknown host IP \"${HOST_IP}\" related to container \"$1\". Append to hosts failed"
    else
        # suppress exists
        if [ ! -z "$( cat /etc/hosts | grep -P "[[:space:]]${HOST_NAME}[[:space:]]?" )" ]; then
            sed "s/^[0-9.]*[\t ]*${HOST_NAME}\s*$/#&/g" /etc/hosts | sudo tee /etc/hosts >/dev/null 2>&1
        fi
        # add
        echo -e "${HOST_IP}\t${HOST_NAME}" | sudo tee -a /etc/hosts >/dev/null 2>&1;
    fi
}

hostsAdd $1 $2
