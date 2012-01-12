#!/usr/bin/env python

import sys

def findTrimLength(sequence):
	target = 4;
	accumulated = 0
	i = 0
	while i < len(sequence):
		if sequence[i] == "N":
			accumulated+=1
		else:
			 accumulated = 0
		if accumulated == target:
			return i - target + 1
		i+=1
	return len(sequence)

def processSequence(seqIdentifier, sequence, quality):
	print seqIdentifier
	length = findTrimLength(sequence)
	print sequence[0:length]
	print "+"
	print quality[0:length]

arguments = sys.argv
if len(arguments) != 2:
	print "Incorrect number of arguments."

inputfile = arguments[1]
linenumber = 0

seqIdentifier = ""
sequence = ""

for line in open(inputfile) :
	if linenumber == 0 :
		seqIdentifier = line.strip()
	elif linenumber == 1 :
		sequence = line.strip()
	elif linenumber == 3 :
		quality = line.strip()
		processSequence(seqIdentifier, sequence, quality)
		
	linenumber+=1

	if linenumber==4:
		linenumber=0
