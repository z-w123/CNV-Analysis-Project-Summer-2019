#!/usr/bin/bash
#quick script to intersect all BEDtools_overlaps_known_genes.csv files (i.e putative CNVs) with gnomad information

#Remember, to use BEDtools all files have to be in BED format! So convert the csv to BED first using other script, then use this
PUTATIVE_VAR_FILES=`ls /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/test_samples_putative_variants_overlap_gnomad/*.csv_BEDtoolsoverlaps_known_genes.bed`
GNOMAD_SV_SITES_FILE="/homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/condensed_gnomad_v2_sv.sites.bed"
#note that out gnomad SV sites file is the shortened one, so it won't show intronic variants etc etc etc 

#add header to output file!
#do this in the terminal first to create the header file
#head -n 1 /homes/homedirs34/sghms/student/users/p1806425/test_MO43_MO65_CNV/condensed_gnomad_v2_sv.sites.bed > header.csv
#then manually changed header.csv into header.txt, whilst adding the following columns #CHROM #START #STOP #GENE [to denote the part of the file that is from the patient - i.e from BEDtools_overlaps_known_genes.csv]

echo $PUTATIVE_VAR_FILES

for file in $PUTATIVE_VAR_FILES; do

	cat header.txt > ${file}.csv
	/homes/athosnew/Genetics_Centre_Bioinformatics/resourses/bedtools2/bin/intersectBed -a $file -b $GNOMAD_SV_SITES_FILE -wa -wb >> ${file}.csv
	
	perl -p -i -e 's/\t/,/g' ${file}.csv
	
	mv ${file}.csv `basename $file .csv_BEDtoolsoverlaps_known_genes.bed`.putative_var_overlap_gnomad.csv;
	
done

	

