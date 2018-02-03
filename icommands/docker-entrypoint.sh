#!/bin/bash
set -e

if [ "$1" != 'download' ]; then
    echo "Requested custom command:"
    echo "\$ $@"
    $@
    exit 0
fi

######################################
#
# Entrypoint!
#
######################################

# IRODS_PASSWORD=chooseapasswordwisely
# IRODS_VERSION=4.2.1
# IRODS_UID=1001
# IRODS_UNAME=irods

###############
# Extra scripts
dedir="/docker-entrypoint.d"
for f in `ls $dedir`; do
    case "$f" in
        *.sh)     echo "running $f"; bash "$dedir/$f" ;;
        *)        echo "ignoring $f" ;;
    esac
    echo
done

###############
# DO THE COPY
# 1. check if IRODS_HOST variable exists
if [ "$IRODS_HOST" != "" ]; then

    # what you need is:
    # IRODS_HOST=172.20.0.2
    # IRODS_PORT=1247
    # IRODS_USER_NAME=irods
    # IRODS_ZONE_NAME=tempZone
    # IRODS_PASSWORD=some

    # env

    # 2. log out, try iinit and set password
    iexit full
    # https://docs.irods.org/4.1.2/manual/configuration/#irodsirodsa
    yes $IRODS_PASSWORD | iinit
    # exec yes $IRODS_PASSWORD | iinit 2> /dev/null
    if [ "$?" != "0" ]; then
        echo "FAILURE: not able to login to irods"
        exit 1
    else
        echo 'irods login completed'
    fi
    # 3. check with ils
    ils
    if [ "$?" != "0" ]; then
        echo "FAILURE: not able to test ils"
        exit 1
    fi

    # 4. copy the file

else
    echo "Please set IRODS minimum set of variables as described in:"
    echo "https://docs.irods.org/4.2.2/system_overview/configuration"
    exit 1
fi

# # what else?
# exec sleep infinity
