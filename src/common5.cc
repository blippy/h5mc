#include <string.h>
#include <algorithm>

#include "common5.h"

//char fname[] = "/home/mcarter/cubie/home/mcarter/data/sharelock.h5";
//char fname[] = "/home/mcarter/sharelock.h5";
char h5name[] = "/home/mcarter/.fortran/sharelock.h5";

//void write_strings_h5(gid, c,name.c_str(), c.strings)
void write_strings_h5(hid_t loc_id, const char *varname, const strings &strs)
{
	hsize_t dims[1] = { strs.size()};
	hid_t dspace = H5Screate_simple(1, dims, NULL);
	hid_t dtype = H5Tcopy(H5T_C_S1);

	int strlen = 0; // determine maximum size required to house strings
	for(auto s: strs) strlen = std::max(strlen, (int) s.size());
	H5Tset_size(dtype, strlen);
			
	char *data = (char *)calloc(strs.size(), strlen); // TODO what if calloc fails?
	for(int rnum =0; rnum < strs.size();  rnum++) { 
		strncpy(data + rnum*strlen, strs[rnum].c_str(), strs[rnum].size()); }

	hid_t dset = H5Dcreate2(loc_id, varname, dtype, dspace, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
	H5Dwrite(dset, dtype, H5S_ALL, H5S_ALL, H5P_DEFAULT, data);
	free(data);
	H5Dclose(dset);
	H5Sclose(dspace);
}

void write_doubles_h5(hid_t loc_id, const char *varname, const doubles &ds)
{
	hsize_t dims[1];
	dims[0] = ds.size();
	hid_t dspace = H5Screate_simple(1, dims, NULL);
	hid_t dset = H5Dcreate2(loc_id, varname, H5T_NATIVE_DOUBLE, dspace, 
					                          H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
	H5Dwrite(dset, H5T_NATIVE_DOUBLE, H5S_ALL, H5S_ALL, H5P_DEFAULT, &ds[0]);
	H5Dclose(dset);
	H5Sclose(dspace);
}
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

/* intended to be part of h5rank.cc, but I got fed up with HDF5
 */
int main1()
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
