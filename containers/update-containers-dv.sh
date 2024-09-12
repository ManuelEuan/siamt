#!/usr/bin/env bash

GIT_USR=gitlab+deploy-token-3443868
GIT_PASS=muDmKDbsmjNysyBCkBvh
timestamp=$(TZ="America/Merida" date +"%d%m%y%H%M")

#docker builder prune -af
array=()
if [ $# -eq 0 ]; then
  echo "No arguments supplied, building all"
  array=( gateway app-ui app-api auth-api wss-njs liquibase app-manto-unidades-api signature-api app-inspections-api app-procedures-ap)
else
  array=( "$@" )
fi

for i in "${array[@]}"
do
	echo "Building" $i
	cd $i
	docker build \
	  --no-cache \
	  --build-arg GIT_USR=$GIT_USR \
	  --build-arg GIT_PASS=$GIT_PASS \
	  -t gitaty.transporteyucatan.org.mx:5050/aty/siamt/$i-dv \
	  -t gitaty.transporteyucatan.org.mx:5050/aty/siamt/$i-dv:$timestamp \
	  -f ./dockerfile-dv .
	docker push gitaty.transporteyucatan.org.mx:5050/aty/siamt/$i-dv --all-tags
	cd ..
done