#!/usr/bin/env bash

#Always try to install modules
for subdir in $(find $CODE_BASE -maxdepth 2 -mindepth 1 -type d); do
  cd $subdir
  if [ -f $subdir/composer.json ]; then
    echo "$0: Using composer for $subdir"
    ./composer.phar install --ignore-platform-req=ext-curl --ignore-platform-req=ext-simplexml --ignore-platform-req=ext-xmlwriter -n
  fi
done
