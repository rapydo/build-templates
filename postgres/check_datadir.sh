#!/bin/bash
set -e

DATADIR="$(dirname $PGDATA)/${PG_MAJOR}"
# Create the version datadir, if missing
mkdir -p ${DATADIR}

chown -R postgres ${DATADIR}

# Create current link, if missing
if [ ! -L $PGDATA ]; then
    ln -sT ${DATADIR} ${PGDATA};
fi
