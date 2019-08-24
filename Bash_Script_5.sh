#!/usr/bin/bash

#converting putative variant files (i.e BEDtools_overlap_known_genes.csv) to BED files so that we can later use BEDtools intersect to overlap them w/ gnomad data

CSV_FILES=`ls /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/test_samples_BEDtools/*.csv.bed_BEDtoolsoverlaps_known_genes.csv` 
fileDir="/homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/test_samples_BEDtools"    



echo $CSV_FILES

for csv in $CSV_FILES; do

	cat $csv | tr ',' '\t' > ${csv}_tmp
	#awk '{print $7,$5,$6,$8}' ${fileDir}/${csv}_tmp > ${fileDir}/${csv}_tmp2  #our putative variant files already have required columns, so nothing to awk
	#sed 's/"//g' ${fileDir}${csv}_tmp2 > ${fileDir}/${csv}_tmp3      #don't need to remove "" from chrm colmn bc we already did that previously
	#sed 1d ${fileDir}/${csv}_tmp3 > ${fileDir}${csv}_tmp4             #don't need to remove header of columns either
	sed 's/ /\t/g' ${csv}_tmp > ${csv}_tmp2       #<- to replace spaces with tabs
	mv ${csv}_tmp2 `basename $csv .csv.bed_BEDtoolsoverlaps_known_genes.csv`.csv_BEDtoolsoverlaps_known_genes.bed;     

	#rm ${fileDir}/${csv}_tmp2  #shouldn't need to do this bc have changed the name already


done

