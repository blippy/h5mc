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

#include <hdf5.h>


#include "common.hpp"
#include "common5.hpp"

using std::cout;
using std::endl;
using std::vector;
using std::string;



void write_h5(const vector<col_s> &cvecs)
{

	struct stat st;
	stat(h5name, &st);
	time_t t = st.st_mtime;
	struct tm atm;
	localtime_r(&t, &atm);
	char dtstamp[80];
	strftime(dtstamp, sizeof(dtstamp), "/D%Y%m%d", &atm);
	puts(dtstamp);

	hid_t file = H5Fopen(h5name, H5F_ACC_RDWR, H5P_DEFAULT);
	hid_t gid = H5Gcreate(file, dtstamp, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
	for(auto &c: cvecs) {
		if(c.is_num) {
			write_doubles_h5(gid, c.name.c_str(), c.ds);
			/*
			hsize_t dims[1];
			dims[0] = c.ds.size();
			hid_t dspace = H5Screate_simple(1, dims, NULL);
			hid_t dset = H5Dcreate2(gid, c.name.c_str(), H5T_NATIVE_DOUBLE, dspace, 
					                          H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
			H5Dwrite(dset, H5T_NATIVE_DOUBLE, H5S_ALL, H5S_ALL, H5P_DEFAULT, &c.ds[0]);
			H5Dclose(dset);
			H5Sclose(dspace);
			*/
		} else { // strings // TODO put to common.cc
			write_strings_h5(gid, c.name.c_str(), c.strs);
		} 

	}

	H5Gclose(gid);
	H5Fclose(file);

}

int main()
{
	//ymain();
	//strmat sheet = bison_main();
	/* sanity check */
	//for(auto r: sheet) { cout << "." ;}

	//if(sheet.size() <2) { cout << "No data found" << endl; return EXIT_SUCCESS; }

	vector<col_s> cvecs;
	read_csv(cvecs);
	//puts("TODO write to HDF5");
	//return EXIT_FAILURE;
	write_h5(cvecs);
	return EXIT_SUCCESS;

}
