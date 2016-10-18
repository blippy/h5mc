/*
 * print the relative 5y strength of each sector,
 * ignoring companies on AIM.
 *
 * The point is to identify the worst-performing sectors,
 * and then invest in them.
 */

#include <cmath>
#include <iostream>
#include <set>
#include <string>

#include <mcstats.h>

#include "common.hpp"

using namespace std;

int main()
{
	coldata cd;
	cd.read();
	cd.write_rec();

	strings indices = cd.get_strings("FTSE_Index");
	cells rs5s = cd.column["RS_5Year"];
	strings sects = cd.get_strings("F.Sector");
	set<string> sectors(sects.begin(), sects.end());
	for(const auto&s: sectors) {
		doubles ds;
		for(int i=0; i<indices.size(); ++i) {
			if(s != sects[i]) continue;
			if(indices[i] == "AIM") continue;
			double rs5 = boost::get<double>(rs5s[i]);
			if(isnan(rs5)) continue;
			//cout << rs5 << endl;
			ds.push_back(rs5);
		}
		sortd(ds);
		cout << quantile(ds, 0.5) << " " << s << endl;

		//cout << s << endl;
	}

	return 0;
}
