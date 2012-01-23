#include <iostream>
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

using namespace std;

bool lineContainsNA(char* lineChipAnno);
void findMatchingLine(char* lineChipAnno,char* fileName, char* lineDavid);
void printMergedLine(char* lineChipAnno, char* lineDavid);

int main(int argc, char* argv[]) {
	// 1. Check arguments
	if (argc != 3) {
		cout << "Invalid number of arguments." << endl;
		exit(1);
	}	
	
	// 2. Open files
	ifstream inChipAnno(argv[1], ifstream::in);
	
	if (inChipAnno.is_open()) {
		char lineChipAnno[2048];

		// Print header
		//cout << "Before header..." << endl;
		inChipAnno.getline(lineChipAnno, 2047);
		cout << lineChipAnno << endl;

		// 3. For each lines in ChipAnno's file...
		while (inChipAnno.getline(lineChipAnno, 2047)) {
			// 3.1 Check if gene name was NA 	
			if (lineContainsNA(lineChipAnno)) {
				//cout << "Line contain NA" << endl;
				char lineDavid[2048];
				// 3.2 If it's NA, find corresponding field in 
				//     David's file and print merged line
				findMatchingLine(lineChipAnno, argv[2], lineDavid);
				//cout << "Found matching line" << endl;
				printMergedLine(lineChipAnno, lineDavid);
			}
			// 3.3 Else just print out the line as it is
			else {
				cout << lineChipAnno << endl;
			}
		}	
	}
	return 0;
}

bool lineContainsNA(char* lineChipAnno) {
	char* junk;
	char* geneSymbol;

	char lineToCheckNA[2048];
	strcpy(lineToCheckNA, lineChipAnno);

	junk = strtok(lineToCheckNA, "\t");
	junk = strtok(NULL, "\t");
	junk = strtok(NULL, "\t");
	junk = strtok(NULL, "\t");
	geneSymbol = strtok(NULL, "\t");
	
	if (strcmp(geneSymbol, "NA") == 0) {
		return true;
	} else return false;
}

void findMatchingLine(char* lineChipAnno,char* fileName, char* lineDavid) {
	char ENSG_ChipAnno[128];
	sscanf(lineChipAnno, "%s", ENSG_ChipAnno);

	ifstream inDavid(fileName, ifstream::in);

	if (inDavid.is_open()) {
		bool lineFound = false;
		while (lineFound == false && inDavid.getline(lineDavid, 2047)) {
			char ENSG_David[128];
			sscanf(lineDavid, "%s", ENSG_David);
			if (strcmp(ENSG_David, ENSG_ChipAnno) == 0) {
				lineFound = true;
			}
		}
		if (lineFound == false) {
			cout << "Could not find matching line in David's file: " 
			     << ENSG_ChipAnno << endl;
			exit(1);
		}
	}
}

void printMergedLine(char* lineChipAnno, char* lineDavid) {
	char* junk;
	char* feature;
	char* insideFeature;
	char* distance;
	char* numberOfTags;
	char* symbol;
	char* davidGeneName;
	char* refSeq;

	feature = strtok(lineChipAnno, "\t");
	insideFeature = strtok(NULL, "\t");
	distance = strtok(NULL, "\t");
	numberOfTags = strtok(NULL, "\t");
	symbol = strtok(NULL, "\t");
	junk = strtok(NULL, "\t");
	refSeq = strtok(NULL, "\t");
	
	junk = strtok(lineDavid, "\t");
	junk = strtok(NULL, "\t");
	junk = strtok(NULL, "\t");
	davidGeneName = strtok(NULL, "\t");

	cout << feature << "\t";
	cout << insideFeature << "\t";
	cout << distance << "\t";
	cout << numberOfTags << "\t";
	cout << symbol << "\t";
	cout << davidGeneName << "\t";
	cout << refSeq << "\t" << endl;
}
