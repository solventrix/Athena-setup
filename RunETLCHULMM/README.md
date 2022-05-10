# How to execute the ETL for CHU Liege MM ATHENA data

## Prerequisites
1. Docker is installed and running.
2. docker-compose is installed. Please follow the instructions for installation  https://docs.docker.com/compose/install/
3. The user has access to the https://harbor-uat.athenafederation.org repository containing the ETL image.
4. The ATHENA OMOP CDM database is running in a Docker container named `postgres`:
    * Check this by running `docker ps`. You should see the `postgres` container listed as running and healthy.

## Execution steps
1. Open a terminal window 
2. Create a new directory for the ETL script execution, e.g.:
   * `mkdir etl_chulmm`
   * `cd etl_chulmm`
2. Download the installation script:
    * `curl -L https://raw.githubusercontent.com/solventrix/Athena-setup/master/RunETLCHULMM/runETL.sh --output runETL.sh && chmod +x runETL.sh`
3. Execute the `runETL.sh` script by running `./runETL.sh` from inside the directory where the script is located.
4. The script will request for:
    * the path to the folder that contains the input CSV data file
    * the username and password to connect to the OMOP CDM database (a running Docker container named `postgres`)
    * the tag name for the Docker Hub image. Unless instructed otherwise, the default 'current' tag is required.
    * the verbosity level [DEBUG, INFO, WARNING, ERROR]
    * the date of last export in the following format (double quotes included): "yyyy-mm-dd"
5. The script will run the ETL code and show the output of the code
6. The `etl_<datetime>.log` log file will be available in the `log` folder
7. Review the log file to verify that there is no patient-level information.
