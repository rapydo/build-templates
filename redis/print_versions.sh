#!/bin/bash
echo "$(redis-server --version | awk '{ print $3}')"
