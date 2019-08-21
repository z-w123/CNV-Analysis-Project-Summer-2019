#!/usr/bin/bash

#to convert ExomeDepth output .csv into .bed file(aka a tab delimited file)
# we have set an arguement below (see fileDir line 19). So to run this script in linux you have to do: sh <path to this script> <path to directory where ExomeDepth csv files are located>

#eg: cat Exome_1_test_csv.csv | tr ',' '\t' > Exome_1_test.txt

#to remove columns from a file use awk:
#just print the columns you want to keep from the #file and then output it to a new file name. Keep this order of numbers to get the columns in the right order
#eg: awk '{print $8,$7,$5,$6}' Exome_1_test.txt > Exome_1_test.bed 
#$5 = CNV start pos column
#$6 = CNV end pos col
#$7 = Chrom number col
#$8 = CNV id col



CSV_FILES=`ls /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples/`  #modify this according to where your ExomeDepth output CSV files are
fileDir=$1 #creating arguements now, so that you can just modify some paramters of the script as you please :)
#the original fileDir was: "/homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples/"


echo $fileDir

echo $CSV_FILES

for csv in $CSV_FILES; do

	cat ${fileDir}/$csv | tr ',' '\t' > ${fileDir}/${csv}_tmp
	awk '{print $7,$5,$6,$8}' ${fileDir}/${csv}_tmp > ${fileDir}/${csv}_tmp2
	sed 's/"//g' ${fileDir}${csv}_tmp2 > ${fileDir}/${csv}_tmp3      #removing "" from data
	sed 1d ${fileDir}/${csv}_tmp3 > ${fileDir}${csv}_tmp4             #removing header of columns
	sed 's/ /\t/g' ${fileDir}${csv}_tmp4 > ${fileDir}${csv}_tmp4       #<- to replace tabs with spaces
	
	mv ${fileDir}${csv}_tmp4 `basename $fileDir$csv .csv_tmp4`.bed;   #<- the new bed files now have the extension: .csv.bed
	
done

rm /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples/*_tmp*



	

