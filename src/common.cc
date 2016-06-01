#include <stdexcept>
#include <fstream>
#include <cmath>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <string>
#include <assert.h>
#include <algorithm>
#include <sstream>
#include <sys/stat.h>
#include <map>

#include "common.h"

//typedef vector<vector<string> > strmat ;

//typedef struct { string name ; bool is_num; int strlen=0; strings strs; vector<double> ds ; } col_s;

bool is_num(string &s) { return s.size() == 0 || s[0] != '"' ; }

//const char white[] = " \t\r";


// TODO copy next 3 functions as a gist
string slurp(std::ifstream& in)
{

	    return static_cast<std::stringstream const&>(std::stringstream() << in.rdbuf()).str();
}

string slurp(const char * filename)
{
	std::ifstream ifs(filename, std::ifstream::in | std::ifstream::binary);
	string res = slurp(ifs);
	ifs.close();
	return res;
}


string slurp(const string &filename)
{
	std::ifstream ifs(filename.c_str(), std::ifstream::in | std::ifstream::binary);
	string res = slurp(ifs);
	ifs.close();
	return res;
}



string trim(const string& str, const string &junk)
{
	if(str.length() ==0) { return str;} ;
	size_t first = str.find_first_not_of(junk);
	if(first == string::npos) return "";
	size_t last = str.find_last_not_of(junk);
	return str.substr(first, (last-first+1));
}
				

// http://stackoverflow.com/questions/236129/split-a-string-in-c
// // TODO write a gist with next 2 functions
std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems) {
	    std::stringstream ss(s);
	        std::string item;
		    while (std::getline(ss, item, delim)) {
			            elems.push_back(item);
				        }
		        return elems;
}



std::vector<std::string> split(const std::string &s, char delim) 
{
	std::vector<std::string> elems;
	split(s, delim, elems);
	return elems;
}


void read_csv(vector<col_s> &cvecs)
{


	string raw = slurp("/home/mcarter/.fortran/STATSLIST/StatsList.csv");
	strings rows = split(raw, 13); // ^M - which is a little non-standard



	int nrows = rows.size();
	if(nrows <2) {
		string msg = string("read_csv() ERR: need at least 2 rows. Got: ") + std::to_string(nrows)  ;
		throw std::underflow_error(msg);
	}




	strmat m;
	for(auto r: rows) m.push_back(split(r, ','));

	strings hdr = m[0];
	int ncols = hdr.size();
	m.erase(m.begin()); // eliminate the header from the data

	for(int cnum = 0; cnum < ncols; cnum++){
		col_s cvec;
		cvec.name = hdr[cnum];
		cvec.is_num = is_num(m[0][cnum]);
		cvecs.push_back(cvec);
	}



	for(auto row: m) {
		//row.pop_back(); // last item is bogus
		//cout << ncols << " "  << row.size() << "\n" ;
		assert(ncols == row.size());

		for(int cnum=0; cnum < ncols; cnum++){
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

}
