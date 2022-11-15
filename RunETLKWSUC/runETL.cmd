@echo off

set "data_folder=.\data"
set /p "data_folder=Input Data folder [%data_folder%]: "

set "db_username=athena_admin"
set /p "db_username=DB username [%db_username%]: "

set "db_password=athena_admin"
set /p "db_password=DB password [%db_password%]: "

set "verbosity_level=INFO"
set /p "verbosity_level=Output verbosity level [%verbosity_level%]: "

set "image_tag=current"
set /p "image_tag=Docker Hub image tag [%image_tag%]: "

set "data_source=KUL"
set /p "data_source=Data source [%data_source%]: "

set "date_last_export=2021-06-01"
set /p "date_last_export=Date of last export yyyy-mm-dd [%date_last_export%]: "

curl -L https://raw.githubusercontent.com/solventrix/Athena-setup/master/RunETLKWSUC/docker-compose.yml --output docker-compose.yml

powershell -Command "(Get-Content docker-compose.yml) -replace 'data_folder', '%data_folder%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -replace 'db_username', '%db_username%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -replace 'db_password', '%db_password%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -replace 'verbosity_level', '%verbosity_level%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -replace 'image_tag', '%image_tag%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -replace 'data_source', '%data_source%' | Set-Content docker-compose.yml"
powershell -Command "(Get-Content docker-compose.yml) -replace 'date_last_export', '%date_last_export%' | Set-Content docker-compose.yml"

docker login harbor.athenafederation.org
docker-compose pull
docker-compose run --rm --name etl etl

