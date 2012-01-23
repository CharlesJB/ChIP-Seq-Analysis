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
		echo Launching annotation analysis...
		annoFileName="${basename}_annotationAnalysis.txt"
		Rscript ~/scripts/peakAnno.R $fileName $annoFileName # Note: Find another solution

		# Generate a summary file
		summaryFileName="${basename}_annotationSummary.txt"
		macsBaseName=${fileName%.bed}
		xlsMacs="${macsBaseName}.xls"
		echo Producing summary file: $summaryFileName
		generateSummary.sh $annoFileName $xlsMacs > $summaryFileName

		# Generate list of ESNG that ChIPpeakAnno could not annotate
		extractFileName="${basename}_NAs.txt"
		echo Saving unknown peak identification to: $extractFileName
		extractNAs.sh $summaryFileName > $extractFileName
	else
		echo Invalid file name $1
	fi
fi
