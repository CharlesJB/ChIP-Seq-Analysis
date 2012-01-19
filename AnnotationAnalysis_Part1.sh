#!/bin/bash

# $1 Fichier bed obtenu apres l'etape de peak calling avec macs
# $2 basename pour les fichiers produits par le script

if [ ! $# -eq 2 ]; then
	echo Invalid number of arguments
else
	if [ -a $1 ]; then
		fileName=$1
		basename=$2

		# Annotate file
		annoFileName="${basename}_annotationAnalysis.txt"
		Rscript peakAnno.R $fileName $annoFileName

		# Generate a summary file
		summaryFileName="${basename}_annotationSummary"
		macsBaseName=${fileName%.bed}
		xlsMacs="${macsBaseName}.xls"
		generateSummary.sh $annoFileName $xlsMacs > summaryFileName

		# Generate list of ESNG that ChIPpeakAnno could not annotate
		extractFileName="${basename}_NAs.txt"
		extractNAs.sh "${basename}_annotationSummary" > extractFileName
	else
		echo Invalid file name $1
	fi
fi
