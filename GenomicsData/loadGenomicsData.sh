#!/usr/bin/env bash
set -eux

REGISTRY=harbor.athenafederation.org
REPOSITORY=distributed-analytics
IMAGE=genetic-data-loader
VERSION=1.0.0
TAG=$VERSION
CDM_SCHEMA=omopcdm

docker login $REGISTRY
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

docker exec -it postgres psql -U postgres -d OHDSI -c "ALTER TABLE $CDM_SCHEMA.measurement ALTER measurement_source_value TYPE VARCHAR(4096);"

docker run --rm --network feder8-net --env DB_CDM_SCHEMA=$CDM_SCHEMA --env THERAPEUTIC_AREA=ATHENA $REGISTRY/$REPOSITORY/$IMAGE:$TAG
