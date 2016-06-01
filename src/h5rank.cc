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


#include <mcstats.h>

#include "common.h"

using std::cout;
using std::vector;
using std::string;

doubles get_doubles(std::map<string, col_s> colmap, string colname, double way)
{
	doubles ds;
	assert(colmap[colname].is_num);
	for(auto d: colmap[colname].ds) {
		double d1 = d * way;
		if(std::isnan(d1)) d1 = std::numeric_limits<double>::infinity();
		ds.push_back(d1);
	}

	return ds;
}


typedef struct { string epic; double ds1; double rank1; double ds2; 
	double rank2 ; double rank;
} resstruct;

bool rscomp(resstruct a, resstruct b)
{
	return a.rank < b.rank;
}

void dout(double d) 
{
	std::ostringstream s;
	s.precision(2);
	s.width(10);
	s << std::fixed;
	s <<  d;
	cout << s.str();
}

int main()
{
	//vector<string> epics = read_strings_h5(lid, "F.EPIC");
	vector<col_s> cols;
	read_csv(cols);

	std::map<string, col_s> colmap;
	for(auto c:cols) colmap[c.name] = c;


	//for(auto e: colmap["F.EPIC"].strs) cout << "*" << e << "*\n" ;

	doubles ds1 = get_doubles(colmap, "Gearing", 1);
	doubles rank1 = frank(ds1);
	doubles ds2 = get_doubles(colmap, "Yield", -1);
	doubles rank2 = frank(ds2);


	vector<resstruct> rs;
	for(auto i=0; i< ds1.size(); i++) {
		resstruct r;
		r.epic = colmap["F.EPIC"].strs[i];
		r.ds1 = ds1[i];
		r.rank1 = rank1[i];
		r.ds2 = ds2[i];
		r.rank2 = rank2[i];
		r.rank = r.rank1 + r.rank2;
		rs.push_back(r);
	}

	std::sort(rs.begin(), rs.end(), rscomp);

	cout << "DS1       RANK1     DS2       RANK2     RANK      EPIC\n" ;
	for(auto r:rs) {
		dout(r.ds1);
		dout(r.rank1);
		dout(r.ds2);
		dout(r.rank2);
		dout(r.rank);
		cout << " " << r.epic << "\n";
	}

	return EXIT_SUCCESS;
}

