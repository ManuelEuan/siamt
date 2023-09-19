#!/usr/bin/env bash

docker builder prune -af
array=()
if [ $# -eq 0 ]; then
  echo "No arguments supplied, building all"
  array=( base-njs-16 base-api gateway liquibase )
else
  array=( "$@" )
fi

for i in "${array[@]}"
do
	echo "Building" $i
	cd $i
	docker build -t registry.gitlab.com/yucatan/siamt/$i -f ./dockerfile-base .
	docker push registry.gitlab.com/yucatan/siamt/$i
	cd ..
done