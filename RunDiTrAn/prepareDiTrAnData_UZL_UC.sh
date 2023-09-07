docker login harbor.athenafederation.org

docker pull harbor.athenafederation.org/distributed-analytics/event-generator:0.2.5
docker pull harbor.athenafederation.org/distributed-analytics/analysis-table-generator-uc:1.1.3
docker pull harbor.athenafederation.org/athena-restricted/ditran-data-pipeline-uc:1.5.1

mkdir -p ${PWD}/results/predefined_events
mkdir -p ${PWD}/results/derived_events
mkdir -p ${PWD}/results/predefined_analysis
mkdir -p ${PWD}/results/derived_analysis
mkdir -p ${PWD}/results/ditran

echo "run 'predefined' event generator"
docker run --rm --network feder8-net -v ${PWD}/results/predefined_events:/script/analysis_table_results --env THERAPEUTIC_AREA=athena --env INDICATION=uc --env EVENT_CONFIG_FILENAME=uc_event_model --env STUDY_LOGIC=uzl_uc --env EPISODE_TABLE_SCHEMA=results --env LOGGING=INFO --env EPISODE_TABLE_NAME=predefined_episode_table_uc harbor.athenafederation.org/distributed-analytics/event-generator:0.2.5

echo "run 'derived' event generator"
docker run --rm --network feder8-net -v ${PWD}/results/derived_events:/script/analysis_table_results --env THERAPEUTIC_AREA=athena --env INDICATION=uc --env STUDY_LOGIC=uzl_uc --env EPISODE_TABLE_SCHEMA=results --env LOGGING=INFO --env EPISODE_TABLE_NAME=derived_episode_table_uc harbor.athenafederation.org/distributed-analytics/event-generator:0.2.5

echo "create table 'results.hybrid_episode_table_uc'"
docker exec -it postgres psql -U athena_admin -d OHDSI -c "DROP TABLE IF EXISTS results.hybrid_episode_table_uc;CREATE TABLE results.hybrid_episode_table_uc as select * from ( select * from results.derived_episode_table_uc where episode_number = 0 union select * from results.predefined_episode_table_uc where episode_number > 0) hybrid_table where person_id in ( select person_id from results.derived_episode_table_uc where episode_number = 0 );"

echo "create analysis table with predefined events"
docker run --rm --network feder8-net -v ${PWD}/results/predefined_analysis:/script/results --env THERAPEUTIC_AREA=athena --env INDICATION=uc --env VERSION=1.1.3 --env ANALYSIS_TABLE_SCHEMA=results --env ANALYSIS_TABLE_NAME=predefined_analysis_table_uc --env EXPOSURE_TABLE_SCRIPT=exposure_uc_omop53 --env DERIVATE_TABLE_SCRIPT=derivate_uc --env OUTCOME_TABLE_SCRIPT=outcome_uc --env EPISODE_TABLE_SCHEMA=results --env EPISODE_TABLE_NAME=predefined_episode_table_uc --env COVARIATE_CONFIGURATION=configuration_uc harbor.athenafederation.org/distributed-analytics/analysis-table-generator-uc:1.1.3

echo "create analysis table with derived events"
docker run --rm --network feder8-net -v ${PWD}/results/derived_analysis:/script/results  --env THERAPEUTIC_AREA=athena --env INDICATION=uc --env VERSION=1.1.3 --env ANALYSIS_TABLE_SCHEMA=results --env ANALYSIS_TABLE_NAME=derived_analysis_table_uc --env EXPOSURE_TABLE_SCRIPT=exposure_uc_omop53 --env DERIVATE_TABLE_SCRIPT=derivate_uc --env OUTCOME_TABLE_SCRIPT=outcome_uc --env EPISODE_TABLE_SCHEMA=results --env EPISODE_TABLE_NAME=derived_episode_table_uc --env COVARIATE_CONFIGURATION=configuration_uc harbor.athenafederation.org/distributed-analytics/analysis-table-generator-uc:1.1.3

echo "create analysis table with hybrid events"
docker run --rm --network feder8-net -v ${PWD}/results/derived_analysis:/script/results  --env THERAPEUTIC_AREA=athena --env INDICATION=uc --env VERSION=1.1.3 --env ANALYSIS_TABLE_SCHEMA=results --env ANALYSIS_TABLE_NAME=hybrid_analysis_table_uc --env EXPOSURE_TABLE_SCRIPT=exposure_uc_omop53 --env DERIVATE_TABLE_SCRIPT=derivate_uc --env OUTCOME_TABLE_SCRIPT=outcome_uc --env EPISODE_TABLE_SCHEMA=results --env EPISODE_TABLE_NAME=hybrid_episode_table_uc --env COVARIATE_CONFIGURATION=configuration_uc harbor.athenafederation.org/distributed-analytics/analysis-table-generator-uc:1.1.3

echo "combine analysis tables"
docker exec -it postgres psql -U athena_admin -d OHDSI -c "DROP TABLE IF EXISTS results.combined_analysis_table_uc;CREATE TABLE results.combined_analysis_table_uc as select *, 'predefined' as event_type from results.predefined_analysis_table_uc union select *, 'derived' as event_type from results.derived_analysis_table_uc union select *, ‘hybrid’ as event_type from results.hybrid_analysis_table_uc;"
echo "correct DB permissions if needed"
docker exec -it postgres psql -U postgres -d OHDSI -c "REASSIGN OWNED BY athena_admin TO ohdsi_admin;REASSIGN OWNED BY ohdsi_app_user TO ohdsi_app;grant select on results.combined_analysis_table_uc to ohdsi_app;"

echo "run DiTrAn pipeline script"
docker run --rm --network feder8-net -v ${PWD}/results/ditran:/script/shareable_results --name disease-explorer-data-preparation -v disease-explorer-config:/script/data --env THERAPEUTIC_AREA=athena --env INDICATION=uc --env DB_ANALYSIS_TABLE_SCHEMA=results --env DB_ANALYSIS_TABLE_NAME=combined_analysis_table_uc --env PIPELINE_CONFIGURATION=uc --env CONFIG_FILENAME=journey_configuration_combined --env LOGGING=INFO harbor.athenafederation.org/athena-restricted/ditran-data-pipeline-uc:1.5.1

echo "tar results"
tar -czvf results.tar.gz ${PWD}/results/

echo "Run count query"
docker exec -it postgres psql -U postgres -d OHDSI -c "select summary_table.concept_id, concept_name, count(*) from ( 	select * from ( SELECT person_id, drug_concept_id as concept_id, MIN(drug_exposure_start_date) AS start_date FROM omopcdm.drug_exposure WHERE drug_concept_id IN (19086176, 1389036, 1344354) AND drug_exposure_start_date != '1970-01-01' 	GROUP BY person_id, drug_concept_id union SELECT person_id, procedure_concept_id as concept_id, MIN(procedure_date) AS start_date FROM omopcdm.procedure_occurrence WHERE procedure_concept_id IN (4273866, 4305077) AND procedure_date != '1970-01-01' GROUP BY person_id, procedure_concept_id union SELECT person_id, measurement_concept_id as concept_id, MIN(measurement_date) AS start_date FROM omopcdm.measurement WHERE measurement_concept_id IN (4120182, 4123029, 4123028, 4084390, 36769340, 36768674, 36769996, 4123027)	AND measurement_date != '1970-01-01' GROUP BY person_id, measurement_concept_id union  SELECT person_id, observation_concept_id as concept_id, MIN(observation_date) AS start_date FROM omopcdm.observation WHERE observation_concept_id IN (4137845, 4298625, 4135617, 40534958, 4078485, 4286333, 4077864) AND observation_date != '1970-01-01' GROUP BY person_id, observation_concept_id union SELECT person_id, condition_concept_id as concept_id, MIN(condition_start_date) AS start_date FROM omopcdm.condition_occurrence WHERE condition_concept_id in (4241433,4241802,4240434,4240433,4097297,3661449,3661451, 4113111) AND condition_start_date != '1970-01-01' GROUP BY person_id, condition_concept_id ) cov_table right join ( 	select person_id, episode_start_date from results.derived_episode_table_uc detu  where episode_number = 0 	) diag_table on cov_table.person_id = diag_table.person_id 	where cov_table.start_date < diag_table.episode_start_date ) summary_table join omopcdm.concept c  on summary_table.concept_id = c.concept_id group by (summary_table.concept_id, concept_name);"

echo "end of pipeline"

