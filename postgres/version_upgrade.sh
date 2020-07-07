#!/bin/bash

echo ""

PGFOLDER="/var/lib/postgresql"
DATAFOLDER="${PGFOLDER}/current"

# env variable
if [[ $DATAFOLDER != $PGDATA ]]; then
    echo "Env variable PGDATA is expected to be equal to ${DATAFOLDER} and not ${PGDATA}, cannot continue"
    exit 1
fi

if [[ -f $DATAFOLDER ]]; then
    echo "Unexcepted ${DATAFOLDER} type, it is a file"
    exit 1
fi

if [[ ! -L $DATAFOLDER ]]; then
    echo "Unexcepted ${DATAFOLDER} type, is it a folder? A link is expected"
    exit 1
fi

if [[ ! -f $DATAFOLDER/PG_VERSION ]]; then
    echo "${DATAFOLDER}/PG_VERSION not found"
    exit 1
fi

CURRENT_VERSION=$(cat ${DATAFOLDER}/PG_VERSION)
if [[ -z "${CURRENT_VERSION##*[!0-9]*}" ]]; then
	echo "Current version ${CURRENT_VERSION} is not a number"
	exit 1
fi

NEW_VERSION=$PG_MAJOR
if [[ -z "${NEW_VERSION##*[!0-9]*}" ]]; then
    echo "New version ${NEW_VERSION} is not a number"
    exit 1
fi

if [[ ${CURRENT_VERSION} -eq ${NEW_VERSION} ]]; then
    echo "Current version is already upgraded to version ${NEW_VERSION}"
    exit 1
fi

if [[ ${CURRENT_VERSION} -gt ${NEW_VERSION} ]]; then
    echo "Current version (${CURRENT_VERSION}) is greater then new version (${NEW_VERSION}). Downgrade is not supported"
    exit 1
fi

# This is the case data is already a link to a version-aware folder
if [[ -L $DATAFOLDER ]]; then
    REAL_PATH=$(realpath $DATAFOLDER)
    if [[ $REAL_PATH != ${PGFOLDER}/${CURRENT_VERSION} ]]; then
        echo "Data folder is expected to be a link to ${PGFOLDER}/${CURRENT_VERSION}, but ${REAL_PATH} is found"
        exit 1
    fi
fi

let NEXT_VERSION=CURRENT_VERSION+1
if [[ $NEXT_VERSION -lt ${NEW_VERSION} ]]; then
    echo "WARNING!"
    echo "You requested to upgrade from version ${CURRENT_VERSION} to version ${NEW_VERSION}"
    echo "It is always advisable to upgrade 1 major version at a time."
    echo ""
    echo "If you want to continue, ignore this warning."
    echo "Otherwise CTRL+C to interrupt the current operation"
    echo ""
    SLEEP=10
    echo "Sleeping ${SLEEP} seconds..."
    sleep $SLEEP
fi

echo "You requested to upgrade from version ${CURRENT_VERSION} to version ${NEW_VERSION}."
echo ""

${PGFOLDER}/${NEW_VERSION}

if [[ ! -d ${PGFOLDER}/${NEW_VERSION} ]]; then
    echo "${PGFOLDER}/${NEW_VERSION} is missing, creating it..."
    mkdir -p ${PGFOLDER}/${NEW_VERSION}
    chown postgres ${PGFOLDER}/${NEW_VERSION}
fi

if [ ! -z "$(ls -A ${PGFOLDER}/${NEW_VERSION})" ]; then
    echo "${PGFOLDER}/${NEW_VERSION} is not empty, cannot upgrade"
    exit 1
fi

if [[ -z $1 ]]; then

    echo "Please select one of the following backup files."
    echo "If none is listed, please make a backup before starting this upgrade script"
    echo ""

    for BACKUP_NAME in $(ls ${PGFOLDER}/${CURRENT_VERSION}/*.sql); do
        echo -e "$(basename $BACKUP_NAME) $(stat -c '\tSize: %s\tModified: %z' ${BACKUP_NAME})"
    done

    echo ""
    echo "To select a backup:"
    echo "$0 backup_filename"

    exit 1
else
    BACKUP_NAME=$1
    if [[ -f ${PGFOLDER}/${CURRENT_VERSION}/${BACKUP_NAME} ]]; then
        echo -e "You selected backup:\t${BACKUP_NAME} $(stat -c '\tSize: %s\tModified: %z' ${DATAFOLDER}/${BACKUP_NAME})"
        echo ""
    else
        echo "Backup file ${BACKUP_NAME} not found in ${PGFOLDER}/${CURRENT_VERSION}"
        exit 1
    fi
fi

SLEEP_TIME=5
echo "##################################################################"
# Update the current link to the TO folder
echo "The following command will update the current link to the new ${NEW_VERSION} folder"
echo ln -sfT ${PGFOLDER}/${NEW_VERSION} ${DATAFOLDER}
echo "Sleeping ${SLEEP_TIME} seconds..."
sleep $SLEEP_TIME
ln -sfT ${PGFOLDER}/${NEW_VERSION} ${DATAFOLDER}
echo ""

echo "##################################################################"
# Initialize the new database folder
echo "The following command will initialize the new folder ${NEW_VERSION}"
echo su -c \"initdb -D ${DATAFOLDER}\" postgres
echo "Sleeping ${SLEEP_TIME} seconds..."
sleep $SLEEP_TIME
su -c "initdb -D ${DATAFOLDER}" postgres
echo ""

echo "##################################################################"
# Restore previous configuration files
echo "pg_hba.conf and postgresql.conf will be copied from version ${CURRENT_VERSION} to version ${NEW_VERSION}"
echo "Sleeping ${SLEEP_TIME} seconds..."
sleep $SLEEP_TIME
cp -p ${PGFOLDER}/${CURRENT_VERSION}/pg_hba.conf ${PGFOLDER}/${NEW_VERSION}/pg_hba.conf
cp -p ${PGFOLDER}/${CURRENT_VERSION}/postgresql.conf ${PGFOLDER}/${NEW_VERSION}/postgresql.conf
echo ""

echo "##################################################################"
# Run postgres
echo "Postgres server will be executed"
echo "Sleeping ${SLEEP_TIME} seconds..."
sleep $SLEEP_TIME
su -c "postgres -D ${DATAFOLDER}" postgres &
echo ""

echo ""
echo "Waiting postgres to start"
sleep 10
echo ""

echo "##################################################################"
# Restore the sqluser
echo "The following command will recreate the ${POSTGRES_USER} user"
echo su -c \"createuser -s ${POSTGRES_USER}\" postgres
echo "Sleeping ${SLEEP_TIME} seconds..."
sleep $SLEEP_TIME
su -c "createuser -s ${POSTGRES_USER}" postgres
echo ""

echo "##################################################################"
# Restore the backup
echo "The following command will restore the database from ${BACKUP_NAME}"
echo su -c \"psql -U ${POSTGRES_USER} -d postgres -f ${PGFOLDER}/${CURRENT_VERSION}/${BACKUP_NAME}\" postgres
echo "Sleeping ${SLEEP_TIME} seconds..."
sleep $SLEEP_TIME
su -c "psql -U ${POSTGRES_USER} -d postgres -f ${PGFOLDER}/${CURRENT_VERSION}/${BACKUP_NAME}" postgres
echo ""


echo ""
echo "All done."
