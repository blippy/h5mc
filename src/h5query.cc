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

#include <boost/format.hpp>

#include <mcstats.h>

#include "common.h"

using std::cout;
using std::vector;
using std::string;



int main()
{
	coldata cd;
	cd.read();
	
	strings ftidx = cd.get_strings("FTSE_Index");
	doubles pes = cd.get_doubles("PER", 1);

	for(auto idxname : { "FTSE100", "FTSE250"}) {
		doubles ey;
		for(int i=0; i< ftidx.size(); i++) 
			if(ftidx[i] == idxname) ey.push_back( 1/pes[i]);
			
		//for(auto e: ey)  cout << e << "\n";

		sortd(ey);
		double eym = quantile(ey, 0.5);
		double pe = 1 / eym;
		cout << boost::format("%s %.4f %.4f\n") % idxname % pe % eym;
		//cout << idxname << " " << pe << " " 
	}


	return EXIT_SUCCESS;
}

