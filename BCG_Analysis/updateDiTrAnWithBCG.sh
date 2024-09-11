#!/usr/bin/env bash
set -eux

REGISTRY=harbor.athenafederation.org

echo "Log into $REGISTRY"
docker login $REGISTRY

echo "Creating analysis table"
REPOSITORY=distributed-analytics
IMAGE=analysis-table-generator-uc
VERSION=1.1.11
TAG=$VERSION

docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

mkdir -p ${PWD}/results/analysis

docker run --rm \
--network feder8-net -v ${PWD}/results/analysis:/script/results \
--env THERAPEUTIC_AREA=athena --env INDICATION=uc --env VERSION=$VERSION \
--env ANALYSIS_TABLE_SCHEMA=results --env ANALYSIS_TABLE_NAME=analysis_table_uc \
--env EXPOSURE_TABLE_SCRIPT= --env EXPOSURE_TABLE_NAME= \
--env DERIVATE_TABLE_SCRIPT=derivate_uc \
--env OUTCOME_TABLE_SCRIPT=outcome_uc --env EPISODE_TABLE_SCRIPT=episode_uc \
--env COVARIATE_CONFIGURATION=configuration_uc_hr \
--env ADD_RETRO_COLUMNS=FALSE \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "Running BCG analysis..."
REPOSITORY=distributed-analytics
IMAGE=bcg-analysis-table
VERSION=1.0.10
TAG=$VERSION

docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

mkdir -p ${PWD}/results/bcg

docker run --rm \
--name bcg-analysis-table \
--env THERAPEUTIC_AREA=athena \
-v $PWD/results/bcg:/script/results \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "run DiTrAn data pipeline"
REPOSITORY=athena-restricted
IMAGE=ditran-data-pipeline-uc
VERSION=1.5.5
TAG=$VERSION

docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

mkdir -p ${PWD}/results/ditran

docker run --rm \
--name ditran-data-preparation \
--env THERAPEUTIC_AREA=athena --env INDICATION=uc \
--env DB_ANALYSIS_TABLE_SCHEMA=results --env DB_ANALYSIS_TABLE_NAME=analysis_table_uc \
--env PIPELINE_CONFIGURATION=uc --env CONFIG_FILENAME=journey_configuration --env LOGGING=INFO \
-v ${PWD}/results/ditran:/script/shareable_results  \
-v disease-explorer-config:/pipeline/data \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

echo "end of script"

