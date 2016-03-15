#include <iostream>
#include <stdio.h>
#include <vector>
#include <string>
#include <assert.h>
#include <algorithm>

#include "hdf5.h"


#include "common.h"

using std::cout;
using std::endl;
using std::vector;
using std::string;

using namespace H5;

//int ymain();
strmat bison_main();

typedef struct { string name ; bool is_num; int strlen=0; strings strs; vector<double> ds ; } col_s;

bool is_num(string &s) { return s.size() == 0 || s[0] != '"' ; }

//const char white[] = " \t\r";

string trim(const string& str, const string &junk)
{
	if(str.length() ==0) { return str;} ;
	size_t first = str.find_first_not_of(junk);
	if(first == string::npos) return "";
	size_t last = str.find_last_not_of(junk);
	return str.substr(first, (last-first+1));
}
				
void read_csv(strmat &sheet, vector<col_s> &cvecs)
{
	// we're guaranteed to have at least 2 rows at this point
	//int num_cols = 0;
	//vector<col_s> cvecs;

	// set up basic structure of columns
	for(int cnum = 0; cnum < sheet[0].size(); cnum++) {
		col_s cvec; 
		cvec.name = sheet[0][cnum]; 
		cvec.is_num = is_num(sheet[1][cnum]);
		cvecs.push_back(cvec); 
	}


	for(auto rit = sheet.begin()+1; rit < sheet.end(); rit++) {
		strings row = *rit;
		assert(row.size() == cvecs.size());
		for(int cnum=0 ; cnum < row.size(); cnum ++) {
			col_s &col = cvecs[cnum];
			string str = row[cnum];
			assert(is_num(str) == col.is_num);
			if(col.is_num) {
				double d = str.size() == 0 ? NAN : stod(str);
				col.ds.push_back(d);
			} else {
				string goo = " \"";
				string str1 = trim(str, goo);
				col.strlen = std::max(col.strlen, (int)str1.size());
				col.strs.push_back(str1);
			}
		}
	}

	for(auto c: cvecs) {
		cout << c.name << "\t" << c.is_num << "\t" << endl;
		if(c.is_num) { 
			for(auto d: c.ds) { cout << d << endl; }
		}
		else {
			cout << "string" << "\t" << c.strlen << endl;
			for(auto s: c.strs) { cout << s << endl;}
		}

	}

}

void write_h5(const vector<col_s> &cvecs)
{
	H5File* file = new H5File("/home/mcarter/foo.h5", H5F_ACC_RDWR);
	delete file;

}

int main()
{
	//ymain();
	strmat sheet = bison_main();
	/* sanity check */
	//for(auto r: sheet) { cout << "." ;}

	if(sheet.size() <2) { cout << "No data found" << endl; return EXIT_SUCCESS; }

	vector<col_s> cvecs;
	read_csv(sheet, cvecs);
	write_h5(cvecs);
	return EXIT_SUCCESS;

}