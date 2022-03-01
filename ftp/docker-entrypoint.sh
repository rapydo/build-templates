#!/bin/bash
set -e

if [[ ! -t 0 ]]; then
    /bin/bash /etc/banner.sh
fi

# if prod mode and file exists create pure-ftpd.pem
sleep infinity