#ifndef COMMON5_H
#define COMMON5_H

#include <vector>
#include <string>

#include "hdf5.h"

extern char h5name[];

typedef std::vector<double> doubles;
typedef std::vector<std::string> strings;
typedef std::vector<strings> strmat; // string matrix

void write_strings_h5(hid_t loc_id, const char *varname, const strings &strs);
void write_doubles_h5(hid_t loc_id, const char *varname, const doubles &ds);

#endif
