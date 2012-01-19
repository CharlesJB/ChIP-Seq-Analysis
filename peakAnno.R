library(ChIPpeakAnno)
library(org.Hs.eg.db)
data(TSS.human.NCBI36)

# Load and convert file to RangedData
BED<-read.table("IRF3d1.infected_peaks.bed",header=FALSE,sep="\t")
BED_CTRL<-read.table("../IRF3d1_nonInfected/IRF3d1.nonInfected_peaks.bed",header=FALSE,sep="\t")
SequencesRD <- BED2RangedData(BED, header=FALSE)
SequencesCTRL <- BED2RangedData(BED_CTRL, header=FALSE)

# Annotate and save to file
annotatedPeak = annotatePeakInBatch(SequencesRD, AnnotationData=TSS.human.NCBI36)
IDs_df <- as.data.frame(addGeneIDs(annotatedPeak, "org.Hs.eg.db", IDs2Add=c("symbol", "genename", "refseq")))
toSave <- IDs_df[,c('space', 'start', 'end', 'width', 'strand', 'feature', 'start_position', 'end_position', 'insideFeature', 'distancetoFeature', 'shortestDistance', 'fromOverlappingOrNearest', 'symbol', 'refseq', 'genename')]
annotatedPeakCTLR = annotatePeakInBatch(SequencesCTRL, AnnotationData=TSS.human.NCBI36)
write.table(toSave, file="IRF3d1_infected_GeneIDs.txt", row.names=FALSE, quote=FALSE, sep="\t")

ctrlIDs_df <- as.data.frame(addGeneIDs(annotatedPeakCTLR, "org.Hs.eg.db", IDs2Add=c("symbol", "genename", "refseq")))
toSaveCtrl <- ctrlIDs_df[,c('space', 'start', 'end', 'width', 'strand', 'feature', 'start_position', 'end_position', 'insideFeature', 'distancetoFeature', 'shortestDistance', 'fromOverlappingOrNearest', 'symbol', 'refseq', 'genename')]
write.table(toSaveCtrl, file="../IRF3d1_nonInfected/IRF3d1_nonInfected_GeneIDs.txt", row.names=FALSE, quote=FALSE, sep="\t")

# Find values unique to annotatedPeak
annoUnique <- annotatedPeak[annotatedPeak$feature %in% setdiff(annotatedPeak$feature, annotatedPeakCTLR$feature),]

uniqueIDs_df <- as.data.frame(addGeneIDs(annoUnique, "org.Hs.eg.db", IDs2Add=c("symbol", "genename", "refseq")))
toSaveUnique <- uniqueIDs_df[,c('space', 'start', 'end', 'width', 'strand', 'feature', 'start_position', 'end_position', 'insideFeature', 'distancetoFeature', 'shortestDistance', 'fromOverlappingOrNearest', 'symbol', 'refseq', 'genename')]
write.table(toSaveUnique, file="IRF3d1_unique_GeneIDs.txt", row.names=FALSE, quote=FALSE, sep="\t")
