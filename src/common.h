#ifndef COMMON_H
#define COMMON_H


#include <string>
#include <vector>


using std::string;
using std::vector;

typedef vector<string> strings;
typedef vector<strings> strmat ;

typedef struct { string name ; bool is_num; int strlen=0; strings strs; vector<double> ds ; } col_s;

bool is_num(string &s);

string slurp(std::ifstream& in);
string slurp(const char * filename);
string slurp(const string &filename);
string trim(const string& str, const string &junk);
std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);
std::vector<std::string> split(const std::string &s, char delim);
void read_csv(vector<col_s> &cvecs);

#endif
