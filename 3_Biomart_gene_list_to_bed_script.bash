#!/usr/bin/bash

#once you have virtual gene panel in a tsv file format from Biomart, you could:
# (a) ensure that for your GENELIST_BED file you have already used excel to manually remove the header and arrange your columns like so: Chrom, Start, Stop, Gene Name, . 
#or (b) do this in linux, like so: 

GENELIST_BED="Biomart_Genes_Exons_List_Obesity.bed"   #desired virtual panel list in bed format - do not need to set filepath if u r already in working directory
SAMPLECNVS_BED=`ls /homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_samples/*.csv.bed`  
echo $SAMPLECNVS_BED

cat $GENELIST_BED | tr ',' '\t' > ${GENELIST_BED}_tmp         #do I need to specify file directory here?
awk '{print $2,$3,$4,$1}' ${GENELIST_BED}_tmp > ${GENELIST_BED}_tmp2       #shuffling columns to satisfy BED format
sed 1d ${GENELIST_BED}_tmp2 > ${GENELIST_BED}_tmp3         #removing header
sed 's/ /\t/g' ${GENELIST_BED}_tmp3 > ${GENELIST_BED}_tmp4
mv ${GENELIST_BED}_tmp4 ${GENELIST_BED}                   # renaming to BED file

rm ${GENELIST_BED}_tmp 
rm ${GENELIST_BED}_tmp2 
rm ${GENELIST_BED}_tmp3  
rm ${GENELIST_BED}_tmp4
