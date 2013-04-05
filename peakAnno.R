library(ChIPpeakAnno)
library(org.Hs.eg.db)
data(TSS.human.NCBI36)

argv <- commandArgs(trailingOnly = T)
#argv[1] Name of bed file to annotate
#argv[2] Prefix to save results

print("Starting peak annotation analysis...")

if (length(argv) == 2) {
	# Load and convert files to RangedData
	BED<-read.table(argv[1],header=FALSE,sep="\t")
	SequencesRD <- BED2RangedData(BED, header=FALSE)

	# Annotate and save to file
	print("Starting batch annotation...")
	annotatedPeak = annotatePeakInBatch(SequencesRD, AnnotationData=TSS.human.NCBI36)
	print("Trying to produce figure...")
	y = annotatedPeak$distancetoFeature[!is.na(annotatedPeak$distancetoFeature) 
	& annotatedPeak$fromOverlappingOrNearest == "NearestStart"]
	tiff_name = paste (argv[2], "_hist.tiff", sep="")
	tiff(tiff_name)
#	hist(y, xlab="Distance To Nearest TSS", main="", breaks=1000, xlim=c(min(y)-100, max(y)+100)) 
	hist(y, xlab="Distance To Nearest TSS", main="", breaks=1000, xlim=c(-200000, 200000))
	dev.off()
	temp = as.data.frame(annotatedPeak) 
	y = annotatedPeak$distancetoFeature[!is.na(annotatedPeak$distancetoFeature) 
	& annotatedPeak$fromOverlappingOrNearest == "NearestStart" & 
	abs(annotatedPeak$distancetoFeature) <10000]
	tiff_name = paste (argv[2], "_pie.tiff", sep="")
	tiff(tiff_name)
	pie(table(temp[as.character(temp$fromOverlappingOrNearest) == "Overlapping" | 
	(as.character(temp$fromOverlappingOrNearest) == "NearestStart" & !temp$peak
	%in% temp[as.character(temp$fromOverlappingOrNearest) == "Overlapping", ]
	$peak) ,]$insideFeature))
	dev.off()
	print("Adding gene IDs...")
	IDs_df <- as.data.frame(addGeneIDs(annotatedPeak, "org.Hs.eg.db", IDs2Add=c("symbol", "genename", "refseq")))
	print("Saving...")
	save_name = paste(argv[2], "_ChipPeakAnno.out")
	toSave <- IDs_df[,c('space', 'start', 'end', 'width', 'strand', 'feature', 'start_position', 'end_position', 'insideFeature', 'distancetoFeature', 'shortestDistance', 'fromOverlappingOrNearest', 'symbol', 'refseq', 'genename')]
	write.table(toSave, file=save_name, row.names=FALSE, quote=FALSE, sep="\t")
} else {
	print("Incorrect number of arguments")
}
