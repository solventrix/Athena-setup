#!/usr/bin/env bash
set -ex

VERSION=1.2.1
TAG=$VERSION
REGISTRY=harbor.athenafederation.org
REPOSITORY=athena-restricted
IMAGE=ditran-data-pipeline-mm

echo "Docker login at $REGISTRY"
docker login $REGISTRY

echo "Pull DiTrAn data preparation image"
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

touch data-preparation.env

echo "THERAPEUTIC_AREA=athena" >> data-preparation.env
echo "DB_ANALYSIS_TABLE_NAME=analysis_table" >> data-preparation.env
#echo "DB_ANALYSIS_TABLE_SCHEMA=public" >> data-preparation.env

echo "Run DiTrAn data preparation"

docker run \
--rm \
--name disease-explorer-data-preparation \
-v disease-explorer-config:/pipeline/data \
--env-file data-preparation.env \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

rm -rf data-preparation.env

echo "Pull DiTrAn image"
docker pull harbor.athenafederation.org/athena-restricted/disease-explorer:latest
