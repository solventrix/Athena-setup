@ECHO off

echo "Log into Harbor"
docker login harbor.athenafederation.org

echo "Pull the latest Data Profiler image"
docker pull harbor.athenafederation.org/distributed-analytics/data-profiler:latest

echo "Run Data Profiler"
docker run --rm --name data-profiler -v shared:/var/lib/shared -v %CD%\data_profiler_results:/script/data_profiler_results --env THERAPEUTIC_AREA=ATHENA --env INDICATION=uc --network feder8-net harbor.athenafederation.org/distributed-analytics/data-profiler:latest


