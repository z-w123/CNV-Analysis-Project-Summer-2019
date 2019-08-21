#remember to change ExomeCount to my.counts()

#Install bioconductor core packages (bc of ExomeDepth dependencies)
source("https://bioconductor.org/biocLite.R")
#Install ExomeDepth
BiocInstaller::biocLite(c("ExomeDepth"))
#if it does not download change the version of R (i.e use R 3.4.3)

#loading the libraries
library(ExomeDepth)
library("GenomeInfoDb") #why do we load this?
library("Rsamtools")  #why do we load this?

#set your working directory
##########WARNING! To run this script you have to be OUTSIDE of the setwd() directory you set below. 
##########This is because the list.files() below automatically lists everything in your working directory, thus you MUST be OUTSIDE of this working directory when you run the script
##########Otherwise the system fails to recognise any BAM files to parse

setwd("/homes/athosnew/Genetics_Centre_Bioinformatics/CNV_calling_zahra/test_extra_samples") #need to stick in at the end your directory (see $toDir in assoc. bash script)


#get your list of bam files ready
library(tools)
list_of_bam_files <- c((file_path_sans_ext(list.files(pattern = "*.bam", all.files = TRUE))))

message("BAM files are:")
list_of_bam_files

#displaying exon positions of the hg19 human genome by opening exons.hg19 dataframe
message('displaying exon positions of the hg19 human genome')

data(exons.hg19)
print(head(exons.hg19))

#generating counts of our list of BAM files
my.counts <- getBamCounts(bed.frame = exons.hg19, bam.files = c(list.files(pattern = "*.bam")), include.chr = FALSE)
              #don't need to include reference = fasta bit here because our reference is an aggregate of other samples. We'll set this later
              #include.chr = FALSE if the reference genome that BAMs are aligned to uses chromosome naming convention of chr1 instead of 1
#can also have all the code running on one line

#check the counting worked:
print(head(my.counts))


#making a dataframe of the read count data
library(ExomeDepth)

my_counts.dafr <- as(my.counts[, colnames(my.counts)], 'data.frame') #is it my.counts??

#now making a second dataframe, where in the second one we are changing only the chromosome column (to get rid of chr and put ' ' there)
my_counts.dafr$chromosome <- gsub(as.character(my_counts.dafr$space),
                                   pattern = 'chr',
                                   replacement = '')
print(head(my_counts.dafr))


#Now going to convert our read count dataframe into a read count matrix. Not always necessary, but because you can do different things with dataframes and matrices, best to change it to matrix. Also avoids errors later on.
#code below means to extract all the columns from our my.counts df of which are bam files, and we will convert that into a matrix
my_counts.mat <- as.matrix(my_counts.dafr[, grep(names(my_counts.dafr), 
                                                   pattern = '*.bam')])
                  #normally we would add a drop=FALSE if aggreg ref was made of one sample, but it's not.

#after printing the matrix you will see that 'matrixing' the dataframe in this way (i.e by grepping only .bam files) has removed unnecessary columns :)
print(my_counts.mat)


#Now that we've got a distilled down matrix, we can see that the number of columns we have = the number of samples we have. So let's create that variable:
nsamples <- ncol(my_counts.mat)
print(head(nsamples))


#now looping over each sample
message('Now looping over all the samples innit')

for(i in 1:nsamples) { #warning this is a very long loop!

    
#building the reference set
my.choice <- select.reference.set (test.counts = my_counts.mat[,i], reference.counts = my_counts.mat[,-i], bin.length = (my_counts.dafr$end - my_counts.dafr$start)/1000, n.bins.reduced = 10000)

#the point of the code below is to generate your reference set of data (from your sample/s)
#the code below selects a specific ExomeDepth inbuilt column found in the previous my.choice variable, this column is called 'reference.choice'.
#the apply() function outputs a list of values obtained after applying a specific function
#in this case, the function is summing our matrix of read count data, with the reference.choice column, row by row, to generate the reference set.
#we drop=FALSE because as this is part of a loop that will iterate over each sample, in every case, each reference set contains a single sample

my.reference.selected <- apply(X = my_counts.mat[, my.choice$reference.choice, drop = FALSE], 
                               MAR = 1, FUN = sum)

#creating the exomedepth dataframe (a mix of reference + test) from which you will later call CNVs
message('Now creating the ExomeDepth object')

all.exons <- new('ExomeDepth',
                 test = my_counts.mat[,i], 
                 reference = my.reference.selected, 
                 formula = 'cbind(test, reference) ~ 1')
          
#####Now call the CNVs!
all.exons <- CallCNVs(x = all.exons,
                      transition.probability = 10^-4,   #you can change this value if you want to but that won't drastically affect CNV calling because we have a failsafe: the base quality. We'll use base quality to get rid of poor CNVs anyway
                      chromosome = my_counts.dafr$chromosome,
                      start = my_counts.dafr$start,
                      end = my_counts.dafr$end,
                      name = my_counts.dafr$names)	


#conrad annotator in exome depth shows the positions of common CNV calls only. 
#What about rare ones?
#Can we use other annotators (even from other packages outside of ExomeDepth) that would be better?

#Lets add the annotation of common CNV dataset:
data(Conrad.hg19) #this is a df of commmon (+validated) CNV calls

#Then one can use this information to annotate our CNV calls with the function AnnotateExtra from GenomicRanges
#GenomicRanges is part of a different package= BioCManager. GenomicRanges defines general purpose containers for storing and manipulating genomic intervals and variables defined along a genome

#The CNVs must overlap by at least 50% to get annotated. (hence min.overlap= 0.5)

#AnnotateExtra (ExomeDepth) Takes annotations in the GRanges format and adds these to the CNV calls in the ExomeDepth object.
all.exons <- AnnotateExtra(x = all.exons, 
                           reference.annotation = Conrad.hg19.common.CNVs, 
                           min.overlap = 0.5, 
                           column.name = 'Conrad.hg19') #creates a new column in the all.exons df which stores overlap info
#cancheck it:
print(head(all.exons@CNV.calls))


#now annotating with exon/gene level information. #using genomicranges format

data(exons.hg19)

exons.hg19.GRanges <- GenomicRanges::GRanges(seqnames = exons.hg19$chromosome, 
                                             IRanges::IRanges(start=exons.hg19$start,end=exons.hg19$end), 
                                             names = exons.hg19$name)


#here the minimum overlap should be very close to 0  
all.exons <- AnnotateExtra(x = all.exons, 
                           reference.annotation = exons.hg19.GRanges, #annotated exons variable
                           min.overlap = 0.0001, 
                           column.name = 'exons.hg19')

#saving CNVs to file now
output.file <- paste('Exome_',    #used paste funciton to stitch a name of the file together for each sample
                     i, 
                     '_', 	
                     list_of_bam_files[i], 
                     '.csv', sep = '')

write.csv(file = output.file, 
          x = all.exons@CNV.calls, 
          row.names = FALSE)


} #loop closed

