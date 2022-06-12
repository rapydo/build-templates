#!/bin/bash
echo "$(mariadb --version | sed 's/,.*//g')"