#!/bin/bash

if [ "$1" != 'useradd' ]; then
	echo "Command not found, allowed commands: useradd"
	exit 1
fi

if [ "$2" == '' ]; then
	echo "Missing user name"
	echo "Usage: ${0} useradd username userhome userpwd"
	exit 1
fi

if [ "$3" == '' ]; then
	echo "Missing user home"
	echo "Usage: ${0} useradd username userhome userpwd"
	exit 1
fi

if [ "$4" == '' ]; then
	echo "Missing user password"
	echo "Usage: ${0} useradd username userhome userpwd"
	exit 1
fi

echo "pure-pw $1 $2 -f /etc/pure-ftpd/passwd/pureftpd.passwd -m -u ftpuser -d /home/ftpusers/$3 < $4"
