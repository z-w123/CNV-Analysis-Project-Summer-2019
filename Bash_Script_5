#!/usr/bin/bash
#script to intersect all patient csv.bed files with the structural variant dataset from gnomAD, and put the output into a new directory

#--------------
#first I condensed the gnomAD SV dataset to keep certain columns of interest and remove others (eg the code below removes data on intronic and complex SVs, etc)
#However you may have to maually add column numbers to this gnomAD data file in excel first

#cut -f1,2,3,4,5,7,16,17,18,19,20,21,22,25,28,29,31,32,33,34,35,36,37,38,39,80,81,82,83,84,85,86,87,88,89  gnomad_v2_sv.sites.bed > condensed_gnomad_v2_sv.sites.bed
#for information on which columns were removed from the gnomAD dataset for this analysis, and which columns were retained, see 'gnomAD column headings' word document
#--------------

#loop to intersect each patient CNV data file (csv.bed files) with the newly condensed gnomad SV data file, save these to new files and move them to a new directory


mkdir test_samples_BEDtools_gnomad_SV

SAMPLECNVS_BED=`ls /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/*.csv.bed`
GENELIST_BED="/homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/condensed_gnomad_v2_sv.sites.bed" 

for sample in $SAMPLECNVS_BED; do
/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $sample -b $GENELIST_BED -wa -wb > ${sample}_tmp
	
	echo "Output after overlapping with" 
	echo $sample 
	head ${sample}_tmp
	
	perl -p -i -e 's/\t/,/g' ${sample}_tmp    #added this in recently. Ensures you can actually open the file in excel and it's organised nicely into columns
	  
	mv ${sample}_tmp ${sample}_BEDtoolsoverlaps_gnomad_v2_sv.csv
	
	
	mv ${sample}_BEDtoolsoverlaps_gnomad_v2_sv.csv /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/test_samples_BEDtools_gnomad_SV
	

done



#--------------------BEDtools intersect commands												
#if you want to display which part of the exome csv bed file overlapped with which part of the candidate gene list. Outputs the genes from gene list too:
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $SAMPLECNVS_BED -b $GENELIST_BED -wa -wb | head -5
#We can also count, for each feature in the “A” file, the number of overlapping features in the “B” file. This is handled with the -c option. EG: bedtools intersect -a cpg.bed -b exons.bed -c | head
#So if we want to see how many CNVs identified in the patient overlap with each gene in gene panel, could switch around file A and B (try both ways)														
#/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $GENELIST_BED -b $SAMPLECNVS_BED -c
