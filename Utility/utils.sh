#!/bin/bash

exit_error(){
	filename=$1
	echo Error! File does not exists: $filename
}

check_file(){
	filename=$1
	if [ ! -e "$filename" ]
	then
		exit_error $filename
	fi
}
