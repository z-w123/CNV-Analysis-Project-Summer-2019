# CNV Analysis Project Summer 2019

### This repository contains scripts that form a Copy Number Variant (CNV) Analysis Pipeline, to:  
1. call CNVs from exome data  
2. identify CNVs within a gene panel  
3. annotate called CNVs in this panel using population frequency data from the gnomAD population (for annotation the 'gnomAD SV sites VCF' file was used: https://gnomad.broadinstitute.org/downloads)


**see schematic of pipeline below:**

![](images/CNV-analysis-stage-1.png)
![](images/CNV-analysis-stage-2.png)
![](images/CNV-analysis-stage-3.png)

##### The scripts for this project were applied to Monogenic Early Onset Obesity patients, but the overall pipeline can be applied to any small scale rare disease cohort


## SNV Analysis
A script to extract SNVs from specific genes of a panel (in this case, 22 green/high evidence genes from the Severe Early Onset Obesity gene panel from the Genomics England PanelApp database) can be found in the SNV analysis folder
