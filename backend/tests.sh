#!/bin/bash
set -e

if [ ! -d "tests" ]; then
    echo "Missing 'tests' directory"
    echo "Did you use the '--development' option when starting?"
    exit 1
fi

if [ -z "$1" ]; then
    CURRENT_PACKAGE="$VANILLA_PACKAGE"
    COV="--cov=$CURRENT_PACKAGE.apis --cov=$CURRENT_PACKAGE.tasks --cov=$CURRENT_PACKAGE.models"
else
    CURRENT_PACKAGE=$1
    COV="--cov=$CURRENT_PACKAGE"
fi

echo "Launching unittests with coverage"
echo "Package: $CURRENT_PACKAGE"
sleep 1

py.test --confcutdir=tests -x -s $COV tests
