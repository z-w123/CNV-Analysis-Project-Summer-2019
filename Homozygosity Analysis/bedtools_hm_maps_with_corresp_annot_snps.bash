#!/usr/bin/bash

#making a script to run through each HM_sample and intersect it with the CORRESPONDING annot.snps.exome file


#HOMOZYGOSITY_MAPS_CONSANG=`ls /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/Homozygosity_Mapper/ED_csv_bed_hm/*_analysis.bed`
#PANELAPP_PATIENT_SNPS=`ls /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/Homozygosity_Mapper/ED_csv_bed_hm/*_panelapp_genes.bed`

#add header to output file!
#just created the header file in excel for this one, with the following columns in this order: #CHROM, #STAR, #STOP, CHROM, START, STOP, ID [where # denotes data from the homozygosity maps] and saved as text file: header.txt

mySamples="MO46 MO47 MO49 MO55 MO58"

for sample in $mySamples; do

	cat header.txt > ${sample}_hm_overlap_panelapp_snps.csv

	/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a ${sample}_HM_analysis.bed -b ${sample}.annovar.annot_snps_panelapp_genes.bed -wa -wb >> ${sample}_hm_overlap_panelapp_snps.csv

	perl -p -i -e 's/\t/,/g' ${sample}_hm_overlap_panelapp_snps.csv
	
done


#for map in $HOMOZYGOSITY_MAPS_CONSANG; do

	#sample=${map%_HM_analysis.bed}

	#cat header.txt > ${map}.csv
		
	#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $map -b $sample.annovar.annot_snps_panelapp_genes.bed -wa -wb >> ${map}.csv
		
	#done
	
	#perl -p -i -e 's/\t/,/g' ${map}.csv
	
	#mv ${map}.csv `basename $map .bed`.overlap_exomedepth_calls.csv;
	
#done