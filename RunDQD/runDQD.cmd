@echo off

docker login harbor.athenafederation.org

docker pull harbor.athenafederation.org/distributed-analytics/data-quality-dashboard:latest

docker run --rm --name dqd --env THERAPEUTIC_AREA=ATHENA -v %CD%\output:/script/output --network feder8-net harbor.athenafederation.org/distributed-analytics/data-quality-dashboard:latest
