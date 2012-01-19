#!/bin/bash

# $1 Case summary file obtained with generateSummary.sh
# $2 Control summary file obtained with generateSummary.sh

# This script will print out, one after the other, peaks unique to case file,
# peaks overlapping case file and control file and peaks unique to control file.

if [ ! $# -eq 2 ]; then
	echo Invalid number of arguments
else
	if [ -a $1 ]; then
		if [ -a $2 ]; then
			echo Peaks unique to case file
			head -n 1 $1
			comm -2 -3 $1 $2

			echo Peaks overlapping case and control files
			head -n 1 $1
			comm -1 -2 $1 $2

			echo Peaks unique to control file
			head -n 1 $2
			comm -1 -3 $1 $2
		else
			echo Invalid file name $2
		fi
	else
		echo Invalid file name $1
        fi
fi
