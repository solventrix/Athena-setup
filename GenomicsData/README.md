# Load genomics data for ATHENA UC

## Context
The script will load genomics test data in the OMOP CDM measurements table and will assign a random person per test file 

## Running the script
To load the data, please download and run the following script.
###  1. Download the script
```
curl -fsSL https://raw.githubusercontent.com/solventrix/Athena-Setup/master/GenomicsData/loadGenomicsData.sh --output loadGenomicsData.sh && chmod +x loadGenomicsData.sh
```
###  2. Run the script
```
./loadGenomicsData.sh
```
