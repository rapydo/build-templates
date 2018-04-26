#!/bin/bash

echo "Becoming B2SAFE"

###############
# Start up
shopt -s expand_aliases
source ~/.bash_aliases

###############
# Resources

# Create resources dirs
# mkdir -p $MAINRES_DIR $REPLICA_DIR
chown -R $IRODS_UNAME $RESOURCES_DIR

echo "Fix resources"
# TODO: demoResc should be a variable?
berods -c "iadmin rmresc demoResc"
# berods -c "iadmin rmresc $IRODS_DEFAULT_RESOURCE"
if [ "$?" != "0" ]; then
    echo "failed to admin resource"
    exit 1
fi
# Create resources
berods -c "iadmin mkresc $MAINRES unixfilesystem $IRODS_HOST:$MAINRES_DIR"
berods -c "iadmin mkresc $REPLICARES unixfilesystem $IRODS_HOST:$REPLICA_DIR"
# Set new default
sed -i "7s/demoResc/$MAINRES/" /home/$IRODS_UNAME/.irods/irods_environment.json
sed -i "21s/demoResc/$MAINRES/" /etc/irods/server_config.json

###############
# YET TO DO: resource for replication
## source:http://irods.org/post/configuring-irods-for-high-availability/#.VktEE98veGg
# iadmin mkresc BaseResource replication
# iadmin mkresc Resource1 'unixfilesystem' Resource1.example.org:/var/lib/irods/Vault
# iadmin mkresc Resource2 'unixfilesystem' Resource2.example.org:/var/lib/irods/Vault
# iadmin addchildtoresc BaseResource Resource1
# iadmin addchildtoresc BaseResource Resource2
# ilsresc --tree

###############
# B2SAFE INSTALLATION

# following
# https://github.com/EUDAT-B2SAFE/B2SAFE-core/blob/master/install.txt

# fix message bus strange BUG:
# unknown group 'messagebus' in statoverride file
sed -i '/messagebus/d' /var/lib/dpkg/statoverride

# install packages
dpkg -i /tmp/debbuild/irods*.deb
if [ "$?" == "0" ]; then
    echo "package prepared"
else
    echo "failed to install b2stage"
    exit 1
fi

# permissions
chown -R $IRODS_UNAME /opt

# prepare config
cd /opt/eudat/b2safe/packaging
# source $HANDLECONF
keytochange='CHANGEME'
sed -i "15s/$keytochange/$MAINRES/" $B2SAFE_CONFIG
sed -i "20s/$keytochange/$HOSTNAME/" $B2SAFE_CONFIG
# https://github.com/EUDAT-Training/B2SAFE-B2STAGE-Training/blob/master/11a-Setup-HTTP-API.md#download-and-install-b2safe
# put some variables here
# sed -i "22s/$keytochange/$HANDLE_BASE/" $B2SAFE_CONFIG
# sed -i "23s/$keytochange/$HANDLE_USER/" $B2SAFE_CONFIG
# sed -i "24s/$keytochange/$HANDLE_PREFIX/" $B2SAFE_CONFIG
cp $B2SAFE_CONFIG install.conf
chown $IRODS_UNAME install*

## YOU WILL BE PROMPTED FOR A PASSWORD
# # Install b2safe mod
# PASSFILE='mypass'
# echo $HANDLE_PASS > $PASSFILE
# ./install.sh < $PASSFILE
# rm $PASSFILE

# install
ANSWERS=/tmp/answers
echo "YES, I am really really really sure I want to use the old epicclient!" > $ANSWERS
echo "empty" >> $ANSWERS
berods -c "./install.sh < $ANSWERS"

# check scripts
cd /opt/eudat/b2safe/cmd \
    && ./authZmanager.py -h \
    && ./epicclient.py --help \
    && ./epicclient2.py --help \
    && ./logmanager.py -h \
    && ./messageManager.py -h \
    && ./timeconvert.py epoch_to_iso8601 2000000

# && ./metadataManager.py -h \ ## WHERE DID IT GO?


##########################
touch /opt/eudat/b2safe/rulebase/myrules.re
# change re_rulebase_set in /etc/irods/server_config.json
# order does count
#https://github.com/EUDAT-Training/B2SAFE-B2STAGE-Training/blob/master/11a-Setup-HTTP-API.md#installing-the-b2safe-replication-event-hook

# happening only in ON($objPath like "/$rodsZoneClient/home/$userNameClient/b2safe/*"){


##########################
# if federated
# hook EUDATReplication


##########################
if [ "$?" == "0" ]; then
    echo "EUDAT-B2SAFE setup completed"
else
    echo "It seems some of the B2SAFE cmd scripts failed"
    exit 1
fi
