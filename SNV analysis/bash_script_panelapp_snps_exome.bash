#!/usr/bin/bash

#trying to write a loop to see if the annotated exome files of the patients have any sequence variants in the known panel App genes (we haven't included Dr W's suggestions of genes yet tho)

GENE_LIST="ALMS1 ARL6 BBS1 BBS10 BBS12 BBS2 BBS4 BBS5 BBS7 BBS9 LEP LEPR MC4R MKKS MKS1 MYT1L PCSK1 PHF6 POMC SDCCAG8 TTC8 VPS13B"
SAMPLES=`ls /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/annotated_test_sample_exomes/*.hg19_multianno.txt`

head -n 1 /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/annotated_test_sample_exomes/MO43.annovar.hg19_multianno.txt > header.txt
echo This is what the file header looks like: 
echo "$(cat header.txt)"
#above line uses a single file to extract just the header (assuming header is the same for every annotated exome file) and save it as a csv

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

#for fx in *.jpeg; do mv $fx `basename $fx .jpeg`.jpg; done
#cat MO43_snps_panelapp_genes_tmp >> header.txt  joins the header ontop of the csv file.

#mv ${sample}_tmp `basename $sample .hg19_multianno.txt`.annot_snps_panelappp_genes.csv;
#cat ${sample}.txt >> header.txt #nooo this will join all samples to one file!
