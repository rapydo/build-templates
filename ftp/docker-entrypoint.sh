#!/bin/bash
set -e

if [[ ! -t 0 ]]; then
    /bin/bash /etc/banner.sh
fi

# if prod mode and file exists create pure-ftpd.pem
/run.sh -c 50 -C 10 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30019