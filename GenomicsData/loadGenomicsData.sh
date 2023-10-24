#!/usr/bin/env bash
set -eux

REGISTRY=harbor.athenafederation.org
REPOSITORY=distributed-analytics
IMAGE=genomics-data-loader
VERSION=1.1.0
TAG=$VERSION
THERAPEUTIC_AREA=ATHENA
CDM_SCHEMA=omopcdm

read -p "Input Data folder [./data]: " DATA_FOLDER
DATA_FOLDER=${DATA_FOLDER:-${PWD}/data}

docker login $REGISTRY
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "Delete old test data"
docker exec -it postgres psql -U postgres -d OHDSI -c "DELETE FROM $CDM_SCHEMA.measurement WHERE measurement_date = '2023-09-07';"
echo "Increase length of 'measurement_source_value' column"
docker exec -it postgres psql -U postgres -d OHDSI -c "ALTER TABLE $CDM_SCHEMA.measurement ALTER measurement_source_value TYPE VARCHAR(4096);"
echo "Load genomics data"
docker run --rm --network feder8-net -v "$DATA_FOLDER":/script/data --env DB_CDM_SCHEMA=$CDM_SCHEMA --env THERAPEUTIC_AREA=$THERAPEUTIC_AREA $REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "end of script"