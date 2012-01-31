#!/bin/bash

# $1 Case summary file obtained with generateSummary.sh
# $2 Control summary file obtained with generateSummary.sh

# This script will print out, one after the other, peaks unique to case file,
# peaks overlapping case file and control file and peaks unique to control file.

if [ ! $# -eq 2 ]; then
	# echo Invalid number of arguments
	echo 'Usage:'
	echo 'splitCaseCtrl.sh <file1> <file2>'
	echo 'file1: merged case file'
	echo 'file2: merged control file'
else
	if [ -a $1 ]; then
		if [ -a $2 ]; then
			# Sort files...
			tail -n +2 "$1" | sort > sort1.tmp
			tail -n +2 "$2" | sort > sort2.tmp

			# then split them
			# head -n 1 $1 > UniqueCase.tmp # Print header
			# comm -2 -3 sort1.tmp sort2.tmp >> UniqueCase.tmp
			splitCaseCtrl unique $1 $2 > UniqueCase.tmp

			# head -n 1 $1 > Overlap.tmp
			# comm -1 -2 sort1.tmp sort2.tmp >> Overlap.tmp
			splitCaseCtrl overlap $1 $2 > OverlapCase.tmp
			splitCaseCtrl overlap $2 $1 > OverlapControl.tmp

			# head -n 1 $2 > UniqueControl.tmp
			# comm -1 -3 sort1.tmp sort2.tmp >> UniqueControl.tmp
			splitCaseCtrl unique $2 $1 > UniqueControl.tmp

			# Split file another time between complete annotation and unknown
			head -n 1 UniqueCase.tmp > UniqueCase.txt
			tail -n +2 UniqueCase.tmp | grep -v ENSG............NA | sort >> UniqueCase.txt
			sed -i 's/;/; /g' UniqueCase.txt

			head -n 1 UniqueCase.tmp > UnknowCase.txt
			tail -n +2 UniqueCase.tmp | grep ENSG............NA | sort >> UnknowUniqueCase.txt
			sed -i 's/;/; /g' UnknowUniqueCase.txt

			head -n 1 OverlapCase.tmp > OverlapCase.txt
			tail -n +2 OverlapCase.tmp |  grep -v ENSG............NA | sort >> OverlapCase.txt
			sed -i 's/;/; /g' OverlapCase.txt

			head -n 1 OverlapCase.tmp > UnknowOverlapCase.txt
			tail -n +2 OverlapCase.tmp | grep ENSG............NA | sort >> UnknowOverlapCase.txt
			sed -i 's/;/; /g' UnknowOverlapCase.txt

			head -n 1 OverlapControl.tmp > OverlapControl.txt
			tail -n +2 OverlapControl.tmp | grep -v ENSG............NA | sort >> OverlapControl.txt
			sed -i 's/;/; /g' OverlapControl.txt

			head -n 1 OverlapControl.tmp > UnknowOverlapControl.txt
			tail -n +2 OverlapControl.tmp | grep ENSG............NA | sort >> UnknowOverlapControl.txt
			sed -i 's/;/; /g' UnknowOverlapControl.txt

			head -n 1 UniqueControl.tmp > UniqueControl.txt
			tail -n +2 UniqueControl.tmp | grep -v ENSG............NA | sort >> UniqueControl.txt
			sed -i 's/;/; /g' UniqueControl.txt

			head -n 1 UniqueControl.tmp > UnknowUniqueControl.txt
			tail -n +2 UniqueControl.tmp | grep ENSG............NA | sort >> UnknowUniqueControl.txt
			sed -i 's/;/; /g' UnknowUniqueControl.txt

			# Clean up
			rm *.tmp
		else
			echo Invalid file name $2
		fi
	else
		echo Invalid file name $1
        fi
fi
