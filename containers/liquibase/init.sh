#!/usr/bin/env bash


liquibase \
  --log-level=INFO \
  --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_DBNAME" \
  --classpath=/liquibase/changelog --changeLogFile=dbchangelog.xml \
  --username=$DB_USER \
  --password=$DB_PASS update


liquibase \
  --log-level=INFO \
  --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_DBNAME_INSP" \
  --classpath=/liquibase/changelog/inspeccion --changeLogFile=dbchangelog.xml \
  --username=$DB_USER \
  --password=$DB_PASS update

  liquibase \
    --log-level=INFO \
    --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_DBNAME_MANTO" \
    --classpath=/liquibase/changelog/manto --changeLogFile=dbchangelog.xml \
    --username=$DB_USER \
    --password=$DB_PASS update

  liquibase \
    --log-level=INFO \
    --url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_DBNAME_FIRMA" \
    --classpath=/liquibase/changelog/firma --changeLogFile=dbchangelog.xml \
    --username=$DB_USER \
    --password=$DB_PASS update