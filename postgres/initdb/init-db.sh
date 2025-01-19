#!/bin/bash

psql -v ON_ERROR_STOP=1 --username petclinic --dbname petclinic <<-EOSQL

  CREATE DATABASE petclinicaot WITH OWNER petclinic;
  CREATE DATABASE petcliniccds WITH OWNER petclinic;
  CREATE DATABASE petcliniccrac WITH OWNER petclinic;
  CREATE DATABASE petclinicnative WITH OWNER petclinic;
EOSQL

BACKUP_DIR=/docker-entrypoint-initdb.d/db_backup

DATABASES=(
  "rightdevops"
)

export PGPASSWORD=petclinic

#for db in "${DATABASES[@]}"; do
#  psql -U petclinic -d "$db" < "$BACKUP_DIR/$db.sql"
#done
