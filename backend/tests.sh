#!/bin/bash
set -e

if [ -z "$1" ]; then
    CURRENT_PACKAGE="$VANILLA_PACKAGE.apis"
else
    CURRENT_PACKAGE=$1
fi

echo "Launching unittests with coverage"
echo "Package: $CURRENT_PACKAGE"
sleep 1

py.test --confcutdir=tests -x -s --cov=$CURRENT_PACKAGE tests