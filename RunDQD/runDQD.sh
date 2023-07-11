#!/usr/bin/env bash
set -ex

REGISTRY=harbor.athenafederation.org
REPOSITORY=distributed-analytics
IMAGE=data-quality-dashboard
VERSION=latest
TAG=$VERSION

echo "Harbor image repo login"
docker login $REGISTRY

echo "Pull latest DQD image"
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

touch dqd.env

echo "THERAPEUTIC_AREA=ATHENA" >> dqd.env

echo "Run DQD..."
docker run \
--rm \
--name dqd \
--env-file dqd.env \
-v ${PWD}/output:/script/output \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

rm -rf dqd.env
