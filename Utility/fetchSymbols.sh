#!/bin/bash

summary_filename=$1

# Generate symbol list
symbolFilename=${summary_filename%_*}"_withSymbol.txt"
head -n1 $summary_filename > $symbolFilename
tail -n+2 $summary_filename | grep -v NA >> $symbolFilename
