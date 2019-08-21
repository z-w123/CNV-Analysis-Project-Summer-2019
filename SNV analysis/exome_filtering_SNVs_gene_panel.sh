#!/usr/bin/bash

#writing a loop to investigate whether annotated exome files of the patients have any sequence variants in known Monogenic Obesity genes
#####please note as of 22nd August 2019 the Severe Early Onset Obesity Panel of the Genomics England PanelApp Database has since been updated with additional genes

GENE_LIST="ALMS1 ARL6 BBS1 BBS10 BBS12 BBS2 BBS4 BBS5 BBS7 BBS9 LEP LEPR MC4R MKKS MKS1 MYT1L PCSK1 PHF6 POMC SDCCAG8 TTC8 VPS13B"
SAMPLES=`ls /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/annotated_test_sample_exomes/*.hg19_multianno.txt` #path to all annotated patient exomes


head -n 1 /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/annotated_test_sample_exomes/MO43.annovar.hg19_multianno.txt > header.txt
echo This is what the file header looks like: 
echo "$(cat header.txt)"
#above line extracts the header from a single annotated exome file (assuming header is the same for every annotated exome file) and save it as a csv

#the loop below obtains exome data for all genes specified in the GENE_LIST variable above, for each patient, and then appends this data to a txt file containing the header columns of the annovar annotated exome file

for sample in $SAMPLES; do

	cat header.txt > ${sample}.txt 

		for gene in $GENE_LIST; do
	
		egrep -w --color $gene $sample >> ${sample}.txt

		
	done
	
	mv ${sample}.txt `basename $sample .hg19_multianno.txt`.annot_snps_panelapp_genes.txt;

done





#grep -w "ARL6" filename 
#quotation marks around name mean specific string only 

#egrep -w --color 'ARL6|BBS10|KRAS' filename
#egrep alows you to grep more than one string, -w means words

#head - n 1 filename extracts column headings

#cat MO43_snps_panelapp_genes_tmp >> header.txt  joins the header ontop of the csv file.

