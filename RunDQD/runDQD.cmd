@echo off

echo "THERAPEUTIC_AREA=ATHENA" > dqd.env
echo "SCRIPT_UUID=2e72f604-62da-4e1e-8523-8495103586be"  >> dqd.env

docker run \
--rm \
--name dqd \
--env-file dqd.env \
--network athena-net \
harbor-uat.athenafederation.org/distributed-analytics/data-quality-dashboard:2.0.14

Del dqd.env
