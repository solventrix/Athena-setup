@ECHO off

docker login harbor.athenafederation.org

docker pull harbor.athenafederation.org/distributed-analytics/achilles:latest

docker run --rm --name achilles -v shared:/var/lib/shared --env THERAPEUTIC_AREA=ATHENA --env CDM_VERSION=5.4 --network feder8-net harbor.athenafederation.org/distributed-analytics/achilles:latest
