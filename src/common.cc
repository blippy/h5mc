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
#include <iterator>
#include <sstream>
#include <sys/stat.h>
#include <map>

#include <boost/algorithm/string.hpp>

#include "common.hpp"

using std::cout;
using std::endl;

bool is_num(string &s) { return s.size() == 0 || s[0] != '"' ; }



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


void coldata::read()
{
	//colmap res;
	vector<col_s> cols;
	read_csv(cols);
	for(auto c:cols) {
		cells vals;
		if(c.is_num)
		       	for(auto v: c.ds) {vals.push_back(v); }
		else 			
			for(auto v: c.strs) vals.push_back(v);
		column[c.name] = vals;
	}
}

strings coldata::get_strings(string colname)
{
	strings res;
	cells cs = column[colname];
	for(auto s: cs) res.push_back(boost::get<string>(s));
	return res;
}


doubles coldata::get_doubles(string colname, double scale)
{
	doubles ds;
	cells cs = column[colname];
	for(auto v: cs) {
		double d = scale * boost::get<double>(v);
		if(std::isnan(d)) d = std::numeric_limits<double>::infinity();
		ds.push_back(d);
	}
	return ds;
}

void coldata::write_rec()
{

	// TODO abstract
	string filename = "/home/mcarter/.fortran/STATSLIST/StatsList.rec";
	std::ofstream ofs(filename.c_str(), std::ofstream::out);
	std::map<string, cells>::iterator it0 = begin(column);
	int num_rows = it0->second.size();
	//cout << num_rows  << endl;
	for(int i=0 ; i< num_rows; ++i) {
		//cout << "*" ;
		for(const auto& col: column) {
			using namespace boost;
			string fieldname = col.first;
			//boost::algorithm::replace(fieldname, "F.", "");
			replace_first(fieldname, "F.", "");
			ofs << fieldname << ": " ;
			cells cs = col.second;
			ofs << cs[i] << endl;
			//if(col.second.is_num) {
			//	ofs << col.second.ds[i]	<< endl;
			//}
			//cout << "." ;
		}
		ofs << endl;
	}
	ofs.close();

}
