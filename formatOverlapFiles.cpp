#include <iostream>
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <vector>

using namespace std;

// Notes:
// // argv[1] -> file1
// // argv[2] -> file2

struct lineStruct {
	char line[2048];
};

vector<lineStruct> convertFileToVector(char* fileName);
void  findLastENSG(vector<lineStruct>::iterator i_begin, vector<lineStruct>::iterator& i_end, vector<lineStruct> v_file);
vector<lineStruct> convertIteratorsToVector(vector<lineStruct>::iterator i_begin, vector<lineStruct>::iterator i_end);
void printVector(vector<lineStruct> v_sequences);
void printSeparator(vector<lineStruct> v_sequences1, vector<lineStruct> v_sequences2);
bool areIdentical(vector<lineStruct> v_sequences1, vector<lineStruct> v_sequences2);
void extractENSG(char* line, char* ENSG);

int main(int argc, char* argv[]) {
	// Fetch files infos
	vector<lineStruct> v_file1 = convertFileToVector(argv[1]);
	vector<lineStruct> v_file2 = convertFileToVector(argv[2]);

	// Point to 1st ENSG in file1 and file2
	vector<lineStruct>::iterator i_begin1 = v_file1.begin();
	vector<lineStruct>::iterator i_begin2 = v_file2.begin();

	// Print header
	cout << i_begin1->line << endl;
	i_begin1++;
	i_begin2++;

	while (i_begin1 != v_file1.end()) {
		//cout << "Entering while..." << endl;
		// Find last ENSG that is the same as i_begin1 and i_begin2
		vector<lineStruct>::iterator i_end1; 
		findLastENSG(i_begin1, i_end1, v_file1);

		//cout << "Before convertIteratorsToVector" << endl;
		vector<lineStruct> v_sequences1 = convertIteratorsToVector(i_begin1, i_end1);

		//cout << "Between sequence 1 and 2" << endl;

		vector<lineStruct>::iterator i_end2;
		findLastENSG(i_begin2, i_end2, v_file2);
		vector<lineStruct> v_sequences2 = convertIteratorsToVector(i_begin2, i_end2);

		// Print infos
		cout << "Case:\t\t\t\t\t\t" << endl;
		printVector(v_sequences1);
		cout << "Control:\t\t\t\t\t\t" << endl;
		printVector(v_sequences2);
		printSeparator(v_sequences1, v_sequences2);

		// Go to next ENSG
		i_begin1 = i_end1 + 1;
		i_begin2 = i_end2 + 1;
	}

	return 0;
}

vector<lineStruct> convertFileToVector(char* fileName) {
	ifstream inFile(fileName, ifstream::in);
	vector<lineStruct> fileVector;
	lineStruct lineS;
	
	if (inFile.is_open()) {
		while (inFile.getline(lineS.line, 2047))
			fileVector.push_back(lineS);
	} else {
		cout << "Error opening file: " << fileName << endl;
	}
	return fileVector;
}

void  findLastENSG(vector<lineStruct>::iterator i_begin, vector<lineStruct>::iterator& i_end, vector<lineStruct> v_file) {
	char ENSG1[128];
	char ENSG2[128];
	char line1[2048];
	char line2[2048];

	//cout << "findLastENSG begin..." << endl;
	strcpy(line1, i_begin->line);
	//cout << line1 << endl;

	// Fetch ENSG1
	//sscanf(line1, "%s", ENSG1);
	extractENSG(line1, ENSG1);
	//cout << "Yes!" << endl;
	//cout << "ENSG1: " << ENSG1;
	//cout << "Yes!" << endl;

	// Find last ENSG in v_file that corresponds to ENSG1
	i_end = i_begin + 1;
	strcpy(line2, i_end->line);
	//sscanf(line2, "%s", ENSG2);
	extractENSG(line2, ENSG2);
		//cout << "What up?" << endl;	
	//cout << "ENSG2: " << ENSG2 << endl;

	//if (strcmp(ENSG1, ENSG2) != 0) return i_begin;
	
	while (i_end != v_file.end() && strcmp(ENSG1, ENSG2) == 0) {
		i_end++;
		strcpy(line2, i_end->line);
		//sscanf(line2, "%s", ENSG2);
		extractENSG(line2, ENSG2);
		//cout << "ENSG2: " << ENSG2 << endl;
	}
	//cout << "test" << endl;
	i_end--;
}

vector<lineStruct> convertIteratorsToVector(vector<lineStruct>::iterator i_begin, vector<lineStruct>::iterator i_end) {
	vector<lineStruct> v_sequences;
	
	lineStruct ls;
	strcpy(ls.line, i_begin->line);
	v_sequences.push_back(ls);

	for (int i = 0; i < i_end - i_begin; i++) {
		//cout << "In for loop..." << endl;
		i_begin++;
		
		lineStruct ls;
		strcpy(ls.line, i_begin->line);
		v_sequences.push_back(ls);
	}
/*	
	while (i_begin != i_end) {
		cout << "In while loop..." << endl;
		lineStruct ls;
		strcpy(ls.line, i_begin->line);
		v_sequences.push_back(ls);
	}*/
	return v_sequences;
}

void printVector(vector<lineStruct> v_sequences) {
	for (vector<lineStruct>::iterator it = v_sequences.begin(); it != v_sequences.end(); it++) {
		cout << it->line << endl;
	}
}

void printSeparator(vector<lineStruct> v_sequences1, vector<lineStruct> v_sequences2) {
	if (areIdentical(v_sequences1, v_sequences2)) {
		cout << "Perfect match: yes" << endl;
	} else {
		cout << "Perfect match: no" << endl;
	}
	cout << "----------\t\t\t\t\t\t" << endl;
}

bool areIdentical(vector<lineStruct> v_sequences1, vector<lineStruct> v_sequences2) {
	bool answer = true;

	if (v_sequences1.size() == v_sequences2.size())  {
		for (unsigned int i = 0; i < v_sequences1.size(); i++) {
			if (strcmp(v_sequences1[i].line, v_sequences2[i].line) != 0) {
				answer = false;
			}	
		}
	} else {
		answer = false;
	}
	return answer;
}

void extractENSG(char* line, char* ENSG) {
	//cout << "Huh?" << endl;
	int i = 0;
	do {
		//cout << "Huh?" << endl;
		ENSG[i] = line[i];
		ENSG[i+1] = '\0';
		//cout << ENSG << endl;
		i++;
	} while (i < 16);
	//cout << "Huh?" << endl;
}
