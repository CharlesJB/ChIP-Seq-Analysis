#!/bin/bash

if [ ! $# -eq 1 ]; then
	echo Invalid number of arguments
else
	if [ -a $1 ]; then
		grep NA $1 | cut -f1
	else
		echo Invalid file name
	fi
fi
