#!/usr/bin/env bash

#Always try to install modules
for subdir in $(find /srv/siamt/code -maxdepth 1 -mindepth 1 -type d); do
  cd $subdir
  if [ -f $subdir/yarn.lock ]; then
    echo "$0: Using yarn for $subdir"
    yarn install
  else
    echo "$0: Using npm for $subdir"
    npm install
  fi
done