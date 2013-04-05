#!/bin/bash

# input: 2 merged files, 1 for case and one for control.

if [ ! $# -eq 2 ]; then
        echo 'Usage:'
        echo 'AnnotationAnalysis_Part2.sh <file1> <file2>'
        echo 'file1: merged case file'
        echo 'file2: merged control file'
else   
        if [ -a $1 ]; then
                if [ -a $2 ]; then
 			# Split the files
			mkdir splittedFiles			
			cd splittedFiles
			splitCaseCtrl.sh ../$1 ../$2
			formatOverlapFile OverlapCase.txt OverlapControl.txt > OverlapFormated.txt
			cd ..

			# Calculate statistics
			# TODO
			# mkdir statistics

			# Convert files for wiki
			# TODO
			# mkdir wiki
			
			# Extract data for figures
			mkdir figures
			cd figures

			grep ENSG ../splittedFiles/UniqueCase.txt | cut -f4,5 | grep -v NA > caseGeneList_short.txt
			grep ENSG ../splittedFiles/UniqueCase.txt | cut -f4-6 > caseGeneList_long.txt
			grep ENSG ../splittedFiles/UniqueControl.txt | cut -f4,5 | grep -v NA > controlGeneList_short.txt
			grep ENSG ../splittedFiles/UniqueControl.txt | cut -f4-6 > controlGeneList_long.txt
			grep ENSG ../splittedFiles/OverlapFormated.txt | cut -f4,5 | grep -v NA | uniq > controlGeneList_short.txt
			grep ENSG ../splittedFiles/OverlapFormated.txt | cut -f4-6 | uniq > controlGeneList_long.txt

						
		else
			echo Invalid file name $2
		fi
	else
		echo Invalid file name $1
        fi
fi
