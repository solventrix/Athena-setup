#!/usr/bin/env bash
set -ex

REGISTRY=harbor.athenafederation.org
REPOSITORY=distributed-analytics
IMAGE=data-quality-pipeline
VERSION=latest
TAG=$VERSION
QA_FOLDER_HOST=${PWD}/qa

echo "Docker login @ $REGISTRY"
docker login $REGISTRY

echo "Pull latest data quality pipeline image"
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "Run data quality pipeline"

touch data-quality-pipeline.env
echo "REGISTRY=$REGISTRY" >> data-quality-pipeline.env
echo "THERAPEUTIC_AREA=athena" >> data-quality-pipeline.env
echo "INDICATION=uc" >> data-quality-pipeline.env
echo "CDM_VERSION=5.4"  >> data-quality-pipeline.env
echo "QA_FOLDER_HOST=$QA_FOLDER_HOST" >> data-quality-pipeline.env

docker run \
--rm \
--name data-quality-pipeline \
--env-file data-quality-pipeline.env \
-v /var/run/docker.sock:/var/run/docker.sock \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

rm -rf data-quality-pipeline.env
