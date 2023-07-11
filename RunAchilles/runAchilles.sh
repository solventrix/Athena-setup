#!/usr/bin/env bash
set -ex

REGISTRY=harbor.athenafederation.org
REPOSITORY=distributed-analytics
IMAGE=achilles
VERSION=latest
TAG=$VERSION

echo "Log into Harbor"
docker login $REGISTRY

echo "Pull latest Achilles image"
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

touch achilles.env

echo "THERAPEUTIC_AREA=ATHENA" >> achilles.env
# echo "CDM_VERSION=5.3" >> achilles.env
echo "CDM_VERSION=5.4" >> achilles.env
echo "EXCLUDED_ANALYSIS_IDS=231,232,931,932,1031,1032,1810,1824,1831,1832"  >> achilles.env

docker run \
--rm \
--name achilles \
-v shared:/var/lib/shared \
--env-file achilles.env \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

rm -rf achilles.env
