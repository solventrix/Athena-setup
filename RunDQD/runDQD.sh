#!/usr/bin/env bash
set -ex

echo "Harbor image repo login"
docker login harbor-uat.athenafederation.org

touch dqd.env

echo "THERAPEUTIC_AREA=ATHENA" >> dqd.env
echo "SCRIPT_UUID=2e72f604-62da-4e1e-8523-8495103586be"  >> dqd.env

echo "Run DQD..."
docker run \
--rm \
--name dqd \
--env-file dqd.env \
--network athena-net \
harbor-uat.athenafederation.org/distributed-analytics/data-quality-dashboard:2.0.14

rm -rf dqd.env
