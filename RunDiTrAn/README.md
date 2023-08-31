# DiTrAn data preparation pipeline script for ATHENA UC

## Context

Components of the pipeline:
* Event generator
* Analysis table generator
* DiTrAn data preparation 

The pipeline will create an episode table based on predefined events and a second episode table based on derived events in OMOP CDM.  2 analysis tables are then generated based on the prefined, resp. derived events.  The 2 analysis tables are combined in 1 adding a column 'event_type' to distinguish the 'predefined' and 'derived' events.  Finally, the DiTrAn data prepration script is executed on the combined analysis table.  

## Running the script
To run the data preparation script for DiTrAn, please download and run the following script.
###  1. Download the script
```
curl -fsSL https://raw.githubusercontent.com/solventrix/Athena-Setup/master/RunDiTrAn/prepareDiTrAnData_UZL_UC.sh --output prepareDiTrAnData_UZL_UC.sh && chmod +x prepareDiTrAnData_UZL_UC.sh
```
###  2. Run the script
```
./prepareDiTrAnData_UZL_UC.sh
```
