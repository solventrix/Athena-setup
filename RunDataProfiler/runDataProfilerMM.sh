#!/usr/bin/env bash
set -e

REGISTRY=harbor.athenafederation.org
REPOSITORY=distributed-analytics
IMAGE=data-profiler
VERSION=latest
TAG=$VERSION

echo "Log into Harbor"
docker login $REGISTRY

echo "Pull the latest Data Profiler image"
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

touch data-profiler.env
echo "THERAPEUTIC_AREA=ATHENA" >> data-profiler.env
echo "INDICATION=mm"  >> data-profiler.env
echo "LOG_LEVEL=INFO" >> data-profiler.env

echo "Run Data Profiler MM"

docker run \
--rm \
--name data-profiler \
-v shared:/var/lib/shared \
-v ${PWD}/data_profiler_results:/script/data_profiler_results \
--env-file data-profiler.env \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

rm -rf data-profiler.env
