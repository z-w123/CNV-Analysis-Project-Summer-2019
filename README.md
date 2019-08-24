# CNV Analysis Project Summer 2019

### This repository contains scripts that form a CNV Analysis Pipeline which enables:  
1. CNV calling from exome data  
2. allows identification of CNVs within a gene panel  
3. annotates called CNVs in this panel using population frequency data from the gnomAD population (the gnomAD SV sites VCF file was used for annotation: https://gnomad.broadinstitute.org/downloads)


**see schematic of pipeline below:**

* ![](images/CNV-analysis-stage-1.png)
* ![](images/CNV-analysis-stage-2.png)
* ![](images/CNV-analysis-stage-3.png)

##### The scripts for this project were applied to Monogenic Early Onset Obesity patients, but the overall pipeline can be applied to any small scale rare disease cohort


###### Abbreviations
CNV= Copy Number Variant  
SNV= Single Nucleotide Variant  



A script to extract SNVs from specific genes of a panel (in this case, 22 green/high evidence genes from the Severe Early Onset Obesity gene panel from the Genomics England PanelApp database) can be found in the SNV analysis folder
