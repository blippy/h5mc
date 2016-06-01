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

#include "hdf5.h"

#include <mcstats.h>

#include "common.h"

using std::cout;
using std::vector;
using std::string;

vector<double> read_doubles_h5(hid_t lid, const char *dset_name)
{
	herr_t status;
	hid_t did = H5Dopen2(lid, dset_name, H5P_DEFAULT);
	hid_t space = H5Dget_space(did);
	size_t nelmts = H5Sget_simple_extent_npoints(space);	

	//cout << nelmts << "\n";
	double *ds = new double [nelmts];
	status = H5Dread(did, H5T_NATIVE_DOUBLE, H5S_ALL, H5S_ALL, H5P_DEFAULT, ds);

	status = H5Sclose(space);
	status = H5Dclose(did);

	vector<double> res;
	for(size_t i =0; i< nelmts; i++) res.push_back(ds[i]);

	delete[] ds;
	return res;
}

vector<string> read_strings_h5(hid_t lid, const char *dset_name)
{
	herr_t status;
	hid_t did = H5Dopen2(lid, dset_name, H5P_DEFAULT);
	hid_t space = H5Dget_space(did);
	size_t nelmts = H5Sget_simple_extent_npoints(space);

	hid_t tid = H5Dget_type(did);
	size_t width = H5Tget_size(tid);
	hid_t htype = H5Tget_native_type(did, H5T_DIR_ASCEND);
	//cout << width << "\n";

	char *cs = (char *) malloc(nelmts * width);
	status = H5Dread(did, htype, H5S_ALL, H5S_ALL, H5P_DEFAULT, cs);

	//cout << cs;

	status = H5Tclose(tid);
	status = H5Sclose(space);
	status = H5Dclose(did);

	vector<string> res;
	//char s[width];
	for(size_t i =0; i< nelmts; i++) {
		string s;
		for(size_t j=0; j<width; j++) {
			//s.push_back(cs[i*width + j]);
			s += cs[i*width +j];
		}
		//std::copy(cs + i * width, cs + (i+1)*width, s);
		cout << s<< "\n";
	       	res.push_back(s);
	}

	free(cs);
	return res;
	
}
int main()
{

	herr_t status;
	hid_t fid = H5Fopen(h5name, H5F_ACC_RDONLY, H5P_DEFAULT);

	hid_t lid = H5Gopen2(fid, "/D20160601", H5P_DEFAULT);
	
	vector<string> epics = read_strings_h5(lid, "F.EPIC");
	for(auto e:epics) cout << "*" << e << "*\n" ;

	vector<double> ds1 = read_doubles_h5(lid, "Gearing");
	vector<double> rank1 = frank(ds1);
	//for(auto d:rank1) cout << d << "\n" ;
	
	vector<double> ds2 = read_doubles_h5(lid, "Yield");
	vector<double> ds2a;
	for(auto d:ds2) ds2a.push_back(-d);
	vector <double> rank2 = frank(ds2a);

	// combine the ranks
	vector<double> rank;
	for(int i=0; i<rank1.size(); i++) rank.push_back(rank1[i] + rank2[i]);

	// print the results
	puts("TODO: something wrong with extracting epics. Should prolly stick to using StatsList.csv");
	

	status = H5Gclose(lid);
	//status = H5Dclose(lid);
	status = H5Fclose(fid);

	return EXIT_SUCCESS;
}
