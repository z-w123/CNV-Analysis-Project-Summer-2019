#!/usr/bin/bash

#A script to run through each homozygosity map (HM_sampleID) and intersect it with the CORRESPONDING annotated annovar file for that sample 

#below just shows path directory to: 1) homozygosity maps of consanguinous patients
#and 
#2) patient SNVs in monogenic obesity panelapp genes 

#HOMOZYGOSITY_MAPS_CONSANG=`ls /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/Homozygosity_Mapper/ED_csv_bed_hm/*_analysis.bed`
#PANELAPP_PATIENT_SNVS=`ls /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/Homozygosity_Mapper/ED_csv_bed_hm/*_panelapp_genes.bed`

#add header to output file!
#first created the header file in excel, with the following columns in this order: #CHROM, #STAR, #STOP, CHROM, START, STOP, ID [where # denotes data from the homozygosity maps] and saved as text file: header.txt

mySamples="MO46 MO47 MO49 MO55 MO58"

for sample in $mySamples; do

	cat header.txt > ${sample}_hm_overlap_panelapp_snps.csv

	/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a ${sample}_HM_analysis.bed -b ${sample}.annovar.annot_snps_panelapp_genes.bed -wa -wb >> ${sample}_hm_overlap_panelapp_snps.csv

	perl -p -i -e 's/\t/,/g' ${sample}_hm_overlap_panelapp_snps.csv
	
done

