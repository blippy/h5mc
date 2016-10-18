#pragma once

#include <map>
#include <string>
#include <vector>

#include "boost/variant.hpp"

using std::map;
using std::string;
using std::vector;

typedef boost::variant<double, string> cell;
typedef vector<cell> cells;

typedef vector<double> doubles;
typedef vector<string> strings;
typedef vector<strings> strmat ;

typedef struct col_s { string name ; bool is_num; int strlen=0; strings strs; vector<double> ds ; } col_s;

bool is_num(string &s);

string slurp(std::ifstream& in);
string slurp(const char * filename);
string slurp(const string &filename);
string trim(const string& str, const string &junk);
std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);
std::vector<std::string> split(const std::string &s, char delim);
void read_csv(vector<col_s> &cvecs);



class coldata {
	public:
		coldata() {};
		void read();
		void write_rec();
		//int num_rows = 0;
		doubles get_doubles(string colname, double scale);
		map<string, cells> column;
		strings get_strings(string colname);
};
