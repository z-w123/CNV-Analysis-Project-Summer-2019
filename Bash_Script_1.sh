#!/usr/bin/bash

#moving all sample .bam and .bai files into my specific directory

#need to make a new directory in CNV_calling_zahra every time this script is run

mkdir /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples

inDir="/homes/athosnew/Genetics_Centre_Bioinformatics/Exomes/Aligned/*/*" #where our bams are innit ; #everything within everything
toDir="/homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples" #change this final phrase according to desired directory name but this MUST be the same in assoc R script

#list of sample IDs 
mySamples="MO50
MO55
MO56
MO58
MO61
MO63
MO65
"


for sample in $mySamples; do

	cp $inDir/${sample}_sorted_unique_recalibrated.* $toDir
	
	
done

#run R script
cd $toDir
Rscript ../Final_2_ExomeDepth_script.R

#remove the bam and bai files
#rm loop
for sample in $mySamples; do

	rm $toDir/${sample}_sorted_unique_recalibrated.*
	
done

exit
 
