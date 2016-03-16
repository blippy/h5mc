#ifndef COMMON_H
#define COMMON_H

#include <vector>
#include <string>

#include "hdf5.h"

typedef std::vector<double> doubles;
typedef std::vector<std::string> strings;
typedef std::vector<strings> strmat; // string matrix

void write_doubles_h5(hid_t loc_id, const char *varname, const doubles &ds);

#endif
