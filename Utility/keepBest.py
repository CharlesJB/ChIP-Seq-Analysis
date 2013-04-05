#!/usr/bin/python
# encoding: utf-8
# author: Charles Joly Beauparlant
# 2013-02-25

"""
Usage: keepBest.py <filename> <threshold>
	filename: The summary file containing merged results.
	threshold: The minimum number of tags in a sequence
"""

import sys

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print __doc__
		sys.exit(1)

filename=sys.argv[1]
threshold=float(sys.argv[2])
lineCount=0
for line in open(filename):
	if lineCount == 0:
		print line.strip()
	elif float(line.split()[3]) >= threshold:
		where = line.split()[1]
		distance = int(line.split()[2])
		if where == "inside" and distance < 500:
			print line.strip()
		elif distance >= -1000 and distance <= 0:
			print line.strip()
	lineCount += 1
