#!/bin/bash

treatment=$1
control=$2
dir_output=$3
prefix=$(basename ${treatment%.*})

mkdir -p $dir_output

#output=peaks/$prefix/$prefix
output=$dir_output/$prefix

macs14 -t $treatment -c $control -f BAM -g hs -n $output
