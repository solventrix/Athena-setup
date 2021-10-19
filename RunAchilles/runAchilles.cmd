@echo off

echo "DB_HOST=postgres" > achilles.env
echo "DB_DATABASE_NAME=OHDSI" >> achilles.env
echo "FEDER8_CDM_SCHEMA=omopcdm" >> achilles.env
echo "FEDER8_VOCABULARY_SCHEMA=omopcdm" >> achilles.env
echo "FEDER8_RESULTS_SCHEMA=results" >> achilles.env
echo "WEBAPI_SOURCE_NAME=ATHENA OMOP CDM" >> achilles.env
echo "THERAPEUTIC_AREA=ATHENA" >> achilles.env
echo "SCRIPT_UUID=71b053b9-ecb7-4875-8da8-c12ee04e5076"  >> achilles.env

docker run \
--rm \
--name achilles \
-v shared:/var/lib/shared \
--env-file achilles.env \
--network athena-net \
harbor-uat.athenafederation.org/distributed-analytics/achilles:1.0.0

Del achilles.env
