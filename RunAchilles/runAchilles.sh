#!/usr/bin/env bash
set -ex

VERSION=1.0.0
TAG=$VERSION

touch achilles.env

echo "DB_HOST=postgres" >> achilles.env
echo "DB_DATABASE_NAME=OHDSI" >> achilles.env
echo "FEDER8_CDM_SCHEMA=omopcdm" >> achilles.env
echo "FEDER8_VOCABULARY_SCHEMA=omopcdm" >> achilles.env
echo "FEDER8_RESULTS_SCHEMA=results" >> achilles.env
echo "WEBAPI_SOURCE_NAME=ATHENA OMOP CDM" >> achilles.env
echo "THERAPEUTIC_AREA=ATHENA" >> achilles.env
echo "SCRIPT_UUID=b016c8a2-f2c9-43de-b62f-ed1c29a5726d"  >> achilles.env

docker run \
--rm \
--name achilles \
-v shared:/var/lib/shared \
--env-file achilles.env \
--network athena-net \
harbor-uat.athenafederation.org/distributed-analytics/achilles:$TAG

rm -rf achilles.env
