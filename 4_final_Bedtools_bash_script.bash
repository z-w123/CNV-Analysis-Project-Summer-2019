#!/usr/bin/bash

GENELIST_BED="Biomart_Genes_Exons_List_Obesity.bed"   #desired virtual panel list in bed format - do not need to set filepath if u r already in working directory
SAMPLECNVS_BED=`ls /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples/*.csv.bed`  
echo $SAMPLECNVS_BED

#mkdir /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples/test_extra_samples_BEDtools


#now bedtools command:
#remember if you get an empty excel file output, it is bc there is simply no overlap between the two files. csv->BED script has been tested and should be correct.
#can also try the perl command  perl -p -i -e 's/ /\t/g'  bed_file.txt  on the GENELIST_BED file 
for sample in $SAMPLECNVS_BED; do


	/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $sample -b $GENELIST_BED -wa -wb > ${sample}_tmp
	
	head ${sample}_tmp
	
	awk '{print $1,$2,$3,$8}' ${sample}_tmp > ${sample}_tmp2	#should extract sample CNV start pos, end pos and gene name & save it as the name of that sample file in csv form (i.e w/o .bed extension)    
	
	
	mv ${sample}_tmp2 `basename $sample .csv.bed`_BEDtoolsoverlaps_known_genes.csv;
	
	mv ${sample}_BEDtoolsoverlaps_known_genes.csv /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/test_extra_samples_BEDtools

done

#find . -name '*_BEDtoolsoverlaps_known_genes.csv' -type f -empty -delete                     #need to remove empty files 
#when I extract columns I might not see the header of each column - is it poss to code this back in? 

#if you want to display which part of the exome csv bed file overlapped with which part of the candidate gene list. Outputs the genes from gene list too:
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $SAMPLECNVS_BED -b $GENELIST_BED -wa -wb | head -5
#doing the above with only the -wo argument displays the number of base pairs in the overlap


#We can also count, for each feature in the “A” file, the number of overlapping features in the “B” file. This is handled with the -c option. EG: bedtools intersect -a cpg.bed -b exons.bed -c | head
#So if we want to see how many CNVs identified in the patient overlap with each gene in gene panel, could switch around file A and B (try both ways)
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $SAMPLECNVS_BED -b $GENELIST_BED -c
																		#or
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $GENELIST_BED -b $SAMPLECNVS_BED -c
#mv ${sample}_tmp2 ${sample}_BEDtoolsoverlaps_known_genes.csv