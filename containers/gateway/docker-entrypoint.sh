#!/usr/bin/env bash

set -e

echo "$0: Looking for template files in /etc/nginx/..."
for f in $(/usr/bin/find /etc/nginx -type f -name "*.template"); do
  echo "$0: Evaluating $f";
  genvsub < $f > ${f/template/conf}
done

echo "$0: Executing $@"
exec "$@"