#include <iostream>
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

using namespace std;

// Notes:
// argv[1] -> unique or overlap
// argv[2] -> file1
// argv[3] -> file2
// Files must be sorted!

bool lineMatch(char* geneNumber, char* fileName);
void printENSG(char*geneNumber, char* fileName);

int main(int argc, char* argv[]) {
	char uniqueOrOverlap[32];
	char nameFile1[1024];
	char nameFile2[1024];

	strcpy(uniqueOrOverlap, argv[1]);
	strcpy(nameFile1, argv[2]);
	strcpy(nameFile2, argv[3]);

	// 1. Check arguments
	if (argc != 4) {
		cout << "Invalid number of arguments." << endl;
		exit(1);
	}	

	// 2. Open files
	ifstream inFile1(nameFile1, ifstream::in);
	
	if (inFile1.is_open()) {
		char line[2048];

		// Print header
		inFile1.getline(line, 2047);
		cout << line << endl;

		// 3. For each lines in File1...
		char oldENSG[128];
		oldENSG[0] = '\0';
		while (inFile1.getline(line, 2047)) {
			// 3.1 Fetch lineENSG
			char lineENSG[128];
			sscanf(line, "%s", lineENSG);

			if (strcmp(lineENSG, oldENSG) != 0) { // if they are equal, we already analysed them...
				bool isMatching = lineMatch(lineENSG, nameFile2);
				if (isMatching == false && strcmp(uniqueOrOverlap, "unique") == 0)  {
						//cout << line << endl;	
						printENSG(lineENSG, nameFile1);
				}	
				if (isMatching == true && strcmp(uniqueOrOverlap, "overlap") == 0)  {
						//cout << line << endl;	
						printENSG(lineENSG, nameFile1);
				}	
				strcpy(oldENSG, lineENSG);
			}
		}
		/*
		while (inFile1.getline(line, 2047)) {
			// 3.1 Fetch geneNumber
			char lineENSG[128];
			sscanf(line, "%s", lineENSG);
			cout << "Looking for: " << lineENSG << endl;
			bool isMatching = lineMatch(lineENSG, nameFile2);
			if (isMatching == false && strcmp(uniqueOrOverlap, "unique") == 0)  {
					//cout << line << endl;	
			}	
			if (isMatching == true && strcmp(uniqueOrOverlap, "overlap") == 0)  {
					//cout << line << endl;	
			}	
		}
		*/
	}	

	return 0;
}

bool lineMatch(char* lineENSG, char* fileName) {
	ifstream inFile2(fileName, ifstream::in);
	char line[2048];
	bool matchFound = false;
	char lineENSG2[128];

	while (matchFound == false && inFile2.getline(line, 2047)) {
		sscanf(line, "%s", lineENSG2); 
		if (strcmp(lineENSG, lineENSG2) == 0) {
			//cout << "Found match: " << lineENSG2 << endl;
			matchFound = true;
		}
	} 

	return matchFound;
}

void printENSG(char*geneNumber, char* fileName) {
	ifstream inFile(fileName, ifstream::in);
	char line[2048];	
	
	while (inFile.getline(line, 2047)) {
		char ENSG[128];
		sscanf(line, "%s", ENSG);
		if (strcmp(ENSG, geneNumber) == 0) {
			cout << line << endl;
		}
	}
}
