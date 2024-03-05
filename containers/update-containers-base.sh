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
	docker build -t gitaty.transporteyucatan.org.mx:5050/aty/siamt/$i -f ./dockerfile-base .
	docker push gitaty.transporteyucatan.org.mx:5050/aty/siamt/$i
	cd ..
done