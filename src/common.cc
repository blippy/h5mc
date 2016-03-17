#include <string.h>
#include <algorithm>

#include "common.h"


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
