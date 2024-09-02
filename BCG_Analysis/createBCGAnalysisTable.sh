#!/usr/bin/env bash
set -eux

REGISTRY=harbor.athenafederation.org
REPOSITORY=distributed-analytics
IMAGE=bcg-analysis-table
VERSION=1.0.2
TAG=$VERSION

echo "Log into $REGISTRY"
docker login $REGISTRY

echo "Pulling Docker image..."
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "Running Docker container..."
docker run --rm \
--name bcg-analysis-table \
--env THERAPEUTIC_AREA=athena \
-v $PWD/results:/script/results \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "end of script"