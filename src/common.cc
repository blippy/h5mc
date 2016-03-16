#include "common.h"


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
