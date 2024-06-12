#!/usr/bin/env bash

liquibase \
  --log-level=INFO \
  --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_DBNAMEA" \
  --classpath=/liquibase/changelog --changeLogFile=dbchangelog.xml \
  --username=$DB_USER \
  --password=$DB_PASS update
