#!/usr/bin/python
# encoding: utf-8
# author: Charles Joly Beauparlant
# 2013-04-05

"""
This script splits gene symbols from multiple files for Venn diagram

Usage:
./splitSymbolVenn.py <outputDir> <inputFile1> ... <inputFileN> 
	outputDir: Where to save the results.
	inputFiles: List of file to analyse
"""

class VennParser:
	def __init__(self, filenames, outputDir):
		self.m_fileCount = len(filenames)
		self.m_fileList = filenames
#		self._parseInputFile(inputFile)
		self.m_outputDir = outputDir
		self.m_symbolList = {}

	def parseFiles(self):
		for filename in self.m_fileList:
			self._parseFile(filename)

	def printSummary(self):
		if len(self.m_fileList) > self.m_fileCount - 1:
			for symbol in self.m_symbolList:
				outputFilename = self._convertColorValueToFilename(self.m_symbolList[symbol])
				with open(outputFilename, "a") as myfile:
					myfile.write(symbol + "\n")

	def _parseFile(self, filename):
		currentFilenameColorValue = self._convertFilenameToColorValue(filename)
		for line in open(filename):
			symbol = line.strip()
			self._addSymbol(symbol, currentFilenameColorValue)

	def _addSymbol(self, symbol, colorValue):
#		print "symbol: " + symbol
		if symbol in self.m_symbolList:
			lastColorValue = self.m_symbolList[symbol]
			self.m_symbolList[symbol] = self._updateVirtualColor(colorValue, lastColorValue)
		else:
			self.m_symbolList[symbol] = colorValue

#	def _parseInputFile(self, inputFile):
#		for line in open(inputFile):
#			self.m_fileCount += 1
#			self.m_fileList.append(line.strip())

	def _convertFilenameToColorValue(self, filename):
		filename_index = self.m_fileList.index(filename)
		return 10**filename_index

	def _updateVirtualColor(self, filenameColorValue, lastColorValue = 0):
		newValue = lastColorValue
		if filenameColorValue != 0:
			if ((lastColorValue / filenameColorValue) % 2) == 0:
				newValue = lastColorValue + filenameColorValue
		return newValue

	def _convertColorValueToFilename(self, colorValue):
		outputFilename = self.m_outputDir + "/"
		fileCount = len(self.m_fileList)
		for i in range(1, fileCount + 1):
			if (colorValue / (10**(fileCount - i)) % 2) == 0:
				outputFilename = outputFilename + "0"
			else:
				filename = self.m_fileList[fileCount-i]
				filename = filename.split("/")[len(filename.split("/"))-1]
				outputFilename = outputFilename + filename
			if i != (fileCount):
				outputFilename = outputFilename + "-"
		outputFilename += ".txt"
		return outputFilename

import sys

if __name__=="__main__":
        if len(sys.argv) < 2:
                print __doc__
                sys.exit(1)

# Fetch the filenames
filenames = []
fileCount = int(len(sys.argv)-1)
for i in range(1, fileCount):
	filenames.append(sys.argv[i+1])
	
outputDir = sys.argv[1]
vennParser = VennParser(filenames, outputDir)
vennParser.parseFiles()
vennParser.printSummary()
