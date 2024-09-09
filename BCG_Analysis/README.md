# Extend analysis table and DiTrAn with BCG data for ATHENA UC

## Context
The script will create an analysis table for BCG treatments in the results schema of the local OMOP database,
extend the existing analysis table (results.analysis_table_uc) and prepare the data for DiTrAn

## Running the script
To add BCG data to DiTrAn, please download and run the following script.
###  1. Download the script
```
curl -fsSL https://raw.githubusercontent.com/solventrix/Athena-Setup/master/BCG_Analysis/updateDiTrAnWithBCG.sh --output updateDiTrAnWithBCG.sh && chmod +x updateDiTrAnWithBCG.sh
```
###  2. Run the script
```
./updateDiTrAnWithBCG.sh
```


# Create BCG analysis table for ATHENA UC

## Context
The script will create an analysis table for BCG treatments in the results schema of the local OMOP database

## Running the script
To create the analysis table, please download and run the following script.
###  1. Download the script
```
curl -fsSL https://raw.githubusercontent.com/solventrix/Athena-Setup/master/BCG_Analysis/createBCGAnalysisTable.sh --output createBCGAnalysisTable.sh && chmod +x createBCGAnalysisTable.sh
```
###  2. Run the script
```
./createBCGAnalysisTable.sh
```
