#!/bin/bash
set -e

# Create the version datadir, if missing
mkdir -p $(dirname $PGDATA)/$PG_MAJOR

chown -R postgres $(dirname $PGDATA)/$PG_MAJOR

# Create current link, if missing
if [ ! -L $PGDATA/current ]; then
    ln -sT $PGDATA/$PG_MAJOR $PGDATA/current;
fi
