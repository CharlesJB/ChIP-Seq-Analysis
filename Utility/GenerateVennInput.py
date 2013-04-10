#!/usr/bin/python
# encoding: utf-8
# author: Charles Joly Beauparlant
# 2013-04-10

"""
This script will generate an input file to produce venn diagrams (with limma and gplots)

Usage: GenerateVennInput.py <filename1> ... <filenameN>
	filenames: The files that will be used to procude the input file
"""

import sys

if __name__ == "__main__":
	if len(sys.argv) == 1:
		print __doc__
		sys.exit(1)

# Fetch the filenames
filenames = []
fileCount = int(len(sys.argv)-1)
for i in range(0, fileCount):
	filenames.append(sys.argv[i+1])

# Parse the files
status = {}
index = -0
for filename in filenames:
	for line in open(filename):
		name = line.strip()
		if name not in status:
			newArray = [0] * fileCount	
			status[name] = newArray
		status[name][index] = 1
	index += 1

# Print header
header = ""
for i in range(0, fileCount):
	header += filenames[i]
	if i != fileCount - 1:
		header += "\t"
print header

# Print status for all genes
for name in status:
	line = ""
	for i in range(0, fileCount):
		line += str(status[name][i])
		if i != fileCount - 1:
			line += "\t"
	print line
