/**
 * \File fastqTrimmer.cpp
 *
 * \Author Charles Joly Beauparlant
 *
 * \Date 2012-01-09
 */

#include <iostream>
#include <fstream>
#include <assert.h>

using namespace std;

int countTrimmedSeqLength(char* seqToTrim);
void printSequence(char* seq, int length);

int main(int argc, char* argv[]) {
    if (argc == 2) {
        ifstream in(argv[1], ifstream::in);

        if (in.is_open()) {
	    while(!in.eof()) {
		char seqIdentifier[1024];
		char seqToTrim[1024];
		char seqSeparator[1024];
		char seqQuality[1024];

	        in.getline(seqIdentifier, 1023);
		in.getline(seqToTrim, 1023);
		in.getline(seqSeparator, 1023);
		in.getline(seqQuality, 1023);

		if (strlen(seqIdentifier) == 0) {
			break;
		}	
	
		int length = countTrimmedSeqLength(seqToTrim);
		
		assert(length<=strlen(seqToTrim));

		//if (!in.eof()) {
		    cout << seqIdentifier << '\n';
		    printSequence(seqToTrim, length);
		    cout << seqSeparator << '\n';
		    printSequence(seqQuality, length);
		//}
	    }
        }
    }
    return 0;
}

int countTrimmedSeqLength(char* seqToTrim) {
	int target = 4;
	
		
    /*int NCount = 0;
    int trimmedSeqLength = 0;
    int i = 0;

    while (seqToTrim[i] != '\n' && NCount != 4) {
	trimmedSeqLength++;
        if (seqToTrim[i] == 'N') {
            NCount++;
        }
        i++;
    }
    return trimmedSeqLength-1; */
}

void printSequence(char* seq, int length) {
	for (int i = 0; i < length; i++) {
	    cout << seq[i];
	}
	cout << '\n';
}
