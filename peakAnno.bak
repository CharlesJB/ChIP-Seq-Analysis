library(ChIPpeakAnno)
library(org.Hs.eg.db)
data(TSS.human.NCBI36)

argv <- commandArgs(trailingOnly = T)
#argv[1] Name of bed file to annotate
#argv[2] Name of file to save results

print("Starting peak annotation analysis...")

if (length(argv) == 2) {
	# Load and convert files to RangedData
	BED<-read.table(argv[1],header=FALSE,sep="\t")
	SequencesRD <- BED2RangedData(BED, header=FALSE)

	# Annotate and save to file
	print("Starting batch annotation...")
	annotatedPeak = annotatePeakInBatch(SequencesRD, AnnotationData=TSS.human.NCBI36)
	print("Adding gene IDs...")
	IDs_df <- as.data.frame(addGeneIDs(annotatedPeak, "org.Hs.eg.db", IDs2Add=c("symbol", "genename", "refseq")))
	print("Saving...")
	toSave <- IDs_df[,c('space', 'start', 'end', 'width', 'strand', 'feature', 'start_position', 'end_position', 'insideFeature', 'distancetoFeature', 'shortestDistance', 'fromOverlappingOrNearest', 'symbol', 'refseq', 'genename')]
	write.table(toSave, file=argv[2], row.names=FALSE, quote=FALSE, sep="\t")
} else {
	print("Incorrect number of arguments")
}
