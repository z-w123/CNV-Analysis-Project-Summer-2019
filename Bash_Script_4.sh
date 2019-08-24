#!/usr/bin/bash

GENELIST_BED="Biomart_Genes_Exons_List_Obesity.bed"   
SAMPLECNVS_BED=`ls /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples/*.csv.bed`  
echo $SAMPLECNVS_BED

#mkdir /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples/test_extra_samples_BEDtools

#with the BEDtools intersect function, if you get an empty excel file output, it is because there is simply no overlap between the two files.

for sample in $SAMPLECNVS_BED; do


	/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $sample -b $GENELIST_BED -wa -wb > ${sample}_tmp
	
	head ${sample}_tmp
	
	awk '{print $1,$2,$3,$8}' ${sample}_tmp > ${sample}_tmp2	#to extract sample CNV start pos, end pos and gene name 
	
	
	mv ${sample}_tmp2 `basename $sample .csv.bed`_BEDtoolsoverlaps_known_genes.csv;
	
	mv ${sample}_BEDtoolsoverlaps_known_genes.csv /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/test_extra_samples_BEDtools

done


#if you want to display which part of the exome csv bed file overlapped with which part of the candidate gene list. Outputs the genes from gene list too:
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $SAMPLECNVS_BED -b $GENELIST_BED -wa -wb | head -5
#doing the above with only the -wo argument displays the number of base pairs in the overlap


#We can also count, for each feature in the “A” file, the number of overlapping features in the “B” file. This is handled with the -c option. EG: bedtools intersect -a cpg.bed -b exons.bed -c | head
#So if we want to see how many CNVs identified in the patient overlap with each gene in gene panel, could switch around file A and B (try both ways)
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $SAMPLECNVS_BED -b $GENELIST_BED -c
																		#or
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $GENELIST_BED -b $SAMPLECNVS_BED -c
