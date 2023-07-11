@ECHO off

SET REGISTRY=harbor.athenafederation.org
SET REPOSITORY=distributed-analytics
SET IMAGE=data-quality-pipeline
SET VERSION=latest
SET TAG=%VERSION%
SET QA_FOLDER_HOST=%CD%\qa

echo "Docker login @ %REGISTRY%"
docker login %REGISTRY%

echo "Pull latest data quality pipeline image"
docker pull %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%

echo "Run data quality pipeline"
docker run --rm --name data-quality-pipeline --env REGISTRY=%REGISTRY% --env THERAPEUTIC_AREA=athena --env INDICATION=uc --env QA_FOLDER_HOST=%QA_FOLDER_HOST% --env CDM_VERSION=5.4  -v /var/run/docker.sock:/var/run/docker.sock --network feder8-net %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%
