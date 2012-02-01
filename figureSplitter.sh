#!/bin/bash

# $1 file name

if [ ! $# -eq 2 ]; then
        # echo Invalid number of arguments
        echo 'Usage:'
        echo 'figureSplitter.sh <file1> <prefix>'
        echo 'file1: file to split for figure'
	echo 'prefix: prefix for the file that will be produced'
else
        if [ -a $1 ]; then
		cat $1 | awk 'NR >= 1 && NR <= 25 { print }' > "${$2}_p1.txt"
		cat $1 | awk 'NR >= 26 && NR <= 82 { print }' > "${$2}_p2.txt"
		cat $1 | awk 'NR >= 83 && NR <= 139 { print }' > "${$2}_p3.txt"
		cat $1 | awk 'NR >= 140 && NR <= 196 { print }' > "${$2}_p4.txt"
		cat $1 | awk 'NR >= 197 && NR <= 255 { print }' > "${$2}_p5.txt"
		cat $1 | awk 'NR >= 254 && NR <= 310 { print }' > "${$2}_p6.txt"
		cat $1 | awk 'NR >= 311 && NR <= 367 { print }' > "${$2}_p7.txt"
		cat $1 | awk 'NR >= 368 && NR <= 424 { print }' > "${$2}_p8.txt"
		cat $1 | awk 'NR >= 425 && NR <= 481 { print }' > "${$2}_p9.txt"
		cat $1 | awk 'NR >= 482 && NR <= 548 { print }' > "${$2}_p10.txt"
		cat $1 | awk 'NR >= 539 && NR <= 595 { print }' > "${$2}_p11.txt"
        else   
                echo Invalid file name $1
        fi
fi
